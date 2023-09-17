import 'package:equatable/equatable.dart';

class TokenVerifyEntity extends Equatable {
  final bool success;
  final String? message;
  final String? accessToken;
  final String? refreshToken;

  const TokenVerifyEntity({
    required this.success,
    this.message,
    this.accessToken,
    this.refreshToken,
  });

  @override
  List<Object?> get props => [success, message, accessToken, refreshToken];
}