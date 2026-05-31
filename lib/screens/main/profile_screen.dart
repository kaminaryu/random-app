import 'package:flutter/material.dart';
import 'package:i_bazaar/widgets/homepage/user_profile.dart';
import 'package:i_bazaar/widgets/main/main_app_bar.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            UserProfile(),
          ],
        ),
      ),
    );
  }
}
