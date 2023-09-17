import 'package:equatable/equatable.dart';

class TokenEntity extends Equatable {
  final bool success;
  final String? message;
  final String accessToken;
  final String refreshToken;

  const TokenEntity({
    required this.success,
    this.message,
    required this.accessToken,
    required this.refreshToken,
  });

  @override
  List<Object?> get props => [success, message, accessToken, refreshToken];
}