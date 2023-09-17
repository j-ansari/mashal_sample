import '../../core/api_client_interface.dart';
import '../../models/auth_model/login_model.dart';
import '../../models/auth_model/register_model.dart';
import '../../models/auth_model/token_model.dart';
import '../../models/auth_model/verify_model.dart';
import '../interfaces/remote_auth_data.dart';

class RemoteAuthDataImpl extends RemoteAuthData {
  final ApiClient _client;

  RemoteAuthDataImpl(this._client);

  @override
  Future<LoginModel> loginUser(Map<String, String> params) async {
    final request = await _client.postRequest(
      url: "/fakeAddress",
      params: params,
    );
    final response = LoginModel.fromJson(request);
    return response;
  }

  @override
  Future<VerifyModel> verifyPassword(Map<String, String> params) async {
    final request = await _client.postRequest(
      url: "/fakeAddress",
      params: params,
    );
    final response = VerifyModel.fromJson(request);
    return response;
  }

  @override
  Future<RegisterModel> registerUser(Map<String, dynamic> params) async {
    final request = await _client.postRequest(
      url: "/fakeAddress",
      params: params,
    );
    final response = RegisterModel.fromJson(request);
    return response;
  }

  @override
  Future<TokenModel> accessToken(String refreshToken) async {
    final request = await _client.postRequest(
      url: "/fakeAddress=$refreshToken",
    );
    final response = TokenModel.fromJson(request);
    return response;
  }
}
