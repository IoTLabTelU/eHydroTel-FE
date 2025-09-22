import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/constant.dart';
import 'package:hydro_iot/src/auth/data/interfaces/auth_repository_impl.dart';
import 'package:hydro_iot/src/auth/data/model/auth_response.dart';
import 'package:hydro_iot/utils/utils.dart';

class AuthRepository implements AuthRepositoryInterface {
  final ApiClient _apiClient;

  AuthRepository(this._apiClient);

  @override
  Future<void> sendPasswordResetEmail({required String email}) {
    // TODO: implement sendPasswordResetEmail
    throw UnimplementedError();
  }

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
            await Storage.writeAccessToken(tokens.accessToken);
            await Storage.writeRefreshToken(tokens.refreshToken);
            await Storage.setIsLoggedIn('true');
            await Storage.writeRole(user.role);
            return response;
          } else {
            throw Exception(response.message ?? AppStrings.errorMessage);
          }
        });
  }

  @override
  Future<void> signInWithGoogle() {
    // TODO: implement signInWithGoogle
    throw UnimplementedError();
  }

  @override
  Future<void> signOut() async {
    await Storage.clearSession();
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
}
