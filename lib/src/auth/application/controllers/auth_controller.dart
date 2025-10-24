import 'package:hydro_iot/src/auth/application/providers/auth_provider.dart';
import 'package:hydro_iot/src/auth/domain/entities/user_entity.dart';
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
    state = const AsyncValue.loading();
    final checkSession =
        await Storage.readAccessToken() != null &&
        await Storage.readRefreshToken() != null &&
        await Storage.readIsLoggedIn() != null &&
        await Storage.readIsLoggedIn() == true;
    if (checkSession) {
      final user = await ref.read(userRepositoryProvider).getUserProfile();
      final token = await Storage.readAccessToken();
      if (user.isSuccess && token != null) {
        state = AsyncValue.data(user.data);
        return user.data!;
      } else {
        state = AsyncValue.error('Session expired, please login again', StackTrace.current);
        await ref.read(authRepositoryProvider).signOut();
        throw Exception('Session expired, please login again');
      }
    } else {
      state = AsyncValue.error('No active session, please login', StackTrace.current);
      await ref.read(authRepositoryProvider).signOut();
      throw Exception('No active session, please login');
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
}
