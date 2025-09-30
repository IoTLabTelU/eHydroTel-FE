import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static final _storage = const FlutterSecureStorage();

  static const accessToken = 'ACCESS_TOKEN';
  static const refreshToken = 'REFRESH_TOKEN';
  static const isLoggedIn = 'IS_LOGGED_IN';
  static const role = 'ROLE';
  static const locale = 'LOCALE';

  static Future<void> writeAccessToken(String value) async {
    await _storage.write(key: accessToken, value: value);
  }

  static Future<String?> readAccessToken() async {
    return await _storage.read(key: accessToken);
  }

  static Future<void> writeRefreshToken(String value) async {
    await _storage.write(key: refreshToken, value: value);
  }

  static Future<String?> readRefreshToken() async {
    return await _storage.read(key: refreshToken);
  }

  static Future<void> setIsLoggedIn(String value) async {
    await _storage.write(key: isLoggedIn, value: value);
  }

  static Future<bool?> readIsLoggedIn() async {
    final check = await _storage.read(key: isLoggedIn);
    if (check == null) {
      return null;
    }
    return check == 'true';
  }

  static Future<void> clearSession() async {
    await _storage.delete(key: accessToken);
    await _storage.delete(key: refreshToken);
    await _storage.write(key: isLoggedIn, value: 'false');
    await _storage.delete(key: role);
  }

  static Future<void> writeRole(String value) async {
    await _storage.write(key: role, value: value);
  }

  static Future<String?> readRole() async {
    return await _storage.read(key: role);
  }

  static Future<void> writeLocale(String value) async {
    await _storage.write(key: locale, value: value);
  }

  static Future<String?> readLocale() async {
    return await _storage.read(key: locale);
  }
}
