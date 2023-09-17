import '../../../domain/entities/verify_entity.dart';
import '../error_model.dart';

class VerifyModel extends TokenVerifyEntity {
  final VerifyResult? result;
  final ErrorModel? errorModel;
  final bool success;

  VerifyModel({
    required this.result,
    this.errorModel,
    required this.success,
  }) : super (
    success: success,
    accessToken: result?.accessToken,
    refreshToken: result?.refreshToken,
    message: errorModel?.message,
  );

  factory VerifyModel.fromJson(Map<String, dynamic> json) {
    return VerifyModel(
      result:
      json['result'] != null ? VerifyResult.fromJson(json['result']) : null,
      errorModel:
      json['error'] != null ? ErrorModel.fromJson(json['error']) : null,
      success: json['success'],
    );
  }
}

class VerifyResult {
  final String? accessToken;
  final String? refreshToken;
  final int? expireSecond;

  VerifyResult({this.accessToken, this.refreshToken, this.expireSecond});

  factory VerifyResult.fromJson(Map<String, dynamic> json) {
    return VerifyResult(
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      expireSecond: json['twoFactorVerificationCodeExpireInSeconds'],
    );
  }
}