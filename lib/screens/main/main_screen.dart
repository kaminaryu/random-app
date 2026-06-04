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
