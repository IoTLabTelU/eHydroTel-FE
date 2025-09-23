// ignore_for_file: avoid_manual_providers_as_generated_provider_dependency
import 'package:hydro_iot/core/providers/provider.dart';
import 'package:hydro_iot/src/auth/data/repositories/auth_repository.dart';
import 'package:hydro_iot/src/auth/data/repositories/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return AuthRepository(client);
}

@riverpod
UserRepository userRepository(Ref ref) {
  final client = ref.watch(apiClientProvider);
  return UserRepository(client);
}
