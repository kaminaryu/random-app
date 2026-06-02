// NOTE: temporary only, will add proper backend later
import 'package:shared_preferences/shared_preferences.dart';

class PrefsService {
  // Saves a bool to disk under the key 'is_logged_in'
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('login_status', value);
  }

  // Reads the bool back; returns false if the key doesn't exist yet
  static Future<bool> getLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('login_status') ?? false;
  }
}
