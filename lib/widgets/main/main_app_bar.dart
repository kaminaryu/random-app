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
      backgroundColor: Color(0xFF5A189A),
 
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

          // hide login button if user if loggedIN
            if (loggedIn) {
              return SizedBox.shrink();
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
