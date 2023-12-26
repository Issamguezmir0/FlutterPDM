import 'package:pdm/api/response/api_response.dart';
import 'package:pdm/repository/user_repository.dart';

import '../model/user.dart';
import '../repository/auth_repository.dart';
import 'base_view_model.dart';

class UserViewModel extends BaseViewModel<User> {
  Future<ApiResponse> getById({required String id}) async {
    return await makeApiCall(apiCall: () => UserRepository.getById(id));
  }

  Future<ApiResponse> getAll() async {
    return await makeApiCall(apiCall: () => UserRepository.getAll());
  }

  Future<ApiResponse> add({
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

  Future<ApiResponse> update({
    required User user,
    String? imageFilePath,
  }) async {
    return await makeApiCall(
      apiCall: () => UserRepository.update(user, imageFilePath),
    );
  }

  Future<ApiResponse> delete({required String id}) async {
    return await makeApiCall(apiCall: () => UserRepository.delete(id));
  }
}
