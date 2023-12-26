class CustomException implements Exception {
  final String message;

  CustomException(this.message);

  CustomException.networkError({this.message = "Network error"});

  CustomException.networkTimeout({this.message = "Network timeout"});

  @override
  String toString() {
    return message;
  }
}
