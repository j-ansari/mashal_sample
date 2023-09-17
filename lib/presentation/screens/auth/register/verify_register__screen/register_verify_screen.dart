import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../../../utils/utils.dart';
import '../../../../blocs/auth/register/register_cubit.dart';
import '../../../../../presentation/widgets/widgets.dart';
import '../../../../themes/theme.dart';
import '../base_card.dart';
import '../page_tile.dart';
import '../register_screen/register_status.dart';

class RegisterVerifyScreen extends StatefulWidget {
  final RegisterCubit registerCubit;
  final String firstName;
  final String lastName;
  final String natCode;
  final String phone;
  final String? referenceCode;
  final int expireSecond;

  const RegisterVerifyScreen({
    required this.registerCubit,
    required this.firstName,
    required this.lastName,
    required this.natCode,
    required this.phone,
    this.referenceCode,
    required this.expireSecond,
    Key? key,
  }) : super(key: key);

  @override
  State<RegisterVerifyScreen> createState() => _RegisterVerifyScreenState();
}

class _RegisterVerifyScreenState extends State<RegisterVerifyScreen>
    with CodeAutoFill {
  final _verificationCodeController = TextEditingController();
  final size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  final verifyCodeCounter = BehaviorSubject<bool>.seeded(false);
  String? otpCode = "";

  @override
  void initState() {
    widget.registerCubit.startCountDown(widget.expireSecond);
    super.initState();
  }

  @override
  void dispose() {
    _verificationCodeController.dispose();
    SmsAutoFill().unregisterListener();
    unregisterListener();
    cancel();
    super.dispose();
  }

  @override
  void codeUpdated() {
    setState(() {
      otpCode = code!;
    });
  }

  Future<void> setData(String value, bool isOnChane) async {
    String tokenSms = kIsWeb ? '' : await SmsAutoFill().getAppSignature;
    if (!mounted) return;
    if (isOnChane) {
      if (value.length == 6) {
        FocusScope.of(context).requestFocus(FocusNode());
        await BlocProvider.of<RegisterCubit>(context).register(
          firstName: widget.firstName,
          lastName: widget.lastName,
          natCode: widget.natCode,
          phone: widget.phone,
          tokenSms: tokenSms,
          referenceCode: widget.referenceCode,
          verifyCode: _verificationCodeController.text,
          expireSecond: widget.expireSecond,
        );
        verifyCodeCounter.value = true;
      } else {
        verifyCodeCounter.value = false;
      }
    } else {
      FocusScope.of(context).requestFocus(FocusNode());
      await BlocProvider.of<RegisterCubit>(context).register(
        firstName: widget.firstName,
        lastName: widget.lastName,
        natCode: widget.natCode,
        phone: widget.phone,
        tokenSms: tokenSms,
        referenceCode: widget.referenceCode,
        verifyCode: _verificationCodeController.text,
        expireSecond: widget.expireSecond,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        image(
          context: context,
          image: AppImages.backgroundPattern,
          heightRatio: 7.4,
          size: size,
        ),
        gradientContainer(context, size),
        baseCard(verificationScreen()),
      ],
    );
  }

  Widget verificationScreen() {
    return Container(
      height: size.height / 1.02,
      color: Colors.transparent,
      child: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: size.height / 9),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Color.fromRGBO(82, 82, 82, 0.5),
                    offset: Offset(0, -8),
                    blurRadius: 30,
                  ),
                ],
                color: Colors.white,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: size.height / 4.5),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: Text(
                        AppStrings.verifyCodeSend +
                            widget.phone +
                            AppStrings.inputCode,
                        style: Theme.of(context).textTheme.button!.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                    ),
                    inputHintText(AppStrings.activeCode, 25, context),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    SizedBox(
                      width: size.width - 35,
                      height: 40,
                      child: kIsWeb
                          ? AppTextField(
                              controller: _verificationCodeController,
                              keyboardType: TextInputType.phone,
                              //autoFocus: true,
                              txtCharLength: 6,
                              hintText: AppStrings.inputVerifyCode,
                              onChanged: (value) async => setData(value, true),
                            )
                          : Platform.isAndroid
                              ? PinFieldAutoFill(
                                  currentCode: code,
                                  controller: _verificationCodeController,
                                  keyboardType: TextInputType.phone,
                                  onCodeChanged: (value) async =>
                                      setData(value!, true),
                                )
                              : AppTextField(
                                  controller: _verificationCodeController,
                                  keyboardType: TextInputType.phone,
                                  //autoFocus: true,
                                  txtCharLength: 6,
                                  hintText: AppStrings.inputVerifyCode,
                                  onChanged: (value) async =>
                                      setData(value, true),
                                ),
                    ),
                    const Padding(padding: EdgeInsets.only(top: 15)),
                    verificationBtn(),
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: GestureDetector(
                          child: const Text(
                            AppStrings.backToPage,
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () => Navigator.pushReplacementNamed(
                            context,
                            Routes.register,
                            arguments: RegisterStatusParams(
                              name: widget.firstName,
                              family: widget.lastName,
                              phone: widget.phone,
                              natCode: widget.natCode,
                              referenceCode: widget.referenceCode,
                            ),
                          ),
                        ),
                      ),
                    ),
                    timerText(),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: size.height / 15),
                  child: logoContainer(size),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: pageTitle(AppStrings.mashalRegister),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget verificationBtn() {
    return StreamBuilder(
      stream: widget.registerCubit.buttonState,
      builder: (context, _) {
        return BlocBuilder<RegisterCubit, RegisterState>(
          builder: (context, state) {
            return StreamBuilder<bool>(
                stream: verifyCodeCounter.stream,
                builder: (context, _) {
                  return AppButton(
                    text: widget.registerCubit.buttonState.value
                        ? AppStrings.resendCode
                        : AppStrings.verifyAndRegister,
                    width: size.width,
                    isLoading: state is RegisterLoading,
                    isDisable: !widget.registerCubit.buttonState.value &&
                        !verifyCodeCounter.value,
                    onClick: () async {
                      await setData(_verificationCodeController.text, false);
                    },
                  );
                });
          },
        );
      },
    );
  }

  Widget timerText() {
    return StreamBuilder(
      stream: widget.registerCubit.countDownTimer,
      builder: (context, _) {
        return Align(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  widget.registerCubit.countDownTimer.value != 0
                      ? widget.registerCubit.countDownTimer.value.toString()
                      : '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(AppColors.primaryColor),
                  ),
                ),
                Text(
                  widget.registerCubit.countDownTimer.value == 0
                      ? AppStrings.requestCode
                      : AppStrings.codeTimer,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
