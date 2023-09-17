import 'package:flutter/material.dart';
import '../presentation/screens/auth/login/login_status.dart';
import '../presentation/screens/auth/register/register_screen/register_status.dart';
import '../presentation/screens/auth/verify/verify_status.dart';

class Routes {
  static const String login = "/login";
  static const String verify = "/verify";
  static const String register = "/register";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case login:
        return screenRouting(const LoginStatus());

      case verify:
        return screenRouting(
          VerifyStatus(params: settings.arguments as VerifyParams),
        );

      case register:
        return screenRouting(RegisterStatus(
          params: settings.arguments as RegisterStatusParams,
        ));

      default:
        return screenRouting(
          Scaffold(
            body: Center(
              child: Text('No path for ${settings.name}'),
            ),
          ),
        );
    }
  }

  dynamic screenRouting(Widget screen) {}

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() => _instance;

  Routes._internal();
}
