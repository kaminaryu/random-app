import 'package:flutter/material.dart';

class AuthErrorSnackBar {
  static void show(ScaffoldMessengerState messenger, String text, Color color) {
    messenger.showSnackBar(
      SnackBar(
        content: Text(text),
        backgroundColor: color,
        elevation: 6.0,

        behavior: SnackBarBehavior.floating,
        margin: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),

        dismissDirection: DismissDirection.horizontal,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      )
    );
  }
}
