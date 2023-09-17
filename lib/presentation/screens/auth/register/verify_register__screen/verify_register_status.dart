import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../di/get_it.dart';
import '../../../../../utils/utils.dart';
import '../../../../blocs/auth/register/register_cubit.dart';
import '../../../../../presentation/widgets/widgets.dart';
import 'register_verify_screen.dart';

class RegisterVerifyStatus extends StatefulWidget {
  final String firstName;
  final String lastName;
  final String phone;
  final String natCode;
  final String? referenceCode;
  final int expireSecond;

  const RegisterVerifyStatus({
    Key? key,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.natCode,
    this.referenceCode,
    required this.expireSecond,
  }) : super(key: key);

  @override
  State<RegisterVerifyStatus> createState() => _RegisterVerifyStatusState();
}

class _RegisterVerifyStatusState extends State<RegisterVerifyStatus> {
  late RegisterCubit registerCubit;

  @override
  void initState() {
    registerCubit = getInstance<RegisterCubit>();
    super.initState();
  }

  @override
  void dispose() {
    registerCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => registerCubit,
      child: Scaffold(
        body: BlocListener<RegisterCubit, RegisterState>(
          listener: (context, state) {
            if (state is RegisterSuccess) {
              Navigator.pushReplacementNamed(context, Routes.city, arguments: false);
            } else if (state is RegisterError) {
              appSnackBar(context: context, text: state.message!);
            } else {
              const AppLoading();
            }
          },
          child: RegisterVerifyScreen(
            registerCubit: registerCubit,
            firstName: widget.firstName,
            lastName: widget.lastName,
            natCode: widget.natCode,
            phone: widget.phone,
            referenceCode: widget.referenceCode,
            expireSecond: widget.expireSecond,
          ),
        ),
      ),
    );
  }
}