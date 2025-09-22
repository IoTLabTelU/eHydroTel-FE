import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/api/api.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});
