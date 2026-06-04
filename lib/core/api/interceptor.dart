import 'dart:async';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/utils/utils.dart';

typedef TokenRefreshFn = Future<Map<String, dynamic>> Function(String refreshToken);

class DioInterceptor extends Interceptor {
  final Storage storage;
  final TokenRefreshFn onRefresh;
  final Dio dio;
  final Function(String reason)? onLogout;

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
      log('REQUEST[${options.method}] => PATH: ${options.path}');
      log('Headers: ${options.headers}');
      log('Data: ${options.data}');
    }

    return super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      log('RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      log('Response Data: ${response.data}');
    }

    return super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (kDebugMode) {
      log('ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      log('Error Data: ${err.response?.data}');
    }

    final response = err.response;

    final message = response?.data is Map ? response?.data['message']?.toString().toLowerCase() ?? '' : '';

    bool isAuthError =
        (response?.statusCode == 401 ||
            response?.statusCode == 403 ||
            message.contains('jwt expired') ||
            message.contains('signature') ||
            message.contains('token expired') ||
            message.contains('unauthorized')) &&
        !_isPublicRequest(err.requestOptions);

    if (response == null || !isAuthError) {
      return handler.next(err); // Biarkan error lain lewat
    }

    // avoid recursive refresh
    if (_isRefreshRequest(err.requestOptions)) {
      await _forceLogout('Refresh token invalid or expired');
      return handler.reject(DioException(requestOptions: err.requestOptions, error: 'Session expired', type: DioExceptionType.cancel));
    }

    final options = err.requestOptions;

    try {
      final newToken = await _enqueueRequest(options);
      if (newToken == null) {
        return handler.reject(DioException(requestOptions: err.requestOptions, error: 'Session Expired', type: DioExceptionType.cancel));
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
      log('AuthInterceptor retry failed: $e\n$st');
      return handler.reject(
        DioException(requestOptions: err.requestOptions, error: 'Something went wrong. Please login again!', type: DioExceptionType.cancel),
      );
    }
  }

  bool _isRefreshRequest(RequestOptions options) {
    final path = options.path;
    return path.contains('${BaseConfigs.baseUrl}/auth/refresh-token') || path.contains('refresh-token');
  }

  bool _isPublicRequest(RequestOptions options) {
    return options.path.contains('/auth/login') || options.path.contains('/auth/register') || options.path.contains('/auth/password/reset');
  }

  Future<String?> _enqueueRequest(RequestOptions requestOptions) async {
    final completer = Completer<String?>();
    _queue.add(_PendingRequest(requestOptions, completer));

    if (!_isRefreshing) {
      _isRefreshing = true;
      try {
        final refreshToken = await storage.readRefreshToken;
        if (refreshToken == null) {
          await _forceLogout('Refresh token not found');
          _completeAll(null);
          return null;
        }

        Map<String, dynamic> refreshResp;
        try {
          refreshResp = await onRefresh(refreshToken);
        } catch (e) {
          await _forceLogout('Failed to refresh token');
          _completeAll(null);
          return null;
        }

        final newAccess = refreshResp['access_token'] as String?;
        final newRefresh = refreshResp['refresh_token'] as String? ?? refreshToken;
        final expiresIn = refreshResp['expires_in'] is int
            ? refreshResp['expires_in'] as int
            : int.tryParse(refreshResp['expires_in']?.toString() ?? '0') ?? 0;

        if (newAccess == null) {
          await _forceLogout('Failed to obtain new access token');
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

  Future<void> _forceLogout(String reason) async {
    if (onLogout != null) {
      try {
        onLogout!(reason);
      } catch (e) {
        debugPrint('onLogout callback error: $e');
      }
    }
  }
}

class _PendingRequest {
  final RequestOptions options;
  final Completer<String?> completer;
  _PendingRequest(this.options, this.completer);
}
