import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MainNavBar extends StatefulWidget {
  const MainNavBar({super.key});

  @override
  State<MainNavBar> createState() => _MainNavBarState();
}

class _MainNavBarState extends State<MainNavBar> {
  int currentPage = 0;

  void changePage(int page) {
    switch (page) {
      case 0: context.go("/home");
      case 1: context.go("/search");
      case 2: context.go("/listings");
      case 3: context.go("/profile");
    }
    setState(() {
      currentPage = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentPage,
      onTap: changePage,
      backgroundColor: Color(0xFF1A1740),
      selectedItemColor: Color(0xFF7F77DD),
      unselectedItemColor: Color(0xFFCECBF6),

      items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.search), label: "Search"),
        BottomNavigationBarItem(icon: Icon(Icons.sell), label: "Listings"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
