part of 'login_cubit.dart';

@immutable
abstract class LoginState extends Equatable {
  const LoginState();
}

class LoginInitial extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginLoading extends LoginState {
  @override
  List<Object?> get props => [];
}

class LoginSuccess extends LoginState {
  final LoginRegisterEntity authEntity;
  final String phoneNumber;
  final int expireSecond;

  const LoginSuccess({
    required this.authEntity,
    required this.phoneNumber,
    required this.expireSecond,
  });

  @override
  List<Object?> get props => [authEntity, phoneNumber];
}

class LoginError extends LoginState {
  final String? message;

  const LoginError(this.message);

  @override
  List<Object?> get props => [message];
}

class LoginFailed extends LoginState {
  final String? message;

  const LoginFailed({this.message});

  @override
  List<Object?> get props => [message];
}

class RegisterUser extends LoginState {
  final String phoneNumber;

  const RegisterUser({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}