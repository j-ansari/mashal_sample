import 'package:dio/dio.dart';
import '../../utils/utils.dart';

class DioErrorHandle {
  DioErrorHandle._();

  static Map<String, dynamic> errorHandle(DioException error) {
    switch (error.type) {
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionTimeout:
        return {
          "success": false,
          "error": {"message": AppStrings.failedConnectServer},
        };
      default:
        final data = error.response?.data;
        return {
          "success": data['success'] ?? false,
          "error": {
            "code": data['error']['code'] ?? -1,
            "message":
                data['error']['message'] ?? AppStrings.failedConnectServer,
          },
        };
    }
  }
}
