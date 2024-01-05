import 'package:pdm/model/event.dart';

import '../api/network/api_service.dart';
import '../api/network/http_method.dart';
import '../env.dart';
import '../model/user.dart';

class EventRepository {
  static const String apiUrl = "$baseUrl/challenge";

  static Future<List<Event>> getAll() async {
    final dynamic json = await ApiService.instance.sendRequest(
      url: "$apiUrl/event",
      httpMethod: HttpMethod.get,
      authIsRequired: true,
    );

    return List<Event>.from(
        json['events'].map((model) => Event.fromJson(model))).reversed.toList();
  }
}
