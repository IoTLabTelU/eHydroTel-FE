import 'package:hydro_iot/src/auth/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@riverpod
class UserController extends _$UserController {
  @override
  Future<void> build() async {
    // You can perform any initialization logic here if needed.
  }

  Future<void> updateProfile({required String? name, required String? email}) async {
    state = const AsyncValue.loading();
    try {
      await ref
          .read(userRepositoryProvider)
          .updateUserProfile(user: {if (name != null) 'name': name, if (email != null) 'email': email});
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
