import 'package:dio/dio.dart';
import 'package:hydro_iot/core/core.dart';

class AuthApi {
  final Dio _dio = Dio();

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post(
        BaseConfigs.login,
        data: {'email': email, 'password': password},
        options: Options(headers: {'Content-Type': 'application/json'}),
      );

      final data = response.data['data'];
      return {
        'id': data['user']['id'],
        'name': data['user']['name'],
        'email': data['user']['email'],
        'role': data['user']['role'],
        'accessToken': data['tokens']['access_token'],
        'refreshToken': data['tokens']['refresh_token'],
        'expiresIn': data['tokens']['expires_in'],
      };
    } on DioException catch (e) {
      final status = e.response?.statusCode ?? 0;
      final msg =
          e.response?.data?['message'] ?? e.message ?? 'Something went Wrong';

      switch (status) {
        case 400:
          throw Exceptions.badRequest(message: msg);
        case 404:
          throw Exceptions.notFound(message: msg);
        case 422:
          throw Exceptions.unprocessableEntity(message: msg);
        case 500:
          throw Exceptions.internalServerError(message: msg);
        default:
          throw Exceptions.unprocessableEntity(message: msg.toString());
      }
    }
  }
}
