// NOTE: temporary only, will add proper backend later
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  static ValueNotifier<bool> loginStatusNotifier = ValueNotifier(false);

  // on app start, run this so that its not hardcoded as false
  static Future<void> init() async {
    loginStatusNotifier.value = await getLoggedIn();
  }

  // Saves a bool to disk under the key 'login_status'
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('login_status', value);

    // change and notify
    loginStatusNotifier.value = value;
  }

  // Reads the bool back; returns false if the key doesn't exist yet
  static Future<bool> getLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('login_status') ?? false;
  }
}
