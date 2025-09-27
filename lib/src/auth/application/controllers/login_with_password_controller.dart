import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydro_iot/src/auth/application/providers/auth_provider.dart';
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

  Future<void> loginWithGoogle() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final serverClientId = dotenv.env['GOOGLE_CLIENT_ID'];
      final GoogleSignIn googleSignIn = GoogleSignIn.instance;
      await googleSignIn.initialize(serverClientId: serverClientId);
      final GoogleSignInAccount googleUser = await googleSignIn.authenticate();
      final GoogleSignInAuthentication googleAuth = googleUser.authentication;
      final idToken = googleAuth.idToken;
      final loginResponse = await ref.read(authRepositoryProvider).signInWithGoogle(idToken: idToken ?? '');
      return loginResponse.data!;
    });
  }
}
