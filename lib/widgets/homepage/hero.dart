import 'package:flutter/material.dart';

class HomeHero extends StatelessWidget {
  const HomeHero({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 72),
      margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      decoration: BoxDecoration(
        color: Colors.grey.withAlpha(67),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.grey.withAlpha(125),
          width: 1,
        )
      ),

      child: Column( 
        children: [
          Text("Hero Section"),
        ],
      )
    );
  }
}
