import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';


// PreferredSizeWidget is an interface that have fixed height
// Must have for AppBar() and shi
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key, this.label});

  final String? label;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
 
      // center
      title: TextButton(
        onPressed: () => context.go("/"),
        child: Text(
          label ?? "i-Bazaar",
          style: TextStyle(
            color: Colors.white,
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

            // check if the user is logged in
            if (snapshot.connectionState == ConnectionState.waiting) {
              // if the user exist == logged in
              loggedIn = (Supabase.instance.client.auth.currentUser != null);
            }
            else {
              // if the data exist == logged in
              loggedIn = (snapshot.data?.session != null);
            }

            // change to cart icon when logged out
            if (loggedIn) {
              return Padding(
                padding: EdgeInsets.only(right: 16.0),
                  child: IconButton(
                  onPressed: () => context.push("/cart"),
                  icon: Icon(Icons.shopping_cart),
                  tooltip: "Cart",
                  color: Theme.of(context).colorScheme.onPrimary,
                )
              );
            }

            return ElevatedButton(
              onPressed: () => context.push("/login"),

              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0x67676767),
                foregroundColor: Colors.white,
              ),

              child: Text("Login"),
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
