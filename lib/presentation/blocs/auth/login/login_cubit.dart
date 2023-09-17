import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../domain/entities/auth_entity.dart';
import '../../../../domain/entities/params/login_user_params.dart';
import '../../../../domain/use_cases/login_user.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUserUse loginUser;

  LoginCubit({required this.loginUser}) : super(LoginInitial());

  Future<void> login({required String phone, required String tokenSms}) async {
    emit(LoginLoading());
    final user = await loginUser(
      LoginUserParams(
        phone: phone,
        tokenSms: tokenSms,
      ),
    );
    if (!user.success && user.message != null && user.code == 2) {
      emit(RegisterUser(phoneNumber: phone));
    }
    if (user.success) {
      emit(
        LoginSuccess(
          authEntity: user,
          phoneNumber: phone,
          expireSecond: user.expireSecond!,
        ),
      );
    } else {
      emit(LoginError(user.message));
    }
  }
}
