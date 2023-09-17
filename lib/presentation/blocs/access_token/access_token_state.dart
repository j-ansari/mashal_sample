part of 'access_token_cubit.dart';

@immutable
abstract class AccessTokenState extends Equatable {
  const AccessTokenState();
}

class AccessTokenLoading extends AccessTokenState {
  @override
  List<Object?> get props => [];
}

class ValidToken extends AccessTokenState {
  @override
  List<Object?> get props => [];
}

class TokenVpnLoading extends AccessTokenState {
  @override
  List<Object> get props => [];
}

class TokenVpn extends AccessTokenState {

  @override
  List<Object> get props => [];
}

class InvalidToken extends AccessTokenState {
  final String? message;

  const InvalidToken({this.message});

  @override
  List<Object?> get props => [message];
}

class InvalidRefreshToken extends AccessTokenState {
  @override
  List<Object> get props => [];
}