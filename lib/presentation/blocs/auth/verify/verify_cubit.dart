import 'dart:async';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../../../domain/entities/params/veify_pass_params.dart';
import '../../../../domain/entities/verify_entity.dart';
import '../../../../domain/use_cases/verify_pass.dart';
import '../../../../utils/utils.dart';

part 'verify_state.dart';

class VerifyCubit extends Cubit<VerifyState> {
  final buttonState = BehaviorSubject<bool>.seeded(false);
  final countDownTimer = BehaviorSubject<int>.seeded(0);
  final VerifyPassUse verifyPass;
  late Timer timer;

  VerifyCubit({required this.verifyPass}) : super(ResendCode(resend: false));

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

  Future<void> verification({
    required String pass,
    required String phone,
    required String tokenSms,
    required int expireSecond,
  }) async {
    emit(VerifyLoading());
    if (!buttonState.value) {
      TokenVerifyEntity verify = await verifyPass(
        VerifyPassParams(
          pass: pass,
          phone: phone,
          tokenSms: tokenSms,
        ),
      );
      if (verify.success) {
        emit(VerifySuccess(verifyEntity: verify));
        await UtilPreferences.setString(
          Preferences.accessToken,
          verify.accessToken ?? "",
        );
        await UtilPreferences.setString(
          Preferences.refreshToken,
          verify.refreshToken ?? "",
        );
        await UtilPreferences.setString(Preferences.phoneNumber, phone);
      } else {
        emit(VerifyError(message: verify.message));
      }
    } else {
      TokenVerifyEntity verify = await verifyPass(
        VerifyPassParams(
          pass: '',
          phone: phone,
          tokenSms: tokenSms,
        ),
      );
      if (verify.success) {
        startCountDown(expireSecond);
        emit(ResendCode(resend: buttonState.value));
      } else {
        emit(VerifyError(message: verify.message));
      }
    }
  }
}