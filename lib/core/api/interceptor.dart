import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/utils/utils.dart';

typedef TokenRefreshFn = Future<Map<String, dynamic>> Function(String refreshToken);

class DioInterceptor extends Interceptor {
  final Storage storage;
  final TokenRefreshFn onRefresh;
  final Dio dio;
  final VoidCallback? onLogout;

  bool _isRefreshing = false;
  final List<_PendingRequest> _queue = [];

  DioInterceptor(this.dio, this.storage, this.onRefresh, this.onLogout);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    try {
      final access = await storage.readAccessToken;
      if (access != null && access.isNotEmpty) {
        options.headers['Authorization'] = 'Bearer $access';
      }
    } catch (e, st) {
      debugPrint('Interceptor onRequest error: $e\n$st');
    }

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

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      print('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      print('Error Data: ${err.response?.data}');
    }

    final response = err.response;
    if (response == null || response.statusCode != 401) {
      return handler.next(err);
    }

    // avoid recursive refresh
    if (_isRefreshRequest(err.requestOptions)) {
      await _forceLogout();
      return handler.next(err);
    }

    final options = err.requestOptions;

    try {
      final newToken = await _enqueueRequest(options);
      if (newToken == null) {
        return handler.next(err);
      }

      final newHeaders = Map<String, dynamic>.from(options.headers);
      newHeaders['Authorization'] = 'Bearer $newToken';

      final retryResponse = await dio.request(
        options.path,
        data: options.data,
        queryParameters: options.queryParameters,
        options: Options(
          method: options.method,
          headers: newHeaders,
          responseType: options.responseType,
          contentType: options.contentType,
          followRedirects: options.followRedirects,
          validateStatus: options.validateStatus,
          receiveDataWhenStatusError: options.receiveDataWhenStatusError,
          extra: options.extra,
        ),
      );

      return handler.resolve(retryResponse);
    } catch (e, st) {
      debugPrint('AuthInterceptor retry failed: $e\n$st');
      handler.next(err);
    }
  }

  bool _isRefreshRequest(RequestOptions options) {
    final path = options.path;
    return path.contains('${BaseConfigs.baseUrl}/auth/refresh-token') || path.contains('refresh-token');
  }

  Future<String?> _enqueueRequest(RequestOptions requestOptions) async {
    final completer = Completer<String?>();
    _queue.add(_PendingRequest(requestOptions, completer));

    if (!_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await storage.readRefreshToken;
        if (refreshToken == null) {
          await _forceLogout();
          _completeAll(null);
          return null;
        }

        Map<String, dynamic> refreshResp;
        try {
          refreshResp = await onRefresh(refreshToken);
        } catch (e) {
          await _forceLogout();
          _completeAll(null);
          return null;
        }

        final newAccess = refreshResp['access_token'] as String?;
        final newRefresh = refreshResp['refresh_token'] as String? ?? refreshToken;
        final expiresIn = refreshResp['expires_in'] is int
            ? refreshResp['expires_in'] as int
            : int.tryParse(refreshResp['expires_in']?.toString() ?? '0') ?? 0;

        if (newAccess == null) {
          await _forceLogout();
          _completeAll(null);
          return null;
        }

        await storage.writeTokens(accessToken: newAccess, refreshToken: newRefresh, expiresInSeconds: expiresIn);

        _completeAll(newAccess);
        return newAccess;
      } finally {
        _isRefreshing = false;
      }
    } else {
      // Wait for other refresh in progress
      return completer.future;
    }
  }

  void _completeAll(String? token) {
    for (final p in _queue) {
      if (!p.completer.isCompleted) p.completer.complete(token);
    }
    _queue.clear();
  }

  Future<void> _forceLogout() async {
    await storage.clearSession();
    if (onLogout != null) {
      try {
        onLogout!();
      } catch (e) {
        debugPrint('onLogout callback error: $e');
      }
    }
  }

  // Future<void> _handleTokenError(DioException err, ErrorInterceptorHandler handler) async {
  //   if (err.response?.statusCode == 401) {
  //     try {
  //       final refreshToken = await Storage.readRefreshToken();
  //       if (refreshToken != null) {
  //         await _refreshToken();

  //         final response = await _retryRequest(err.requestOptions);
  //         return handler.resolve(response);
  //       } else {
  //         return handler.reject(err);
  //       }
  //     } catch (e) {
  //       // Refresh token failed, redirect to login
  //       await Storage.clearSession();
  //       return handler.reject(err);
  //     }
  //   } else {
  //     return super.onError(err, handler);
  //   }
  // }

  // Future<void> _refreshToken() async {
  //   final refreshToken = await Storage.readRefreshToken();

  //   try {
  //     final response = await dio.post(
  //       '${BaseConfigs.baseUrl}/auth/refresh-token',
  //       data: json.encode({'refresh_token': refreshToken}),
  //     );

  //     if (response.statusCode == 200 && response.data != null) {
  //       final data = response.data['data'];
  //       TokenEntity token = TokenEntity.fromJson(data);
  //       if (data != null && data['access_token'] != null) {
  //         await Storage.writeAccessToken(token.accessToken);
  //         await Storage.writeRefreshToken(token.refreshToken);
  //       }
  //     }
  //   } catch (e) {
  //     // If refresh fails, clear session and require re-login
  //     await Storage.clearSession();
  //     rethrow;
  //   }
  // }

  // Future<Response<dynamic>> _retryRequest(RequestOptions requestOptions) async {
  //   final accessToken = await Storage.readAccessToken();

  //   final options = Options(
  //     method: requestOptions.method,
  //     headers: {...requestOptions.headers, 'Authorization': 'Bearer $accessToken'},
  //   );

  //   return dio.request<dynamic>(
  //     requestOptions.path,
  //     data: requestOptions.data,
  //     queryParameters: requestOptions.queryParameters,
  //     options: options,
  //   );
  // }
}

class _PendingRequest {
  final RequestOptions options;
  final Completer<String?> completer;
  _PendingRequest(this.options, this.completer);
}
