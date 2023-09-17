import '../entities/params/veify_pass_params.dart';
import '../entities/verify_entity.dart';
import '../repositories/auth_repo.dart';
import 'use_case.dart';

class VerifyPassUse extends UseCase<TokenVerifyEntity, VerifyPassParams> {
  final AuthRepository _repository;

  VerifyPassUse(this._repository);

  @override
  Future<TokenVerifyEntity> call(VerifyPassParams params) async {
    return await _repository.verifyUser(
      phone: params.phone,
      tokenSms: params.tokenSms,
      pass: params.pass,
    );
  }
}