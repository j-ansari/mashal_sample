import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import '../data/core/api_client.dart';
import '../data/core/api_client_interface.dart';
import '../data/data_source/implements/remote_auth_data_impl.dart';

final getInstance = GetIt.I;

Future init() async {
  getInstance.registerLazySingleton<Dio>(() => Dio());

  //requests
  getInstance
      .registerLazySingleton<ApiClient>(() => ApiClientImpl(getInstance()));

  getInstance.registerLazySingleton<RemoteAuthData>(
      () => RemoteAuthDataImpl(getInstance()));

  //repositories
  getInstance.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(getInstance()));

  ///useCases
  getInstance
      .registerLazySingleton<LoginUserUse>(() => LoginUserUse(getInstance()));
  getInstance
      .registerLazySingleton<VerifyPassUse>(() => VerifyPassUse(getInstance()));
  getInstance.registerLazySingleton<RegisterUserUse>(
      () => RegisterUserUse(getInstance()));
  getInstance.registerLazySingleton<TokenUse>(() => TokenUse(getInstance()));



  ///cubits
  getInstance.registerFactory(() => LoginCubit(loginUser: getInstance()));
  getInstance.registerFactory(() => VerifyCubit(verifyPass: getInstance()));
  getInstance.registerFactory(() => RegisterCubit(
        registerUser: getInstance(),
        verifyUse: getInstance(),
      ));
  getInstance.registerFactory(() => AccessTokenCubit(tokenUse: getInstance()));

}
