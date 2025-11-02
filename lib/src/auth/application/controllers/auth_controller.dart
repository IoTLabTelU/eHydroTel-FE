import 'package:flutter/material.dart';
import 'package:hydro_iot/src/auth/application/providers/auth_provider.dart';
import 'package:hydro_iot/src/auth/domain/entities/user_entity.dart';
import 'package:hydro_iot/src/auth/presentation/screens/auth_screen.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@riverpod
class AuthController extends _$AuthController {
  @override
  FutureOr<UserEntity?> build() async {
    return await checkSession();
  }

  Future<UserEntity> checkSession() async {
    try {
      final hasAccessToken = await Storage().readAccessToken != null;
      final hasRefreshToken = await Storage().readRefreshToken != null;
      final isLoggedIn = await Storage().readIsLoggedIn == true;

      if (hasAccessToken && hasRefreshToken && isLoggedIn) {
        final user = await ref.read(userRepositoryProvider).getUserProfile();
        final token = await Storage().readAccessToken;

        if (user.isSuccess && token != null) {
          state = AsyncValue.data(user.data);
          return user.data!;
        } else {
          await _handleSessionExpired();
          throw Exception('Session expired, please login again');
        }
      } else {
        await _handleSessionExpired();
        throw Exception('No active session, please login');
      }
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> logout() async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signOut();
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  /// ✅ Digunakan oleh Interceptor ketika token invalid/expired.
  Future<void> forceLogout({String? reason}) async {
    try {
      debugPrint("Force logout triggered: ${reason ?? 'token invalid'}");

      await ref.read(authRepositoryProvider).signOut();

      // Pastikan semua state user direset
      state = const AsyncValue.data(null);

      // Gunakan navigatorKey global agar bisa navigasi tanpa context
      NavigationService.rootNavigatorKey.currentState?.pushNamedAndRemoveUntil('/${AuthScreen.path}', (route) => false);
    } catch (e, st) {
      debugPrint('Error in forceLogout: $e');
      state = AsyncValue.error(e, st);
    }
  }

  /// 🔒 Internal helper ketika session expired
  Future<void> _handleSessionExpired() async {
    await ref.read(authRepositoryProvider).signOut();
    state = const AsyncValue.data(null);
  }
}
