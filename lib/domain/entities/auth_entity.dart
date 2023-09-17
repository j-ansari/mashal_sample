import 'package:equatable/equatable.dart';

class LoginRegisterEntity extends Equatable {
  final String? serverToken;
  final int? expireSecond;
  final String? message;
  final int? code;
  final bool success;

  const LoginRegisterEntity({
    this.serverToken,
    this.expireSecond,
    this.message,
    this.code,
    required this.success,
  });

  @override
  List<Object?> get props => [serverToken, expireSecond];
}