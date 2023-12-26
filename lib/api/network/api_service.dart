import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:pdm/api/response/custom_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

import '../../../utils/token_manager.dart';
import 'http_method.dart';

class ApiService {
  static final ApiService instance = ApiService._internal();

  factory ApiService() {
    return instance;
  }

  ApiService._internal();

  Future<dynamic> sendRequest({
    required HttpMethod httpMethod,
    required String url,
    required bool authIsRequired,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, String?>? queryParameters,
    bool isLogin = false,
  }) async {
    try {
      headers ??= {};
      headers.addAll({'Content-Type': 'application/json; charset=utf-8'});
      if (authIsRequired) {
        await TokenManager.loadToken();
        headers.addAll({'Authorization': 'Bearer ${TokenManager.storedToken}'});
      }

      late http.Response response;
      const timeout = Duration(seconds: 15);

      final Uri uri = Uri.parse(url).replace(
        queryParameters: queryParameters
          ?..removeWhere((key, value) => value == null),
      );

      switch (httpMethod) {
        case HttpMethod.get:
          response = await http.get(uri, headers: headers).timeout(timeout);
          break;
        case HttpMethod.post:
          response = await http
              .post(uri, headers: headers, body: jsonEncode(body))
              .timeout(timeout);
          break;
        case HttpMethod.put:
          response = await http
              .put(uri, headers: headers, body: jsonEncode(body))
              .timeout(timeout);
          break;
        case HttpMethod.delete:
          response = await http.delete(uri, headers: headers).timeout(timeout);
          break;
      }

      log("${httpMethod.description} ${response.statusCode} : $uri");

      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 203:
          return jsonDecode(utf8.decode(response.bodyBytes));
        case 400:
        case 401:
        case 404:
          if (isLogin && response.statusCode == 401) {
            throw CustomException("Invalid credentials");
          }

          try {
            throw CustomException(jsonDecode(response.body)["message"]);
          } catch (e) {
            if (kDebugMode) print(response.body);
            throw CustomException(e.toString());
          }
        default:
          try {
            throw CustomException(jsonDecode(response.body)["error"]);
          } catch (e) {
            if (kDebugMode) print(response.body);
            throw CustomException.serverError();
          }
      }
    } on TimeoutException {
      log("Timeout exceeded URL : $url");
      throw CustomException.networkTimeout();
    } on SocketException {
      log("No Internet Connection URL : $url");
      throw CustomException.networkError();
    }
  }

  Future<dynamic> sendMultipartRequest({
    required HttpMethod httpMethod,
    required String url,
    required bool authIsRequired,
    Map<String, String>? headers,
    Map<String, dynamic>? body,
    Map<String, String?>? queryParameters,
    required String multipartParamName,
    required List<String> filesPathList,
  }) async {
    try {
      late http.MultipartRequest request;

      final Uri uri = Uri.parse(url).replace(
        queryParameters: queryParameters
          ?..removeWhere((key, value) => value == null),
      );

      switch (httpMethod) {
        case HttpMethod.post:
          request = http.MultipartRequest('POST', uri);
          break;
        case HttpMethod.put:
          request = http.MultipartRequest('PUT', uri);
          break;
        default:
          throw UnsupportedError("Unsupported method : $httpMethod");
      }

      headers ??= {};
      headers.addAll({'Content-Type': 'application/json; charset=utf-8'});

      if (authIsRequired) {
        await TokenManager.loadToken();
        headers.addAll({'Authorization': 'Bearer ${TokenManager.storedToken}'});
      }
      request.headers.addAll(headers);

      if (body != null) {
        body.forEach((key, value) {
          if (value != null) request.fields.addAll({key: value.toString()});
        });
      }

      for (String filePath in filesPathList) {
        String? mimeType = lookupMimeType(filePath);
        MediaType? mediaType;

        if (mimeType == null) {
          throw CustomException("Couldn't identify file type");
        }

        if (mimeType == 'image/png') {
          mediaType = MediaType('image', 'png');
        } else if (mimeType == 'image/jpeg') {
          mediaType = MediaType('image', 'jpeg');
        } else if (mimeType == 'video/mp4') {
          mediaType = MediaType('video', 'mp4');
        } else if (mimeType == 'video/quicktime') {
          mediaType = MediaType('video', 'mp4');
        } else {
          throw CustomException(
            "This video or image type is not supported $mimeType",
          );
        }

        request.files.add(
          await http.MultipartFile.fromPath(
            multipartParamName,
            filePath,
            contentType: mediaType,
          ),
        );
      }

      http.StreamedResponse response = await request.send();

      log("MULTIPART - ${httpMethod.description} ${response.statusCode} : $uri");

      switch (response.statusCode) {
        case 200:
        case 201:
        case 202:
        case 203:
          return jsonDecode(await response.stream.bytesToString());
        case 400:
        case 401:
        case 404:
          try {
            final json = jsonDecode(await response.stream.bytesToString());
            if (kDebugMode) print(json);
            throw CustomException(json["error"] ?? json["message"]);
          } catch (e) {
            throw CustomException(e.toString());
          }
        default:
          if (kDebugMode) print(await response.stream.bytesToString());
          throw CustomException.serverError();
      }
    } on TimeoutException {
      log("Timeout exceeded URL : $url");
      throw CustomException.networkTimeout();
    } on SocketException {
      log("No Internet Connection URL : $url");
      throw CustomException.networkError();
    }
  }
}
