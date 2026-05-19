import 'package:hydro_iot/src/auth/application/providers/auth_provider.dart';
import 'package:hydro_iot/src/auth/domain/entities/user_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@riverpod
class UserController extends _$UserController {
  @override
  Future<UserEntity?> build() async {
    return await getUserProfile();
  }

  Future<UserEntity?> getUserProfile() async {
    state = const AsyncValue.loading();
    try {
      final response = await ref.read(userRepositoryProvider).getUserProfile();
      if (response.isSuccess && response.data != null) {
        state = AsyncValue.data(response.data!);
        return response.data;
      }
      state = const AsyncValue.data(null);
      return null;
    } catch (e) {
      state = const AsyncValue.error('Failed to fetch user profile', StackTrace.empty);
      rethrow;
    }
  }

  Future<void> updateProfile({required String? name}) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(userRepositoryProvider).updateUserProfile(user: {if (name != null && name.isNotEmpty) 'name': name});
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
