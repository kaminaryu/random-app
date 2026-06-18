import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeModeHandler {
  static ValueNotifier<String> themeModeNotifier = ValueNotifier("system");

  static Future<void> init() async {
    themeModeNotifier.value = await getAppTheme();
  }

  static Future<void> setAppTheme(String theme) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString("theme_mode", theme);
    themeModeNotifier.value = theme;
  }

  static Future<String> getAppTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("theme_mode") ?? "system";
  }
}
