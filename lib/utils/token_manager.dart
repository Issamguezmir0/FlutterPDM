import 'package:shared_preferences/shared_preferences.dart';

class TokenManager {
  static const String tokenKey = "TOKEN";

  // Stores the current token
  static String? storedToken;

  // Saves a new token
  static Future saveToken(String token) async {
    token = token;
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(tokenKey, token);
  }

  // Reset token
  static Future<void> resetToken() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(tokenKey, "");
    storedToken = null;
  }

  // load the current token into the variable storedToken
  static Future<void> loadToken() async {
    if (storedToken == null) {
      final sharedPreferences = await SharedPreferences.getInstance();

      if (sharedPreferences.getString(tokenKey) != null) {
        if (sharedPreferences.getString(tokenKey) != "") {
          storedToken = sharedPreferences.getString(tokenKey)!;
        }
      }
    }
  }

  static Future<void> refreshToken() async {
    // TODO Implement
  }
}
