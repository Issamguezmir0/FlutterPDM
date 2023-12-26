import '../api/network/api_service.dart';
import '../api/network/http_method.dart';
import '../env.dart';
import '../model/user.dart';

class UserRepository {
  static const String apiUrl = "$baseUrl/users";

  static Future<User> getById(String id) async {
    final Map<String, dynamic> json = await ApiService.instance.sendRequest(
      url: "$apiUrl/one/$id",
      httpMethod: HttpMethod.get,
      authIsRequired: true,
    );

    return User.fromJson(json["data"]);
  }

  static Future<List<User>> getAll() async {
    final List<dynamic> json = await ApiService.instance.sendRequest(
      url: "$apiUrl/",
      httpMethod: HttpMethod.get,
      authIsRequired: true,
    );

    return List<User>.from(json.map((model) => User.fromJson(model)))
        .reversed
        .toList();
  }

  static Future<bool> update(User user, String? imageFilePath) async {
    await ApiService.instance.sendMultipartRequest(
      url: "$apiUrl/${user.id}",
      httpMethod: HttpMethod.put,
      body: user.toJson(),
      multipartParamName: 'image',
      filesPathList: imageFilePath != null ? [imageFilePath] : [],
      authIsRequired: true,
    );

    return true;
  }

  static Future<bool> delete(String id) async {
    await ApiService.instance.sendRequest(
      url: "$apiUrl/$id",
      httpMethod: HttpMethod.delete,
      authIsRequired: true,
    );

    return true;
  }
}
