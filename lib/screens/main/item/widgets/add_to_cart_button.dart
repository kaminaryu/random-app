import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/models/item.dart';
import 'package:i_bazaar/screens/main/item/widgets/add_to_cart_dialog.dart';
import 'package:i_bazaar/services/cache_handler.dart';
import 'package:i_bazaar/services/cart_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AddToCartButton extends StatelessWidget {
  const AddToCartButton({
    super.key,
    required this.price,
    required this.item,
  });

  final double price;
  final Item item;

  Widget _buildAddToCartButton(ThemeData theme, BuildContext context, User user) {
    return SizedBox(
      width: double.infinity,
      height: 64,

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: FloatingActionButton.extended(
          onPressed: () => showDialog(
            context: context,
            builder: (dialogContext) => AddToCartDialog(
              item: item,
              onConfirm: (amount) {
                CacheHandler.removeCartItemsFromCache(user.id);
                CartHandler.addItemToCart(itemId: item.id, quantity: amount);
              },
            ),
          ),

          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,

          icon: Icon(
            Icons.shopping_cart,
            size: 24
          ),
          label: Text(
            'Add to Cart   I   RM${price.toStringAsFixed(2)}',
            style: TextStyle(
              fontSize: 22,
            )
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtonToLogin(ThemeData theme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 64,

      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: FloatingActionButton.extended(
          onPressed: () => context.push("/login"),

          backgroundColor: theme.colorScheme.primary,
          foregroundColor: Colors.white,

          icon: Icon(
            Icons.login,
            size: 24
          ),
          label: Text(
            "Sign in to Start Shopping!",
            style: TextStyle(
              fontSize: 22,
            )
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final supabase = Supabase.instance.client;

    return StreamBuilder<AuthState>(
      stream: supabase.auth.onAuthStateChange,
      builder: (context, snapshot) {
        bool loggedIn = false;

        // check if the user is logged in
        if (snapshot.connectionState == ConnectionState.waiting) {
          // if connection still not resolve, put loading screen
          return Center(child: CircularProgressIndicator());
        }
        else {
          // if finished loading, check if user sess exist
          loggedIn = (snapshot.data?.session != null);
        }

        final user = Supabase.instance.client.auth.currentUser;


        // hide login button if user if loggedIN
        if (loggedIn) {
          return _buildAddToCartButton(theme, context, user!);
        }
        return _buildActionButtonToLogin(theme, context);
      }
    );
  }
}
