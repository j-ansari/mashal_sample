import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../../utils/utils.dart';
import '../../../blocs/auth/verify/verify_cubit.dart';
import '../../../themes/colors.dart';
import '../../../../presentation/widgets/widgets.dart';

class VerifyScreen extends StatefulWidget {
  final String textController;
  final VerifyCubit verifyCubit;
  final int expireSecond;

  const VerifyScreen({
    Key? key,
    required this.textController,
    required this.verifyCubit,
    required this.expireSecond,
  }) : super(key: key);

  @override
  State<VerifyScreen> createState() => _VerifyScreenState();
}

class _VerifyScreenState extends State<VerifyScreen> with CodeAutoFill {
  final _smsCodeInputController = TextEditingController();
  final verifyCodeCounter = BehaviorSubject<bool>.seeded(false);
  final size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  String? otpCode = "";

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code!;
    });
  }

  @override
  void initState() {
    widget.verifyCubit.startCountDown(widget.expireSecond);
    super.initState();
  }

  @override
  void dispose() {
    _smsCodeInputController.dispose();
    SmsAutoFill().unregisterListener();
    unregisterListener();
    cancel();
    super.dispose();
  }

  Future<void> setData(String value, bool isOnChange) async {
    String smsToken = kIsWeb ? '' : await SmsAutoFill().getAppSignature;
    if (!mounted) return;
    if (isOnChange) {
      if (value.length == 6) {
        FocusScope.of(context).requestFocus(FocusNode());
        await BlocProvider.of<VerifyCubit>(context).verification(
          pass: _smsCodeInputController.text,
          tokenSms: smsToken,
          phone: widget.textController,
          expireSecond: widget.expireSecond,
        );
        verifyCodeCounter.value = true;
      } else {
        verifyCodeCounter.value = false;
      }
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      await BlocProvider.of<VerifyCubit>(context).verification(
        pass: _smsCodeInputController.text,
        tokenSms: smsToken,
        phone: widget.textController,
        expireSecond: widget.expireSecond,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    bool responsive = size.height < 600;
    return Stack(
      children: [
        SizedBox(
          width: size.width,
          height: size.height / 3,
          child: Stack(
            children: [
              Container(
                width: size.width,
                height: size.height,
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppImages.backgroundPattern),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: size.height - size.height / 1.4),
            padding: const EdgeInsets.all(20),
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(30),
                topLeft: Radius.circular(30),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    AppStrings.accountLogin,
                    style: TextStyle(
                      color: const Color(AppColors.backgroundColor),
                      fontSize: !responsive ? 16 : 14,
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                Align(
                  alignment: Alignment.topCenter,
                  child: Text(
                    AppStrings.verifyCodeSend +
                        widget.textController +
                        AppStrings.inputCode,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: !responsive ? 13 : 11,
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.topCenter,
                  child: GestureDetector(
                    child: Text(
                      AppStrings.changeNumber,
                      style: TextStyle(
                        decoration: TextDecoration.underline,
                        color: Colors.blue,
                        decorationThickness: 4,
                        fontSize: !responsive ? 12 : 10,
                      ),
                    ),
                    onTap: () {
                      Navigator.pushReplacementNamed(context, Routes.login);
                    },
                  ),
                ),
                const SizedBox(height: 25),
                inputHintText(
                  AppStrings.activeCode,
                  0,
                  context,
                  fontSize: !responsive ? 14 : 12,
                ),
                SizedBox(
                  width: size.width - 35,
                  child: kIsWeb
                      ? AppTextField(
                          txtCharLength: 6,
                          controller: _smsCodeInputController,
                          keyboardType: TextInputType.phone,
                          hintText: AppStrings.inputVerifyCode,
                          onChanged: (value) async =>
                              await setData(value!, true),
                        )
                      : Platform.isAndroid
                          ? PinFieldAutoFill(
                              currentCode: code,
                              controller: _smsCodeInputController,
                              autoFocus: true,
                              cursor: Cursor(
                                color: const Color(AppColors.primaryColor),
                                height: 10,
                                width: 1,
                              ),
                              keyboardType: TextInputType.phone,
                              onCodeChanged: (value) async =>
                                  await setData(value!, true),
                            )
                          : Platform.isIOS
                              ? CupertinoTextField(
                                  controller: _smsCodeInputController,
                                  keyboardType: TextInputType.phone,
                                  autofocus: true,
                                  textAlignVertical: TextAlignVertical.center,
                                  cursorColor:
                                      const Color(AppColors.primaryColor),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  autofillHints: const <String>[
                                    AutofillHints.oneTimeCode
                                  ],
                                  style: const TextStyle(fontSize: 12),
                                  textAlign: TextAlign.center,
                                  decoration: BoxDecoration(
                                    color:
                                        const Color(AppColors.widgetBackground),
                                    borderRadius: BorderRadius.circular(
                                      AppBorderRadius.borderRadius,
                                    ),
                                  ),
                                )
                              : AppTextField(
                                  controller: _smsCodeInputController,
                                  keyboardType: TextInputType.phone,
                                  autoFocus: true,
                                  txtCharLength: 6,
                                  hintText: AppStrings.inputVerifyCode,
                                ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 30.0, bottom: 20),
                  child: StreamBuilder(
                    stream: widget.verifyCubit.buttonState,
                    builder: (context, _) {
                      return SizedBox(
                        width: size.width - 35,
                        child: BlocBuilder<VerifyCubit, VerifyState>(
                          builder: (context, state) {
                            return StreamBuilder<bool>(
                                stream: verifyCodeCounter.stream,
                                builder: (context, snapshot) {
                                  return AppButton(
                                    text: widget.verifyCubit.buttonState.value
                                        ? AppStrings.resendCode
                                        : AppStrings.done,
                                    width: size.width,
                                    isDisable:
                                        !widget.verifyCubit.buttonState.value &&
                                            !verifyCodeCounter.value,
                                    isLoading: state is VerifyLoading,
                                    onClick: () async {
                                      await setData(
                                        _smsCodeInputController.text,
                                        false,
                                      );
                                    },
                                  );
                                });
                          },
                        ),
                      );
                    },
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: size.height / 25.0,
                      top: size.height / 25.0,
                    ),
                    child: StreamBuilder(
                      stream: widget.verifyCubit.countDownTimer,
                      builder: (context, AsyncSnapshot snapshot) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              widget.verifyCubit.countDownTimer.value != 0
                                  ? widget.verifyCubit.countDownTimer.value
                                      .toString()
                                  : '',
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color(AppColors.primaryColor)),
                            ),
                            Text(
                              widget.verifyCubit.countDownTimer.value == 0
                                  ? AppStrings.requestCode
                                  : AppStrings.codeTimer,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
