import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/src/auth/domain/entities/user_entity.dart';

abstract class UserRepositoryInterface {
  Future<Responses<UserEntity?>> getUserProfile();
  Future<void> updateUserProfile({required Map<String, dynamic> user});
}
