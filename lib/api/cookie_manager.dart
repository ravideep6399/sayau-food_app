import 'package:shared_preferences/shared_preferences.dart';

class CookieManager {
  static const String cookieKey = 'cookies';

  Future<void> saveCookies(List<String> cookies) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(cookieKey, cookies);
  }

  Future<List<String>?> getCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(cookieKey);
  }

  Future<void> clearCookies() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove(cookieKey);
  }
}
