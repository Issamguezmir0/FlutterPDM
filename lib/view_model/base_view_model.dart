import 'dart:developer';

import 'package:flutter/foundation.dart';

import '../api/response/api_response.dart';
import '../api/response/status.dart';

abstract class BaseViewModel<T> extends ChangeNotifier {
  bool isDisposed = false;

  ApiResponse<dynamic> apiResponse = ApiResponse.loading();

  late List<T> itemList = [];
  late T item;

  @override
  void dispose() {
    isDisposed = true;
    super.dispose();
  }

  void setApiResponse(
    ApiResponse<dynamic> response, {
    bool addToList = false,
    String? removeId,
  }) {
    apiResponse = response;

    if (apiResponse.status == Status.completed) {
      if (response.data.runtimeType == List<T>) {
        itemList = response.data as List<T>;
      } else if (response.data.runtimeType == T) {
        item = response.data as T;
        if (addToList) itemList.insert(0, item);
        if (removeId != null) {
          itemList.removeWhere((dynamic element) => element.id == removeId);
        }
      } else {
        log("Unsupported api response type");
      }
    }

    if (!isDisposed) notifyListeners();
  }

  Future<ApiResponse> makeApiCall({
    required Future<dynamic> Function() apiCall,
    bool addToList = false,
    String? removeId,
    bool withoutLoading = false,
  }) async {
    if (!withoutLoading) setApiResponse(ApiResponse.loading());

    try {
      final data = await apiCall();
      setApiResponse(
        ApiResponse.completed(data: data),
        addToList: addToList,
        removeId: removeId,
      );
    } catch (e, stackTrace) {
      log("Network error : $e");
      if (kDebugMode) print(stackTrace);
      setApiResponse(ApiResponse.error(message: e.toString()));
    }

    return apiResponse;
  }
}
