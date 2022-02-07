import 'package:shared_preferences/shared_preferences.dart';

class LocalData {
  static Future<void> setAuth(bool val) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', val);
  }

  static Future<bool> getAuth() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getBool("isLogin") ?? false;
  }
}
