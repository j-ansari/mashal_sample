import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../di/get_it.dart';
import '../../../../presentation/widgets/widgets.dart';
import '../../../../utils/utils.dart';
import '../../../blocs/auth/verify/verify_cubit.dart';
import 'verify_screen.dart';

class VerifyParams{
  final String phoneNumber;
  final int expireSecond;

  VerifyParams({required this.phoneNumber, required this.expireSecond});
}

class VerifyStatus extends StatefulWidget {
  final VerifyParams params;

  const VerifyStatus({Key? key, required this.params}) : super(key: key);

  @override
  State<VerifyStatus> createState() => _VerifyStatusState();
}

class _VerifyStatusState extends State<VerifyStatus> {
  late VerifyCubit verifyCubit;

  @override
  void initState() {
    verifyCubit = getInstance<VerifyCubit>();
    super.initState();
  }

  @override
  void dispose() {
    verifyCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => verifyCubit,
      child: WillPopScope(
        onWillPop: () => SystemNavigator.pop().then((value) => value as bool),
        child: Scaffold(
          body: SafeArea(
            child: BlocListener<VerifyCubit, VerifyState>(
              listener: (context, state) {
                if (state is VerifySuccess) {
                  Navigator.pushReplacementNamed(
                    context,
                    Routes.city,
                    arguments: false,
                  );
                } else if (state is VerifyError) {
                  appSnackBar(context: context, text: state.message!);
                } else if (state is ResendCode) {
                  state.resend = true;
                  appSnackBar(
                    context: context,
                    text: AppStrings.successResendCode,
                  );
                } else {
                  const AppLoading();
                }
              },
              child: VerifyScreen(
                textController: widget.params.phoneNumber,
                verifyCubit: verifyCubit,
                expireSecond: widget.params.expireSecond,
              ),
            ),
          ),
        ),
      ),
    );
  }
}