import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/src/auth/domain/interfaces/user_repository_interface.dart';
import 'package:hydro_iot/src/auth/domain/entities/user_entity.dart';

import '../../../../res/res.dart';

class UserRepository implements UserRepositoryInterface {
  final ApiClient _apiClient;

  UserRepository(this._apiClient);

  @override
  Future<Responses<UserEntity?>> getUserProfile() {
    return _apiClient
        .get(Params(path: EndpointStrings.userProfile, fromJson: (json) => UserEntity.fromJson(json['data']['user'])))
        .then((response) {
          if (response.isSuccess && response.data != null) {
            return response;
          } else {
            throw Exception(response.message ?? AppStrings.errorMessage);
          }
        });
  }

  @override
  Future<void> updateUserProfile({required Map<String, dynamic> user}) {
    return _apiClient.put(Params(path: EndpointStrings.updateProfile, body: user, fromJson: (json) => null)).then((
      response,
    ) {
      if (!response.isSuccess) {
        throw Exception(response.message ?? AppStrings.errorMessage);
      }
    });
  }
}
