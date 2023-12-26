import 'package:pdm/utils/user_session.dart';

import '../api/network/api_service.dart';
import '../api/network/http_method.dart';
import '../env.dart';
import '../model/user.dart';
import '../utils/token_manager.dart';

class AuthRepository {
  static const String apiUrl = "$baseUrl/auth";

  static Future<User> login({
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> json = await ApiService.instance.sendRequest(
      url: "$apiUrl/signin",
      httpMethod: HttpMethod.post,
      body: {
        "email": email.toLowerCase().replaceAll(" ", ""),
        "password": password,
      },
      authIsRequired: false,
    );

    final user = User.fromJson(json["user"]);
    await TokenManager.saveToken(json["token"]);
    await UserSession.instance.saveUserSession(user);

    return user;
  }

  static Future<bool> register({
    required User user,
    required String plainPassword,
  }) async {
    await ApiService.instance.sendRequest(
      url: "$apiUrl/signup",
      httpMethod: HttpMethod.put,
      body: user.toJson(password: plainPassword),
      authIsRequired: false,
    );

    return true;
  }

  static Future<String> forgotPassword({required String phoneNumber}) async {
    dynamic json = await ApiService.instance.sendRequest(
      url: "$baseUrl/password/forgot-password",
      httpMethod: HttpMethod.post,
      body: {'num_tel': phoneNumber},
      authIsRequired: false,
    );

    return json['resetCode'];
  }

  static Future<bool> verifyResetCode(
    String phoneNumber,
    String resetCode,
  ) async {
    await ApiService.instance.sendRequest(
      url: "$baseUrl/password/verify-code",
      httpMethod: HttpMethod.post,
      body: {'num_tel': phoneNumber, 'resetCode': resetCode},
      authIsRequired: false,
    );

    return true;
  }

  static Future<bool> resetPassword(
    String phoneNumber,
    String plainPassword,
  ) async {
    await ApiService.instance.sendRequest(
      url: "$baseUrl/password/forgotpasswordfinal",
      httpMethod: HttpMethod.post,
      body: {'num_tel': phoneNumber, 'newPassword': plainPassword},
      authIsRequired: false,
    );

    return true;
  }
}
