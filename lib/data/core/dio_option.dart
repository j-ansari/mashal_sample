import 'dart:convert';
import 'dart:io';
import 'package:client_information/client_information.dart';
import 'package:dio/dio.dart';
import '../../utils/utils.dart';

class AppDioOption {
  static const int _timeOut = 50;

  const AppDioOption._();

  static BaseOptions getOption(String? token, ClientInformation info) {
    return BaseOptions(
      baseUrl: AppStrings.baseUrl,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: _timeOut),
      receiveTimeout: const Duration(seconds: _timeOut),
      sendTimeout: const Duration(seconds: _timeOut),
      headers: {
        HttpHeaders.acceptLanguageHeader: 'fa',
        "Authorization": "Bearer $token",
        "customData": jsonEncode(_customData(info))
      },
    );
  }

  static BaseOptions postOption(String? token, ClientInformation info) {
    return BaseOptions(
      baseUrl: AppStrings.baseUrl,
      contentType: Headers.jsonContentType,
      responseType: ResponseType.json,
      connectTimeout: const Duration(seconds: _timeOut),
      receiveTimeout: const Duration(seconds: _timeOut),
      sendTimeout: const Duration(seconds: _timeOut),
      headers: {
        HttpHeaders.acceptLanguageHeader: 'fa',
        "Authorization": "Bearer $token",
        "customData": jsonEncode(_customData(info))
      },
    );
  }
}

Map<String, dynamic> _customData(ClientInformation info) {}
