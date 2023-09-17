import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/use_cases/token_use.dart';
import '../../../utils/utils.dart';

part 'access_token_state.dart';

class AccessTokenCubit extends Cubit<AccessTokenState> {
  final TokenUse tokenUse;

  AccessTokenCubit({required this.tokenUse}) : super(AccessTokenLoading());

  Future<void> getAccessToken() async {
    emit(AccessTokenLoading());
    emit(TokenVpnLoading());

    if (await UtilPreferences.get(Preferences.refreshToken) == null) {
      emit(const InvalidToken());
      return;
    }
    final token =
    await tokenUse(UtilPreferences.get(Preferences.refreshToken));

    if (token.message == "توکن تازه سازی معتبر نمیباشد") {
      emit(InvalidRefreshToken());
      return;
    }
    if (token.success) {
      await UtilPreferences.setString(
        Preferences.accessToken,
        token.accessToken ?? '',
      );
      await UtilPreferences.setString(
        Preferences.refreshToken,
        token.refreshToken ?? '',
      );
      emit(ValidToken());
    } else {
      if (token.refreshToken == null) {
        emit(TokenVpn());
      } else {
        emit(InvalidToken(message: token.message));
      }
    }
  }
}