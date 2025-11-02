import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/constant.dart';
import 'package:hydro_iot/src/auth/domain/interfaces/auth_repository_interface.dart';
import 'package:hydro_iot/src/auth/data/model/auth_response.dart';
import 'package:hydro_iot/src/auth/data/model/otp_password_response.dart';
import 'package:hydro_iot/utils/utils.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  @override
  Future<Responses<AuthResponse>> signIn({required String email, required String password}) {
    return _apiClient
        .post<AuthResponse>(
          Params(
            path: EndpointStrings.login,
            fromJson: (json) => AuthResponse.fromJson(json['data']),
            body: {'email': email, 'password': password},
          ),
        )
        .then((response) async {
          final data = response.data;
          if (response.isSuccess && data != null) {
            final tokens = data.tokens;
            final user = data.user;
            if (tokens == null || user == null) {
              throw Exception('Invalid login response: tokens or user is null');
            }
            await Storage().writeTokens(
              accessToken: tokens.accessToken,
              refreshToken: tokens.refreshToken,
              expiresInSeconds: tokens.expiresIn,
            );
            await Storage().setIsLoggedIn('true');
            await Storage().writeRole(user.role);
            return response;
          } else {
            throw Exception(response.message ?? AppStrings.errorMessage);
          }
        });
  }

  @override
  Future<Responses<AuthResponse>> signInWithGoogle({required String idToken}) {
    return _apiClient
        .post<AuthResponse>(
          Params(
            path: EndpointStrings.googleLogin,
            fromJson: (json) => AuthResponse.fromJson(json['data']),
            body: {'id_token': idToken},
          ),
        )
        .then((response) async {
          final data = response.data;
          if (response.isSuccess && data != null) {
            final tokens = data.tokens;
            final user = data.user;
            if (tokens == null || user == null) {
              throw Exception('Invalid login response: tokens or user is null');
            }
            await Storage().writeTokens(
              accessToken: tokens.accessToken,
              refreshToken: tokens.refreshToken,
              expiresInSeconds: tokens.expiresIn,
            );
            await Storage().setIsLoggedIn('true');
            await Storage().writeRole(user.role);
            return response;
          } else {
            throw Exception(response.message ?? AppStrings.errorMessage);
          }
        });
  }

  @override
  Future<void> signOut() async {
    await Storage().clearSession();
  }

  @override
  Future<Responses<bool>> signUp({required String email, required String password, required String name}) async {
    return _apiClient
        .post<bool>(
          Params(
            path: EndpointStrings.register,
            body: {'email': email, 'password': password, 'name': name},
            fromJson: (json) => json,
          ),
        )
        .then((response) {
          if (!response.isSuccess) {
            throw Exception(response.message ?? AppStrings.errorMessage);
          }
          return response;
        });
  }

  @override
  Future<Responses> sendPasswordResetEmail({required String email}) {
    return _apiClient.post(Params(path: EndpointStrings.sendEmail, fromJson: (json) => json, body: {'email': email})).then((
      response,
    ) {
      if (!response.isSuccess) {
        throw Exception(response.message ?? AppStrings.errorMessage);
      }
      return response;
    });
  }

  @override
  Future<Responses<OtpPasswordResponse>> verifyOtp({required String otp, required String email}) {
    return _apiClient
        .post<OtpPasswordResponse>(
          Params(
            path: EndpointStrings.verifyOtp,
            fromJson: (json) => OtpPasswordResponse.fromJson(json['data']),
            body: {'otp': otp, 'email': email},
          ),
        )
        .then((response) {
          if (!response.isSuccess) {
            throw Exception(response.message ?? AppStrings.errorMessage);
          }
          return response;
        });
  }

  @override
  Future<Responses> resetPassword({required String newPassword, required String email, required String resetToken}) {
    return _apiClient
        .post(
          Params(
            path: EndpointStrings.resetPassword,
            fromJson: (json) => json,
            body: {'new_password': newPassword, 'email': email, 'reset_token': resetToken},
          ),
        )
        .then((response) {
          if (!response.isSuccess) {
            throw Exception(response.message ?? AppStrings.errorMessage);
          }
          return response;
        });
  }
}
