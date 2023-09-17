import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sms_autofill/sms_autofill.dart';
import '../../../../../enums/rule_page_name.dart';
import '../../../../../utils/app_images.dart';
import '../../../../../utils/app_strings.dart';
import '../../../../../utils/routes.dart';
import '../../../../blocs/auth/register/register_cubit.dart';
import '../../../../themes/colors.dart';
import '../../../rules/rules_screen.dart';
import '../base_card.dart';
import '../../../../../presentation/widgets/widgets.dart';
import '../page_tile.dart';

class RegisterScreen extends StatefulWidget {
  final RegisterCubit registerCubit;
  final int expireSecond;
  final String? name;
  final String? family;
  final String? phone;
  final String? natCode;
  final String? referenceCode;

  const RegisterScreen({
    Key? key,
    required this.registerCubit,
    required this.expireSecond,
    this.name,
    this.family,
    this.phone,
    this.natCode,
    this.referenceCode,
  }) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fNameController = TextEditingController();
  final _lNameController = TextEditingController();
  final _phoneNumController = TextEditingController();
  final _natCodeController = TextEditingController();
  final _referenceCodeController = TextEditingController();
  final checkBoxBehavior = BehaviorSubject<bool>.seeded(false);
  final size = MediaQueryData.fromWindow(WidgetsBinding.instance.window).size;

  @override
  void initState() {
    _fNameController.text = widget.name ?? '';
    _lNameController.text = widget.family ?? '';
    _phoneNumController.text = widget.phone ?? '';
    _natCodeController.text = widget.natCode ?? '';
    _referenceCodeController.text = widget.referenceCode ?? '';
    super.initState();
  }

  @override
  void dispose() {
    _fNameController.dispose();
    _lNameController.dispose();
    _phoneNumController.dispose();
    _natCodeController.dispose();
    _referenceCodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          image(
            context: context,
            image: AppImages.backgroundPattern,
            heightRatio: 7.4,
            size: size,
          ),
          gradientContainer(context, size),
          baseCard(signUp()),
        ],
      ),
    );
  }

  Widget signUp() {
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
                padding: const EdgeInsets.only(top: 80),
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  children: [
                    inputHintText(
                      AppStrings.name,
                      10,
                      context,
                      fontSize: 14,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    AppTextField(
                      controller: _fNameController,
                      keyboardType: TextInputType.text,
                      hintText: '',
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    inputHintText(
                      AppStrings.family,
                      10,
                      context,
                      fontSize: 14,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    AppTextField(
                      controller: _lNameController,
                      keyboardType: TextInputType.text,
                      hintText: '',
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    inputHintText(
                      AppStrings.phoneNumber,
                      10,
                      context,
                      fontSize: 14,
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    AppTextField(
                      controller: _phoneNumController,
                      keyboardType: TextInputType.phone,
                      hintText: '',
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        inputHintText(
                          AppStrings.nationCode,
                          10,
                          context,
                          fontSize: 14,
                        ),
                        const SizedBox(width: 5),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "اختیاری",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(AppColors.primaryColor),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    AppTextField(
                      controller: _natCodeController,
                      keyboardType: TextInputType.phone,
                      hintText: '',
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    Row(
                      children: [
                        inputHintText(
                          AppStrings.referenceCode,
                          10,
                          context,
                          fontSize: 14,
                        ),
                        const SizedBox(width: 5),
                        const Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Text(
                            "اختیاری",
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(AppColors.primaryColor),
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Padding(padding: EdgeInsets.only(top: 5)),
                    AppTextField(
                      controller: _referenceCodeController,
                      keyboardType: TextInputType.text,
                      hintText: '',
                    ),
                    const Padding(padding: EdgeInsets.only(top: 10)),
                    checkBoxAndPolicy(),
                    registerBtn(),
                    loginText(),
                    const SizedBox(height: 10),
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
                  padding: const EdgeInsets.only(top: 15),
                  child: pageTitle(AppStrings.mashalRegister),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget checkBoxAndPolicy() {
    return StreamBuilder<bool>(
      stream: checkBoxBehavior.stream,
      builder: (context, _) {
        return Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            children: [
              Checkbox(
                activeColor: const Color(AppColors.primaryColor),
                value: checkBoxBehavior.value,
                onChanged: (value) {
                  checkBoxBehavior.value = value!;
                },
              ),
              const Text(
                AppStrings.i,
                style: TextStyle(fontSize: 12),
              ),
              GestureDetector(
                child: const Text(
                  ' ${AppStrings.policy}',
                  style: TextStyle(
                    fontSize: 12,
                    decoration: TextDecoration.underline,
                    color: Color(AppColors.primaryColor),
                  ),
                ),
                onTap: () => Navigator.pushNamed(
                  context,
                  Routes.rules,
                  arguments: RuleScreenParams(
                    title: AppStrings.rules,
                    pageName: RulePageName.rule,
                  ),
                ),
              ),
              const Text(
                AppStrings.accept,
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget registerBtn() {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        return StreamBuilder<bool>(
          stream: checkBoxBehavior.stream,
          builder: (context, _) {
            return AppButton(
              text: AppStrings.register,
              width: size.width,
              isDisable: !checkBoxBehavior.value,
              isLoading: state is RegisterLoading,
              onClick: () async {
                bool isValidNumber =
                    !_phoneNumController.text.startsWith('09') &&
                        !_phoneNumController.text.startsWith('۰۹');
                if (_phoneNumController.text.length != 11 || isValidNumber) {
                  appSnackBar(
                    context: context,
                    isError: true,
                    text: 'شماره موبایل را به درستی وارد کنید',
                  );
                } else {
                  await BlocProvider.of<RegisterCubit>(context)
                      .firstStepRegister(
                    firstName: _fNameController.text,
                    lastName: _lNameController.text,
                    natCode: _natCodeController.text,
                    phone: _phoneNumController.text,
                    tokenSms: kIsWeb ? '' : await SmsAutoFill().getAppSignature,
                    referenceCode: _referenceCodeController.text,
                    expireSecond: widget.expireSecond,
                  );
                }
              },
            );
          },
        );
      },
    );
  }

  Widget loginText() {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              AppStrings.haveAccount,
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 7),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, Routes.login),
                child: const Text(
                  AppStrings.login,
                  style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
