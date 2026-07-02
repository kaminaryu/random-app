import 'package:flutter/material.dart';
import 'package:i_bazaar/widgets/main/main_app_bar.dart';
import 'package:i_bazaar/widgets/main/main_nav_bar.dart';


class MainScreen extends StatefulWidget {
  const MainScreen({super.key, required this.currentPath, required this.child});

  final Widget child;
  final String currentPath;

  @override
  State<MainScreen> createState() => _MainScreenState(); 
}

class _MainScreenState extends State<MainScreen> {
  static const List<String> _tabOrder = ['/', '/search', '/listings', '/profile'];

  int _previousIndex = -1;

  @override
  Widget build(BuildContext context) {
    final currentIndex = _tabOrder.indexOf(widget.currentPath);
    final goingRight = currentIndex > _previousIndex;

    _previousIndex = currentIndex;

    return Scaffold(
      appBar: MainAppBar(),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        transitionBuilder: (child, animation) {
          final offset = Tween<Offset>(
            begin: Offset(goingRight ? 1.0 : -1.0, 0.0),
            end: Offset.zero,
          ).animate(animation);

          return SlideTransition(position: offset, child: child);
        },
        child: KeyedSubtree(
          key: ValueKey(widget.currentPath),
          child: widget.child,
        ),
      ),
      bottomNavigationBar: MainNavBar(),
    );
  }
}
