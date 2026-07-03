import 'package:flutter/material.dart';
import 'package:i_bazaar/widgets/main/main_app_bar.dart';
import 'package:i_bazaar/widgets/main/main_nav_bar.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(),
      body: child,
      bottomNavigationBar: MainNavBar(),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:i_bazaar/widgets/main/main_app_bar.dart';
// import 'package:i_bazaar/widgets/main/main_nav_bar.dart';
//
// class MainScreen extends StatefulWidget {
//   const MainScreen({super.key, required this.currentPath, required this.child});
//
//   final Widget child;
//   final String currentPath;
//
//   @override
//   State<MainScreen> createState() => _MainScreenState();
// }
//
// class _MainScreenState extends State<MainScreen>
//     with SingleTickerProviderStateMixin {
//   static const List<String> _tabOrder = ['/', '/search', '/listings', '/profile'];
//
//   late final AnimationController _slideController;
//   bool _goingRight = true;
//
//   @override
//   void initState() {
//     super.initState();
//     _slideController = AnimationController(
//       duration: const Duration(milliseconds: 300),
//       vsync: this,
//     )..value = 1.0;
//   }
//
//   @override
//   void didUpdateWidget(MainScreen oldWidget) {
//     super.didUpdateWidget(oldWidget);
//     if (oldWidget.currentPath != widget.currentPath) {
//       _goingRight =
//           _tabOrder.indexOf(widget.currentPath) >
//           _tabOrder.indexOf(oldWidget.currentPath);
//       _slideController.reset();
//       _slideController.forward();
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final offset = Tween<Offset>(
//       begin: Offset(_goingRight ? 0.1 : -0.1, 0.0),
//       end: Offset.zero,
//     ).animate(
//       CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
//     );
//
//     return Scaffold(
//       appBar: MainAppBar(),
//       body: SlideTransition(position: offset, child: widget.child),
//       bottomNavigationBar: MainNavBar(),
//     );
//   }
//
//   @override
//   void dispose() {
//     _slideController.dispose();
//     super.dispose();
//   }
// }
