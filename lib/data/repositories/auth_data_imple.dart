import '../../domain/repositories/auth_repo.dart';
import '../data_source/interfaces/remote_auth_data.dart';
import '../models/auth_model/login_model.dart';
import '../models/auth_model/register_model.dart';
import '../models/auth_model/token_model.dart';
import '../models/auth_model/verify_model.dart';

class AuthRepositoryImpl extends AuthRepository {
  final RemoteAuthData remoteData;

  AuthRepositoryImpl(this.remoteData);

  @override
  Future<LoginModel> loginUser(
      {required String phone, String? tokenSms}) async {
    final Map<String, String> params = {
      "userNameOrEmailAddress": phone,
      "TokenSMSIdentification": tokenSms ?? '',
    };
    try {
      LoginModel successModel = await remoteData.loginUser(params);
      return successModel;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<VerifyModel> verifyUser({
    required String phone,
    String? tokenSms,
    required String pass,
  }) async {
    final Map<String, String> params = {
      "userNameOrEmailAddress": phone,
      "TokenSMSIdentification": tokenSms,
      "twoFactorVerificationCode": pass,
    };

    try {
      VerifyModel verifyModel = await remoteData.verifyPassword(params);
      return verifyModel;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<RegisterModel> registerUser({
    required String firstName,
    required String lastName,
    required String phone,
    required String natCode,
    String? referenceCode,
    String? tokenSms,
    String? serverToken,
    String? clientToken,
  }) async {
    final params = {
      "firstName": firstName,
      "lastName": lastName,
      "phoneNunber": phone,
      "nationalCode": natCode,
      "TokenSMSIdentification": tokenSms ?? "",
      "referenceCode": referenceCode ?? '',
      "smsVerificationClientToken": serverToken,
      "smsVerificationServerToken": clientToken,
    };
    try {
      RegisterModel registerModel = await remoteData.registerUser(params);
      return registerModel;
    } catch (e) {
      throw Exception(e);
    }
  }

  @override
  Future<TokenModel> accessToken(String refreshToken) async {
    try {
      TokenModel tokenModel = await remoteData.accessToken(refreshToken);
      return tokenModel;
    } catch (e) {
      throw Exception(e);
    }
  }
}
