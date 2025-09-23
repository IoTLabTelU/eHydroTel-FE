import 'package:hydro_iot/src/auth/application/providers/auth_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'register_with_password_controller.g.dart';

@riverpod
class RegisterWithPasswordController extends _$RegisterWithPasswordController {
  @override
  FutureOr<bool> build() async {
    return false;
  }

  Future<bool> registerWithEmailPassword(String name, String email, String password) async {
    state = const AsyncValue.loading();
    try {
      await ref.read(authRepositoryProvider).signUp(name: name, email: email, password: password);
      state = const AsyncValue.data(true);
      return true;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
