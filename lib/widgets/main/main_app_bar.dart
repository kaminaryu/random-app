import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';


// PreferredSizeWidget is an interface that have fixed height
// Must have for AppBar()
class MainAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Color(0xFF5A189A),
 
      // left side
      title: TextButton(
        onPressed: () => context.go("/"),
        child: Text(
          "i-Bazaar",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          )
        ),
      ),
      centerTitle: false,

      // right side
      actions: [
        ElevatedButton(
          onPressed: () => context.push("/login"),

          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0x67676767),
            foregroundColor: Colors.white,
          ),

          child: Text("Login"),
        )
      ],

    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
  // a getter, value calculated dynamically, like lambda func but looks like var
}
