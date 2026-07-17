import 'package:flutter/material.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/screens/main/cart/widget/cart_card.dart';
import 'package:i_bazaar/services/cart_handler.dart';
import 'package:i_bazaar/widgets/main/main_app_bar.dart';
import 'package:i_bazaar/widgets/not_signed_in_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Item> _items = [];
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

    setState(() => _isLoading = true);
    final items = await CartHandler.fetchRangedCartItems(
      page: _page,
      userId: user.id,
    );
    if (!mounted) return;
    setState(() {
      _items = items;
      _isLoading = false;
    });
  }

  void _toggleItemSelection(String itemId) {
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
    Iterable<Item> selectedItems = _items.where((item) => _selectedItemIds.contains(item.id));

    for (final item in selectedItems) {
      total += item.price * item.amountInCart;
    }
    return total;
  }

  Widget _buildCartList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_items.isEmpty) {
      return const Center(child: Text('Your cart is empty'));
    }

    return ListView.builder(
      padding: EdgeInsets.only(
        top: 8,
        bottom: 64 + MediaQuery.of(context).padding.bottom,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final Item item = _items[index];
        return CartCard(
          item: item,
          isSelected: _selectedItemIds.contains(item.id),
          toggleItemSelection: (itemId) => _toggleItemSelection(itemId),
          onDelete: _fetchCart,
        );
      },
    );
  }

  Widget _buildGrandTotalBar() {
    if (_items.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 12,
        bottom: 12 + MediaQuery.of(context).padding.bottom,
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
          Text(
            'Total',
            style: theme.textTheme.titleMedium,
          ),
          Text(
            'RM${_grandTotal.toStringAsFixed(2)}',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
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
