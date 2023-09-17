import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../di/get_it.dart';
import '../../../../../presentation/widgets/widgets.dart';
import '../../../../../utils/utils.dart';
import '../../../../blocs/auth/register/register_cubit.dart';
import '../verify_register__screen/verify_register_status.dart';
import 'register_screen.dart';

class RegisterStatusParams{
  String? name;
  String? family;
  String? phone;
  String? natCode;
  String? referenceCode;

  RegisterStatusParams({
    this.name,
    this.family,
    this.phone,
    this.natCode,
    this.referenceCode,
  });
}

class RegisterStatus extends StatefulWidget {
  final RegisterStatusParams params;

  const RegisterStatus({Key? key, required this.params}) : super(key: key);

  @override
  State<RegisterStatus> createState() => _RegisterStatusState();
}

class _RegisterStatusState extends State<RegisterStatus> {
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
              Navigator.pushReplacementNamed(context, Routes.home);
            } else if (state is RegisterFinalStep) {
              widget.params.name = state.firstName;
              widget.params.family = state.lastName;
              widget.params.natCode = state.natCode;
              widget.params.referenceCode = state.referenceCode;
              Navigator.pushReplacement(context,
                MaterialPageRoute(
                  builder: (context) {
                    return RegisterVerifyStatus(
                      firstName: state.firstName,
                      lastName: state.lastName,
                      natCode: state.natCode,
                      phone: state.phone,
                      referenceCode: state.referenceCode,
                      expireSecond: state.expireSecond,
                    );
                  },
                ),
              );
            } else if (state is RegisterError) {
              appSnackBar(context: context, text: state.message!);
            } else {
              const AppLoading(isFullScreen: true);
            }
          },
          child: RegisterScreen(
            registerCubit: registerCubit,
            expireSecond: 0,
            name: widget.params.name ?? '',
            family: widget.params.family ?? '',
            phone: widget.params.phone,
            natCode: widget.params.natCode ?? '',
            referenceCode: widget.params.referenceCode ?? '',
          ),
        ),
      ),
    );
  }
}