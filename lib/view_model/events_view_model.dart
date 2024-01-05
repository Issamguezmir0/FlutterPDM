import 'package:pdm/api/response/api_response.dart';
import 'package:pdm/model/event.dart';
import 'package:pdm/repository/event_repository.dart';
import 'package:pdm/view_model/base_view_model.dart';

class EventViewModel extends BaseViewModel<Event> {
  Future<ApiResponse> getAll() async {
    return await makeApiCall(apiCall: () => EventRepository.getAll());
  }
}
