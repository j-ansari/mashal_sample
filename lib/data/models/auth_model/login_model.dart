import '../../../domain/entities/auth_entity.dart';
import '../error_model.dart';

class LoginModel extends LoginRegisterEntity{
  final LoginResult? result;
  final ErrorModel? errorModel;
  final bool success;

  LoginModel({this.result, this.errorModel, required this.success}) : super (
    expireSecond: result?.expireSecond,
    message: errorModel?.message,
    code: errorModel?.code,
    success: success,
  );

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      result:
      json['result'] != null ? LoginResult.fromJson(json['result']) : null,
      errorModel:
      json['error'] != null ? ErrorModel.fromJson(json['error']) : null,
      success: json['success'],
    );
  }
}

class LoginResult {
  final bool? shouldResetPassword;
  final int? userId;
  final bool? requiresTwoFactorVerification;
  final int? refreshTokenExpireInSeconds;
  final int? expireSecond;

  LoginResult({
    this.shouldResetPassword,
    this.userId,
    this.requiresTwoFactorVerification,
    this.refreshTokenExpireInSeconds,
    this.expireSecond,
  });

  factory LoginResult.fromJson(Map<String, dynamic> json) {
    return LoginResult(
      shouldResetPassword: json['shouldResetPassword'],
      userId: json['userId'],
      requiresTwoFactorVerification: json['requiresTwoFactorVerification'],
      refreshTokenExpireInSeconds: json['refreshTokenExpireInSeconds'],
      expireSecond: json['twoFactorVerificationCodeExpireInSeconds'],
    );
  }
}