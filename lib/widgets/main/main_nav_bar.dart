import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavBar extends StatelessWidget {
  const MainNavBar({super.key});

  static const List<String> _tabOrder = ['/', '/search', '/listings', '/profile'];

  @override
  Widget build(BuildContext context) {
    final uri = GoRouterState.of(context).uri.toString();
    final currentIndex = _tabOrder.indexOf(uri);

    return BottomNavigationBar(
      currentIndex: currentIndex == -1 ? 0 : currentIndex,
      onTap: (page) {
        switch (page) {
          case 0: context.go("/");
          case 1: context.go("/search");
          case 2: context.go("/listings");
          case 3: context.go("/profile");
        }
      },
      backgroundColor: const Color(0xFF1A1740),
      selectedItemColor: const Color(0xFF7F77DD),
      unselectedItemColor: const Color(0xFFCECBF6),
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.sell), label: "My Listings"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
