import 'package:client_information/client_information.dart';
import 'package:dio/dio.dart';
import '../../utils/utils.dart';
import 'api_client_interface.dart';
import 'dio_option.dart';
import 'error_handle.dart';

class ApiClientImpl extends ApiClient {
  final Dio _dio;

  ApiClientImpl(this._dio);

  @override
  getRequest({required String url, Map<String, dynamic>? params}) async {
    final String? token = await UtilPreferences.get(Preferences.accessToken);
    await ClientInformation.fetch().then((value) {
      _dio.options = AppDioOption.getOption(token, value);
    });
    try {
      final response = await _dio.get(url, queryParameters: params);
      return response.data;
    } on DioException catch (error) {
      return DioErrorHandle.errorHandle(error);
    }
  }

  @override
  postRequest({required String url, Map<String, dynamic>? params}) async {
    final String? token = await UtilPreferences.get(Preferences.accessToken);
    await ClientInformation.fetch().then((value) {
      _dio.options = AppDioOption.postOption(token, value);
    });
    try {
      final response = await _dio.post(url, data: params);
      return response.data;
    } on DioException catch (error) {
      return DioErrorHandle.errorHandle(error);
    }
  }

  @override
  putRequest({required String url, Map<String, dynamic>? params}) async {
    final String? token = await UtilPreferences.get(Preferences.accessToken);
    await ClientInformation.fetch().then((value) {
      _dio.options = AppDioOption.getOption(token, value);
    });
    try {
      final response = await _dio.put(url, data: params);
      return response.data;
    } on DioException catch (error) {
      return DioErrorHandle.errorHandle(error);
    }
  }

  @override
  deleteRequest({required String url, Map<String, dynamic>? params}) async {
    final String? token = await UtilPreferences.get(Preferences.accessToken);
    await ClientInformation.fetch().then((value) {
      _dio.options = AppDioOption.getOption(token, value);
    });
    try {
      final response = await _dio.delete(url, data: params);
      return response.data;
    } on DioException catch (error) {
      return DioErrorHandle.errorHandle(error);
    }
  }
}
