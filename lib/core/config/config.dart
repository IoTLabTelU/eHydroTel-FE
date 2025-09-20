import 'package:flutter_dotenv/flutter_dotenv.dart';

class BaseConfigs {
  static final baseUrl = dotenv.env['BASE_URL'];
  static final login = '$baseUrl/auth/login';
}
