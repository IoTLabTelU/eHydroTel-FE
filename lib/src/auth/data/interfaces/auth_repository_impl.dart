import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/src/auth/data/model/auth_response.dart';

abstract class AuthRepositoryInterface {
  Future<Responses<AuthResponse>> signIn({required String email, required String password});

  Future<Responses<bool>> signUp({required String email, required String password, required String name});

  Future<void> sendPasswordResetEmail({required String email});

  Future<void> signInWithGoogle();

  Future<void> signOut();
}
