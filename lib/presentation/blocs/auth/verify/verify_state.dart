part of 'verify_cubit.dart';

@immutable
abstract class VerifyState extends Equatable {
  const VerifyState();
}

class ResendCode extends VerifyState {
  late bool resend;

  ResendCode({required this.resend});

  @override
  List<Object?> get props => [resend];
}

class VerifyLoading extends VerifyState {
  @override
  List<Object?> get props => [];
}

class VerifySuccess extends VerifyState {
  final TokenVerifyEntity verifyEntity;

  const VerifySuccess({required this.verifyEntity});

  @override
  List<Object?> get props => [verifyEntity];
}

class VerifyError extends VerifyState {
  final String? message;

  const VerifyError({this.message});

  @override
  List<Object?> get props => [message];
}