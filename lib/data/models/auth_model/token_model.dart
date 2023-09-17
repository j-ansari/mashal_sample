import '../../../domain/entities/verify_entity.dart';
import '../error_model.dart';

class TokenModel extends TokenVerifyEntity {
  final TokenResult? result;
  final ErrorModel? errorModel;
  final bool success;

  TokenModel({
    required this.result,
    this.errorModel,
    required this.success,
  }) : super (
    success: success,
    message: errorModel?.message,
    accessToken: result?.accessToken,
    refreshToken: result?.refreshToken,
  );

  factory TokenModel.fromJson(Map<String, dynamic> json) {
    return TokenModel(
    result : json['result'] != null ? TokenResult.fromJson(json['result']) : null,
    errorModel :
    json['error'] != null ? ErrorModel.fromJson(json['error']) : null,
    success : json['success'],
    );
  }
}

class TokenResult {
  final String? accessToken;
  final String? refreshToken;

  TokenResult({this.accessToken, this.refreshToken});

  factory TokenResult.fromJson(Map<String, dynamic> json) {
    return TokenResult(
    accessToken : json['accessToken'],
    refreshToken : json['refreshToken'],
    );
  }
}