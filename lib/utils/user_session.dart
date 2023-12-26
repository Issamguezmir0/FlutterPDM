import 'dart:convert';
import 'dart:developer';

import 'package:pdm/utils/token_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../api/response/status.dart';
import '../main.dart';
import '../model/user.dart';
import '../view_model/user_view_model.dart';

class UserSession {
  static const String userSessionKey = "USER_SESSION";

  // Stores the current user info
  static User? currentUser;

  // Private constructor
  UserSession._();

  // Singleton instance
  static UserSession? _instance;

  // Accessor for the singleton instance
  static UserSession get instance {
    _instance ??= UserSession._();
    return _instance!;
  }

  // Saves a new user session
  Future<void> saveUserSession(User user) async {
    log("saveUserSession - saving session");
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(userSessionKey, jsonEncode(user.toJson()));
    currentUser = user;
    log("saveUserSession - saved session with id : ${currentUser?.id}");
  }

  // load the current user session into the variable userSession
  Future<void> loadUserSession() async {
    log("loadUserSession - Loading session");
    if (currentUser == null) {
      log("loadUserSession - CurrentUser is null .. loading from shared prefs");
      final sharedPreferences = await SharedPreferences.getInstance();
      final userSession = sharedPreferences.getString(userSessionKey);
      if (userSession != null && userSession.isNotEmpty) {
        log("loadUserSession - userSession is not null .. saving to currentUser");
        currentUser = User.fromJson(jsonDecode(userSession));
      }
    }
    log("loadUserSession - loaded session with id : ${currentUser?.id}");
  }

  // Reset user session
  Future<void> resetUserSession() async {
    log("resetUserSession - Resetting session");
    final sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(userSessionKey, "");
    currentUser = null;
    await TokenManager.resetToken();
  }

  // Refresh the userSession from the server
  Future<void> refreshUserSession() async {
    log("refreshUserSession - Refreshing session");

    if (currentUser?.id != null) {
      log("refreshUserSession - Session found with id : ${currentUser?.id}");
      await UserViewModel()
          .getById(id: currentUser!.id!)
          .then((apiResponse) async {
        if (apiResponse.status == Status.completed) {
          await saveUserSession(apiResponse.data);
        }
      });
    } else {
      log('Failed to load user resetting userSession');
      await resetUserSession();
      main();
    }
  }
}
