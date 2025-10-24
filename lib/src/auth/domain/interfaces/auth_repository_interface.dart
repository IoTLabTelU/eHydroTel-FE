import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/src/auth/data/model/auth_response.dart';
import 'package:hydro_iot/src/auth/data/model/otp_password_response.dart';

abstract class AuthRepositoryInterface {
  Future<Responses<AuthResponse>> signIn({required String email, required String password});
  Future<Responses<bool>> signUp({required String email, required String password, required String name});
  Future<Responses> sendPasswordResetEmail({required String email});
  Future<void> signInWithGoogle({required String idToken});
  Future<void> signOut();
  Future<Responses<OtpPasswordResponse>> verifyOtp({required String otp, required String email});
  Future<Responses> resetPassword({required String newPassword, required String email, required String resetToken});
}
