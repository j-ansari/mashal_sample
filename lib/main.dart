import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/screens/splash/splash_status.dart';
import 'presentation/themes/theme.dart';
import 'utils/utils.dart';
import 'di/get_it.dart' as get_it;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  UtilPreferences.preferences = await SharedPreferences.getInstance();
  unawaited(get_it.init());

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Color(AppColors.primaryColor)),
  );

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then(
    (_) => runApp(
      MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);
  final route = Routes();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      theme: themeData(),
      onGenerateRoute: route.generateRoute,
      scrollBehavior: MyCustomScrollBehavior(),
      supportedLocales: const [Locale('fa', 'IR')],
      locale: const Locale("fa", "IR"),
      home: const SplashStatus(),
    );
  }
}
