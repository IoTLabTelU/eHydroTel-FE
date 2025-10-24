import 'package:hydro_iot/src/auth/application/providers/auth_provider.dart';
import 'package:hydro_iot/src/auth/data/model/otp_password_response.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'change_password_controller.g.dart';

@riverpod
class ChangePasswordController extends _$ChangePasswordController {
  @override
  Future<void> build() async {
    // Initialization logic if needed
  }

  Future<void> changePasswordRequest({required String email}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).sendPasswordResetEmail(email: email);
      return;
    });
  }

  Future<OtpPasswordResponse?> verifyOtp({required String email, required String otp}) async {
    state = const AsyncValue.loading();
    final response = await ref.read(authRepositoryProvider).verifyOtp(otp: otp, email: email);
    if (!response.isSuccess) {
      state = AsyncValue.error(response.message ?? 'Failed to verify OTP', StackTrace.current);
      throw Exception(response.message ?? 'Failed to verify OTP');
    }
    state = const AsyncValue.data(null);
    return response.data;
  }

  Future<bool> resetPassword({required String email, required String newPassword, required String resetToken}) async {
    state = const AsyncValue.loading();
    final response = await ref
        .read(authRepositoryProvider)
        .resetPassword(email: email, newPassword: newPassword, resetToken: resetToken);
    if (!response.isSuccess) {
      state = AsyncValue.error(response.message ?? 'Failed to reset password', StackTrace.current);
      throw Exception(response.message ?? 'Failed to reset password');
    }
    state = const AsyncValue.data(null);
    return response.isSuccess;
  }
}
