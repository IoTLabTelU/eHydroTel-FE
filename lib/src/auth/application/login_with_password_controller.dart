import 'package:hydro_iot/src/auth/auth_provider.dart';
import 'package:hydro_iot/src/auth/data/model/auth_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'login_with_password_controller.g.dart';

@riverpod
class LoginWithPasswordController extends _$LoginWithPasswordController {
  @override
  FutureOr<AuthResponse> build() async {
    return const AuthResponse(user: null, tokens: null);
  }

  Future<void> loginWithEmailPassword(String email, String password) async {
    state = const AsyncValue.loading();

    state = await AsyncValue.guard(() async {
      final loginResponse = await ref.read(authRepositoryProvider).signIn(email: email, password: password);
      if (!ref.mounted) {
        return const AuthResponse(user: null, tokens: null);
      }
      if (loginResponse.isSuccess && loginResponse.data != null) {
        return loginResponse.data!;
      } else {
        throw Exception(loginResponse.message ?? 'Login failed');
      }
    });
  }
}
