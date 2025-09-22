import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/src/auth/domain/entities/token_entity.dart';
import 'package:hydro_iot/utils/utils.dart';

class DioInterceptor extends Interceptor {
  final Dio dio;

  DioInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final accessToken = await Storage.readAccessToken();
    options.headers['Authorization'] = 'Bearer $accessToken';

    if (kDebugMode) {
      print('REQUEST[${options.method}] => PATH: ${options.path}');
      print('Headers: ${options.headers}');
      print('Data: ${options.data}');
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      print('Response Data: ${response.data}');
    }

    // Check if response contains refresh token in cookies
    if (response.headers.map.containsKey('set-cookie')) {
      final cookies = response.headers.map['set-cookie'];
      if (cookies != null) {
        for (final cookie in cookies) {
          if (cookie.contains('refresh_token=')) {
            // Extract refresh token from cookie if needed
            // This is optional as API already returns refresh token in response body
          }
        }
      }
    }

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      print('Error Data: ${err.response?.data}');
    }

    await _handleTokenError(err, handler);
  }

  Future<void> _handleTokenError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        final refreshToken = await Storage.readRefreshToken();
        if (refreshToken != null) {
          await _refreshToken();

          final response = await _retryRequest(err.requestOptions);
          return handler.resolve(response);
        } else {
          return handler.reject(err);
        }
      } catch (e) {
        // Refresh token failed, redirect to login
        await Storage.clearSession();
        return handler.reject(err);
      }
    } else {
      return super.onError(err, handler);
    }
  }

  Future<void> _refreshToken() async {
    final refreshToken = await Storage.readRefreshToken();

    try {
      final response = await dio.post(
        '${BaseConfigs.baseUrl}/auth/refresh-token',
        data: json.encode({'refresh_token': refreshToken}),
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data['data'];
        TokenEntity token = TokenEntity.fromJson(data);
        if (data != null && data['access_token'] != null) {
          await Storage.writeAccessToken(token.accessToken);
          await Storage.writeRefreshToken(token.refreshToken);
        }
      }
    } catch (e) {
      // If refresh fails, clear session and require re-login
      await Storage.clearSession();
      rethrow;
    }
  }

  Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
    final accessToken = await Storage.readAccessToken();

    final options = Options(
      method: requestOptions.method,
      headers: {...requestOptions.headers, 'Authorization': 'Bearer $accessToken'},
    );

    return dio.request<dynamic>(
      requestOptions.path,
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
      options: options,
    );
  }
}
