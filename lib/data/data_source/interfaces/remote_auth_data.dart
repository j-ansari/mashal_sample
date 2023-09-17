import '../../models/auth_model/login_model.dart';
import '../../models/auth_model/register_model.dart';
import '../../models/auth_model/token_model.dart';
import '../../models/auth_model/verify_model.dart';

abstract class RemoteAuthData {
  Future<LoginModel> loginUser(Map<String, String> params);
  Future<VerifyModel> verifyPassword(Map<String, String> params);
  Future<RegisterModel> registerUser(Map<String, dynamic> params);
  Future<TokenModel> accessToken(String refreshToken);
}