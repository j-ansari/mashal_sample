import '../entities/auth_entity.dart';
import '../entities/verify_entity.dart';

abstract class AuthRepository {
  Future<LoginRegisterEntity> loginUser({
    required String phone,
    String? tokenSms,
  });

  Future<TokenVerifyEntity> verifyUser({
    required String phone,
    String? tokenSms,
    required String pass,
  });

  Future<LoginRegisterEntity> registerUser({
    required String firstName,
    required String lastName,
    required String phone,
    required String natCode,
    String? referenceCode,
    String? tokenSms,
    String? serverToken,
    String? clientToken,
  });

  Future<TokenVerifyEntity> accessToken(String refreshToken);
}