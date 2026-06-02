import 'package:flutter/material.dart';
import 'package:hydro_iot/src/auth/application/providers/auth_provider.dart';
import 'package:hydro_iot/src/auth/presentation/screens/auth_screen.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_controller.g.dart';

@Riverpod(keepAlive: true)
class AuthController extends _$AuthController {
  @override
  Future<void> build() async {}

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

  Future<void> forceLogout({String? reason}) async {
    // Guard: hindari double logout
    if (state.isLoading) return;

    state = const AsyncValue.loading();
    try {
      debugPrint("Force logout triggered: ${reason ?? 'token invalid'}");
      await ref.read(authRepositoryProvider).signOut();
      state = const AsyncValue.data(null);

      final context = NavigationService.rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        // Gunakan pushNamedAndRemoveUntil agar semua route di-clear
        Navigator.of(context).pushNamedAndRemoveUntil('/${AuthScreen.path}', (route) => false);
      } else {
        debugPrint('forceLogout: context is null, navigation skipped!');
        // Fallback: jadwalkan ulang setelah frame berikutnya
        WidgetsBinding.instance.addPostFrameCallback((_) {
          final ctx = NavigationService.rootNavigatorKey.currentContext;
          if (ctx != null && ctx.mounted) {
            Navigator.of(ctx).pushNamedAndRemoveUntil('/${AuthScreen.path}', (route) => false);
          }
        });
      }
    } catch (e, st) {
      debugPrint('Error in forceLogout: $e');
      state = AsyncValue.error(e, st);
    }
  }
}
