import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../../utils/utils.dart';
import '../../../blocs/auth/login/login_cubit.dart';
import '../../../themes/colors.dart';
import '../../../../presentation/widgets/widgets.dart';
import '../register/register_screen/register_status.dart';

class LoginScreen extends StatelessWidget {
  final activeClearButton = BehaviorSubject<bool>.seeded(false);
  final _loginTextInputController = TextEditingController();
  final size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;
  final phoneNumberCounter = BehaviorSubject<bool>.seeded(false);

  LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool responsive = size.height < 600;
    return SafeArea(
      child: Stack(
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
                  SizedBox(height: size.height / 15),
                  inputHintText(
                    AppStrings.phoneNumber,
                    0,
                    context,
                    rightPadding: 10,
                    fontSize: !responsive ? 14 : 12,
                  ),
                  const SizedBox(height: 10),
                  StreamBuilder<bool>(
                    stream: activeClearButton.stream,
                    builder: (context, _) {
                      return AppTextField(
                        controller: _loginTextInputController,
                        hintText: '',
                        keyboardType: TextInputType.phone,
                        txtCharLength: 11,
                        autoFocus: !kIsWeb ? true : false,
                        suffixIconData:
                            activeClearButton.value ? Icons.clear : null,
                        onChanged: (value) {
                          if (value.length == 11) {
                            phoneNumberCounter.value = true;
                            activeClearButton.value = true;
                            FocusScope.of(context).requestFocus(FocusNode());
                          } else {
                            activeClearButton.value = false;
                            phoneNumberCounter.value = false;
                          }
                        },
                        onIconPressed: () {
                          _loginTextInputController.clear();
                          activeClearButton.value = false;
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  BlocBuilder<LoginCubit, LoginState>(
                    builder: (context, state) {
                      return StreamBuilder(
                        stream: phoneNumberCounter.stream,
                        builder: (context, _) {
                          return AppButton(
                            text: AppStrings.login,
                            width: size.width,
                            isDisable: !phoneNumberCounter.value,
                            isLoading: state is LoginLoading,
                            onClick: () async {
                              FocusScope.of(context).requestFocus(FocusNode());
                              await BlocProvider.of<LoginCubit>(context).login(
                                phone: _loginTextInputController.text,
                                tokenSms: kIsWeb
                                    ? ''
                                    : await SmsAutoFill().getAppSignature,
                              );
                            },
                          );
                        },
                      );
                    },
                  ),
                  const SizedBox(height: 40),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          AppStrings.doNotAccount,
                          style: TextStyle(fontSize: !responsive ? 12 : 10),
                        ),
                        const Padding(padding: EdgeInsets.only(right: 10)),
                        GestureDetector(
                          child: Text(
                            AppStrings.joinUs,
                            style: TextStyle(
                              fontSize: !responsive ? 12 : 10,
                              decoration: TextDecoration.underline,
                              color: Colors.blue,
                            ),
                          ),
                          onTap: () {
                            Navigator.pushNamed(
                              context,
                              Routes.register,
                              arguments: RegisterStatusParams(
                                phone: _loginTextInputController.text,
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
