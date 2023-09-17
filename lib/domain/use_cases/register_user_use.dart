import '../entities/auth_entity.dart';
import '../entities/params/register_params.dart';
import '../repositories/auth_repo.dart';
import 'use_case.dart';

class RegisterUserUse extends UseCase<LoginRegisterEntity, RegisterParams> {
  final AuthRepository _authRepository;

  RegisterUserUse(this._authRepository);

  @override
  Future<LoginRegisterEntity> call(RegisterParams params) async {
    return await _authRepository.registerUser(
      firstName: params.firstName,
      lastName: params.lastName,
      phone: params.phone,
      natCode: params.natCode,
      referenceCode: params.referenceCode,
      tokenSms: params.tokenSms,
      serverToken: params.serverToken,
      clientToken: params.clientToken,
    );
  }
}