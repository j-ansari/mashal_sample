import '../entities/auth_entity.dart';
import '../entities/params/login_user_params.dart';
import '../repositories/auth_repo.dart';
import 'use_case.dart';

class LoginUserUse extends UseCase<LoginRegisterEntity, LoginUserParams> {
  final AuthRepository _repository;

  LoginUserUse(this._repository);

  @override
  Future<LoginRegisterEntity> call(LoginUserParams params) async {
    return await _repository.loginUser(
      phone: params.phone,
      tokenSms: params.tokenSms,
    );
  }
}