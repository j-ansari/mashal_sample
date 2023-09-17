import '../entities/verify_entity.dart';
import '../repositories/auth_repo.dart';
import 'use_case.dart';

class TokenUse extends UseCase<TokenVerifyEntity, String> {
  final AuthRepository _authRepository;

  TokenUse(this._authRepository);

  @override
  Future<TokenVerifyEntity> call(String refreshToken) async {
    return await _authRepository.accessToken(refreshToken);
  }
}