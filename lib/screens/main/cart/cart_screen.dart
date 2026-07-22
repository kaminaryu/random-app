import 'package:flutter/material.dart';
import 'package:i_bazaar/models/cart_item.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/screens/main/cart/widget/cart_card.dart';
import 'package:i_bazaar/services/cart_handler.dart';
import 'package:i_bazaar/services/catalog_handler.dart';
import 'package:i_bazaar/widgets/main/main_app_bar.dart';
import 'package:i_bazaar/widgets/not_signed_in_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<CartItem> _cart = [];
  List<Item> _itemsInCart = [];
  Set<String> _selectedItemIds = {};
  bool _isLoading = true;
  static const _page = 1;

  @override
  void initState() {
    super.initState();
    _fetchCart();
  }

  Future<void> _fetchCart() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    final CartHandler cartHandler = CartHandler(user.id);
    final List<CartItem> cart = await cartHandler.fetchCart();
    final List<String> itemIds = cart.map((cartItem) => cartItem.itemId).toList();

    setState(() => _isLoading = true);

    List<Item> itemsInCart = await CatalogHandler.fetchItemsByIds(itemIds);

    if (!mounted) return;

    setState(() {
      _itemsInCart = itemsInCart;
      _cart = cart;
      _isLoading = false;
    });
  }

  void _toggleItemSelection(String itemId) {
    debugPrint("selected IDs:");
    for (final i in _selectedItemIds) {
      debugPrint(i);
    }

    setState(() {
      if (_selectedItemIds.contains(itemId)) {
        _selectedItemIds.remove(itemId);
      }
      else {
        _selectedItemIds.add(itemId);
      }
    });
  }


  double get _grandTotal {
    double total = 0.0;
    List<Item> selectedItems = _itemsInCart.where((item) => _selectedItemIds.contains(item.id)).toList();

    for (final item in selectedItems) {
      // find the item inside the cart for amount in cart
      final List<CartItem> cartItem = _cart.where((cartItem) => cartItem.itemId == item.id).toList();
      if (cartItem.isEmpty) continue; // check if the item is not in cart a.k.a item entry is deleted from cart

      total += item.price * cartItem.first.amount;
    }
    return total;
  }

  int get _totalSelectedItems {
    List<Item> selectedItems = _itemsInCart.where((item) => _selectedItemIds.contains(item.id)).toList();
    return selectedItems.length;
  }


  Future<void> _changeAmountInCart(Item item, int amountDelta) async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user == null) return;

    setState(() {
      // get the cart item via ID
      final CartItem cartItem = _cart.where((cartItem) => cartItem.itemId == item.id).first;
      cartItem.amount += amountDelta;
    });

    await CartHandler.saveToStorage();
  }
  

  Future<void> _deleteCartItem(String itemId) async {
    final User? user = Supabase.instance.client.auth.currentUser;
    if (user == null) throw "User is not signed in";

    final CartHandler cartHandler = CartHandler(user.id);
    await cartHandler.removeItemFromCart(itemId);

    _fetchCart();
  }


  Future<void> _checkout() async {
    final SupabaseClient supabase = Supabase.instance.client;
    List<Item> selectedItems = _itemsInCart.where((item) => _selectedItemIds.contains(item.id)).toList();
    List<Map<String, dynamic>> checkoutItems = [];

    for (final item in selectedItems) {
      // find the item inside the cart
      final List<CartItem> cartItem = _cart.where((cartItem) => cartItem.itemId == item.id).toList();
      if (cartItem.isEmpty) continue; // check if the item is not in cart a.k.a item entry is deleted from cart

      checkoutItems.add({'id': item.id, 'qty': cartItem.first.amount});
    }

    try {
      await supabase.rpc('checkout_cart', params: {'items': checkoutItems});

      for (final item in selectedItems) {
        _deleteCartItem(item.id);
      }
    } on PostgrestException catch (e) {

      debugPrint('Checkout failed: ${e.message}');
      // NOTE: add proper snackbar here
    }
  }

  ////////////////////
  ///// WIDGETS //////
  ////////////////////

  Widget _buildCartList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_itemsInCart.isEmpty) {
      return const Center(child: Text('Your cart is empty'));
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 64 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: _itemsInCart.length,
      itemBuilder: (context, index) {
        final Item item = _itemsInCart[index];
        final CartItem cartItem = _cart.where((cartItem) => cartItem.itemId == item.id).first;

        return CartCard(
          item: item,
          amount: cartItem.amount,
          isSelected: _selectedItemIds.contains(item.id),
          toggleItemSelection: () => _toggleItemSelection(item.id),
          changeAmountInCart: (item, amountDelta) => _changeAmountInCart(item, amountDelta),
          onDelete: () => _deleteCartItem(item.id),
        );
      },
    );
  }

  Widget _buildGrandTotalBar() {
    // hide this bar if theres no items
    if (_itemsInCart.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom, // phone bottom padding
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(color: theme.colorScheme.outlineVariant),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // the price total
          Column(
            children: [
              Text(
                'Total',
              ),
              Text(
                'RM${_grandTotal.toStringAsFixed(2)}',
                style: TextStyle(
                  color: Colors.green,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),

          // the checkout button
          ElevatedButton(
            onPressed: (_totalSelectedItems > 0) ? _checkout : null,
            style: ElevatedButton.styleFrom(
              foregroundColor: theme.colorScheme.onPrimary,
              backgroundColor: theme.colorScheme.primary,
            ),
            child: Row(
              spacing: 8.0,
              children: [
                Icon(
                  Icons.shopping_cart,
                ),

                Text(
                  "Checkout",
                )
              ],
            )
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<AuthState>(
      stream: Supabase.instance.client.auth.onAuthStateChange,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.data?.session == null) {
          return const NotSignedInScreen();
        }
        return Scaffold(
          appBar: MainAppBar(label: "Cart"),
          body: Column(
            children: [
              Expanded(child: _buildCartList()),
              _buildGrandTotalBar(),
            ],
          ),
        );
      },
    );
  }
}
