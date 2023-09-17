import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../domain/entities/params/register_params.dart';
import '../../../../domain/entities/params/veify_pass_params.dart';
import '../../../../domain/use_cases/register_user_use.dart';
import '../../../../domain/use_cases/verify_pass.dart';
import '../../../../utils/utils.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final RegisterUserUse registerUser;
  final VerifyPassUse verifyUse;
  final buttonState = BehaviorSubject<bool>.seeded(false);
  final countDownTimer = BehaviorSubject<int>.seeded(0);
  late Timer timer;

  RegisterCubit({required this.registerUser, required this.verifyUse})
      : super(RegisterInitial());

  void startCountDown(int expireSecond) {
    countDownTimer.add(expireSecond);
    buttonState.add(false);
    const duration = Duration(seconds: 1);
    timer = Timer.periodic(duration, (timer) {
      if (countDownTimer.value == 0) {
        buttonState.add(true);
        timer.cancel();
      } else {
        countDownTimer.value--;
      }
    });
  }

  Future<void> firstStepRegister({
    required String lastName,
    required String firstName,
    required String phone,
    required String natCode,
    required int expireSecond,
    String? referenceCode,
    String? tokenSms,
  }) async {
    emit(RegisterLoading());
    final register = await registerUser(
      RegisterParams(
        firstName: firstName,
        lastName: lastName,
        phone: phone,
        natCode: natCode,
        referenceCode: referenceCode,
        tokenSms: tokenSms,
      ),
    );
    if (register.success) {
      await UtilPreferences.setString(
        Preferences.serverToken,
        register.serverToken!,
      );
      await UtilPreferences.setString(Preferences.phoneNumber, phone);
      startCountDown(expireSecond);
      emit(
        RegisterFinalStep(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          natCode: natCode,
          referenceCode: referenceCode,
          expireSecond: register.expireSecond!,
        ),
      );
    } else {
      emit(RegisterError(message: register.message));
    }
  }

  Future<void> register({
    required String lastName,
    required String firstName,
    required String phone,
    required String natCode,
    required int expireSecond,
    String? referenceCode,
    String? tokenSms,
    String? verifyCode,
  }) async {
    emit(RegisterLoading());
    if (buttonState.value == true) {
      firstStepRegister(
        lastName: lastName,
        firstName: firstName,
        phone: phone,
        natCode: natCode,
        tokenSms: tokenSms,
        referenceCode: referenceCode,
        expireSecond: expireSecond,
      );
    } else {
      String serverToken = await UtilPreferences.get(Preferences.serverToken);
      final verifyRegister = await registerUser(
        RegisterParams(
          firstName: firstName,
          lastName: lastName,
          phone: phone,
          natCode: natCode,
          referenceCode: referenceCode,
          tokenSms: tokenSms,
          serverToken: serverToken,
          clientToken: verifyCode,
        ),
      );
      if (verifyRegister.success) {
        final verifyUser = await verifyUse(
          VerifyPassParams(
            phone: phone,
            pass: verifyCode!,
            tokenSms: tokenSms ?? '',
          ),
        );
        if(verifyUser.success) {
          await UtilPreferences.setString(
            Preferences.accessToken,
            verifyUser.accessToken!,
          );
          await UtilPreferences.setString(
            Preferences.refreshToken,
            verifyUser.refreshToken!,
          );
          await UtilPreferences.remove(Preferences.serverToken);
          emit(RegisterSuccess());
        } else {
          emit(RegisterError(message: verifyRegister.message));
        }
      } else {
        emit(RegisterError(message: verifyRegister.message));
      }
    }
  }
}