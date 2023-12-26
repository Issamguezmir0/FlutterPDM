import 'dart:developer';

import 'package:pdm/view_model/base_view_model.dart';
import 'package:flutter/foundation.dart';

import '../api/response/api_response.dart';
import '../model/user.dart';
import '../repository/auth_repository.dart';

class AuthViewModel extends BaseViewModel<User> {
  Future<ApiResponse> login({
    required String email,
    required String password,
  }) async {
    try {
      final user = await AuthRepository.login(email: email, password: password);
      setApiResponse(ApiResponse.completed(data: user));
    } catch (e, stackTrace) {
      log("HTTP error : $e");
      if (kDebugMode) print(stackTrace);
      setApiResponse(ApiResponse.error(message: e.toString()));
    }

    return apiResponse;
  }

  Future<ApiResponse> register({
    required User user,
    required String plainPassword,
  }) async {
    return await makeApiCall(
      apiCall: () => AuthRepository.register(
        user: user,
        plainPassword: plainPassword,
      ),
    );
  }

  Future<ApiResponse> forgotPassword({required String phoneNumber}) async {
    return await makeApiCall(
      apiCall: () => AuthRepository.forgotPassword(
        phoneNumber: phoneNumber,
      ),
    );
  }

  Future<ApiResponse> verifyResetCode({
    required String phoneNumber,
    required String resetCode,
  }) async {
    return await makeApiCall(
      apiCall: () => AuthRepository.verifyResetCode(
        phoneNumber,
        resetCode,
      ),
    );
  }

  Future<ApiResponse> resetPassword({
    required String phoneNumber,
    required String plainPassword,
  }) async {
    return await makeApiCall(
      apiCall: () => AuthRepository.resetPassword(
        phoneNumber,
        plainPassword,
      ),
    );
  }
}
