import '../../../domain/entities/auth_entity.dart';
import '../error_model.dart';

class RegisterModel extends LoginRegisterEntity {
  final RegisterResult? result;
  final ErrorModel? errorModel;
  final bool success;

  RegisterModel({
    this.result,
    this.errorModel,
    required this.success,
  }) : super (
    serverToken: result?.smsVerificationServerToken,
    message: errorModel?.message,
    expireSecond: result?.expireSecond,
    success: success,
  );

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      result:
      json['result'] != null ? RegisterResult.fromJson(json['result']) : null,
      errorModel:
      json['error'] != null ? ErrorModel.fromJson(json['error']) : null,
      success: json['success'],
    );
  }
}

class RegisterResult {
  final bool? canLogin;
  final bool? haveNextStep;
  final String? smsVerificationServerToken;
  final int? expireSecond;

  RegisterResult({
    this.canLogin,
    this.haveNextStep,
    this.smsVerificationServerToken,
    this.expireSecond,
  });

  factory RegisterResult.fromJson(Map<String, dynamic> json) {
    return RegisterResult(
      canLogin: json['canLogin'],
      haveNextStep: json['haveNextStep'],
      smsVerificationServerToken: json['smsVerificationServerToken'],
      expireSecond: json['twoFactorVerificationCodeExpireInSeconds'],
    );
  }
}