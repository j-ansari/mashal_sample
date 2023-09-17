import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/get_it.dart';
import '../../../../utils/routes.dart';
import '../../../blocs/auth/login/login_cubit.dart';
import '../register/register_screen/register_status.dart';
import '../verify/verify_status.dart';
import 'login_screen.dart';
import '../../../../presentation/widgets/widgets.dart';

class LoginStatus extends StatefulWidget {
  const LoginStatus({Key? key}) : super(key: key);

  @override
  State<LoginStatus> createState() => _LoginStatusState();
}

class _LoginStatusState extends State<LoginStatus> {
  late LoginCubit loginCubit;

  @override
  void initState() {
    loginCubit = getInstance<LoginCubit>();
    super.initState();
  }

  @override
  void dispose() {
    loginCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => loginCubit,
      child: WillPopScope(
        onWillPop: (() => SystemNavigator.pop().then((value) => value as bool)),
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: BlocListener<LoginCubit, LoginState>(
            listener: (context, state) {
              if (state is LoginSuccess) {
                Navigator.pushReplacementNamed(
                  context,
                  Routes.verify,
                  arguments: VerifyParams(
                    phoneNumber: state.phoneNumber,
                    expireSecond: state.expireSecond,
                  ),
                );
              } else if (state is LoginError) {
                appSnackBar(context: context, text: state.message!);
              } else if (state is RegisterUser) {
                Navigator.pushNamed(
                  context,
                  Routes.register,
                  arguments: RegisterStatusParams(
                    phone: state.phoneNumber,
                  ),
                );
              } else {
                const AppLoading();
              }
            },
            child: LoginScreen(),
          ),
        ),
      ),
    );
  }
}
