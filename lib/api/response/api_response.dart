import 'package:pdm/api/response/status.dart';

class ApiResponse<T> {
  Status status;
  T? data;
  bool? stackData;
  int? currentPage;
  int? numberOfPages;
  String message;

  ApiResponse(this.status, this.data, this.message);

  ApiResponse.loading({this.message = "Loading"}) : status = Status.loading;

  ApiResponse.completed({this.message = "no message", this.data})
      : status = Status.completed;

  ApiResponse.error({this.message = "no message"}) : status = Status.error;

  @override
  String toString() {
    return "Status : $status \n Message : $message \n Data : $data";
  }
}
