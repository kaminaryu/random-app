import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:i_bazaar/services/cart_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// PreferredSizeWidget is an interface that have fixed height
// Must have for AppBar() and shi
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, this.label});

  final String? label;

  Widget _buildCartIcon(BuildContext context, User? user) {
    return ValueListenableBuilder(
      valueListenable: CartHandler.totalCartItem,
      builder: (cartIconContext, value, child) {
        return Padding(
          padding: EdgeInsets.only(right: 16.0),
          child: IconButton(
            onPressed: () => context.push("/cart"),
            icon: (value == 0) 
              ? Icon(Icons.shopping_cart)
              : Badge.count(
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  textColor: Theme.of(context).colorScheme.onPrimaryContainer,
                  count: value,
                  maxCount: 99,
                  child: Icon(Icons.shopping_cart),
                ),
            tooltip: "Cart",
            color: Theme.of(context).colorScheme.onPrimary,
          )
        );
      }
    );
  }


  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      foregroundColor: Theme.of(context).colorScheme.onPrimary,
 
      // center
      title: TextButton(
        onPressed: () => context.go("/"),
        child: Text(
          label ?? "i-Bazaar",
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimary,
            fontSize: 20,
          )
        ),
      ),
      centerTitle: true,

      // right side
      actions: [
        StreamBuilder<AuthState>(
          stream: Supabase.instance.client.auth.onAuthStateChange,
          builder: (context, snapshot) {
            bool loggedIn = false;
            final String currentURI = GoRouterState.of(context).uri.toString();
            final User? user = Supabase.instance.client.auth.currentUser;

            // check if the user is logged in
            if (snapshot.connectionState == ConnectionState.waiting) {
              // if the user exist == logged in
              loggedIn = (user != null);
            }
            else {
              // if the data exist == logged in
              loggedIn = (snapshot.data?.session != null);
            }

            // change to cart icon when logged out
            if (loggedIn) {
              if (currentURI == "/cart") {
                return SizedBox();
              }

              // fetch cart items first
              CartHandler cartHandler = CartHandler(user!.id);
              cartHandler.fetchCart();

              return _buildCartIcon(context, user);
            }

            return Padding(
              padding: EdgeInsets.only(right: 16.0),
              child: ElevatedButton(
                onPressed: () => context.push("/login"),

                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.tertiary,
                  foregroundColor: Colors.white,
                ),

                child: Text("Login"),
              ),
            );
          }
        )
      ],
    );
  }

  @override
  // a getter, value calculated dynamically, like lambda func but looks like var
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
