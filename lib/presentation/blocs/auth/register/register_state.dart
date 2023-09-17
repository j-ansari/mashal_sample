part of 'register_cubit.dart';

@immutable
abstract class RegisterState extends Equatable {
  const RegisterState();
}

class RegisterInitial extends RegisterState {
  @override
  List<Object?> get props => [];
}

class RegisterLoading extends RegisterState {
  @override
  List<Object?> get props => [];
}

class RegisterError extends RegisterState {
  final String? message;

  const RegisterError({this.message});

  @override
  List<Object?> get props => [message];
}

class RegisterSuccess extends RegisterState {
  @override
  List<Object?> get props => [];
}

class RegisterFinalStep extends RegisterState {
  final String firstName;
  final String lastName;
  final String natCode;
  final String phone;
  final String? referenceCode;
  final int expireSecond;

   const RegisterFinalStep({
     required this.firstName,
     required this.lastName,
     required this.natCode,
     required this.phone,
     this.referenceCode,
     required this.expireSecond,
   });

  @override
  List<Object?> get props =>
      [firstName, lastName, natCode, phone, referenceCode];
}