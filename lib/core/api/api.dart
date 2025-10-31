import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:hydro_iot/core/api/interceptor.dart';
import 'package:hydro_iot/res/res.dart';

class Params<T> {
  final String path;
  final T Function(dynamic) fromJson;
  final Map<String, dynamic>? body;
  final Map<String, dynamic>? queryParameters;
  final Options? options;

  Params({required this.path, required this.fromJson, this.queryParameters, this.body, this.options});
}

class Responses<T> {
  Map<String, String>? headers;
  T? data;
  int? statusCode;
  dynamic message;

  Responses({this.headers, this.data, this.statusCode, this.message});

  bool get isSuccess => statusCode == 200 || statusCode == 201;
}

enum ResponseStatus { normal, waiting, success, connectionError, serverError, notFound }

class ApiClient {
  final Dio _dio = Dio();

  ApiClient() {
    _dio.interceptors.add(DioInterceptor(_dio));
  }

  Future<Responses<T>> _responseHandler<T>(Response response, Params<T> param) async {
    final int statusCode = response.statusCode ?? 0;

    try {
      final jsonBody = response.data is String ? json.decode(response.data) : response.data;

      final dataField = jsonBody['data'];
      final messageField = jsonBody['message'];

      if (dataField == null) {
        return Responses<T>(data: null, statusCode: statusCode, message: messageField);
      }

      final T data = param.fromJson(jsonBody);
      return Responses<T>(data: data, statusCode: statusCode, message: messageField);
    } catch (e) {
      return Responses<T>(data: null, statusCode: statusCode, message: AppStrings.serverErrorMessage);
    }
  }

  Future<Responses<T>> _errorHandler<T>(DioException e) async {
    dynamic errorMessage = AppStrings.errorMessage;

    try {
      if (e.response?.data != null) {
        final responseData = e.response!.data;

        if (responseData is String) {
          final decoded = json.decode(responseData);
          errorMessage = decoded['message'] ?? decoded['message'] ?? AppStrings.errorMessage;
        } else if (responseData is Map<String, dynamic>) {
          errorMessage = responseData['message'] ?? responseData['message'] ?? AppStrings.errorMessage;
        }
      } else {
        errorMessage = ResponseStatus.connectionError;
      }
    } catch (_) {
      errorMessage = AppStrings.serverErrorMessage;
    }

    final statusCode = e.response?.statusCode;

    if (statusCode != null && statusCode >= 500) {
      return Responses<T>(data: null, statusCode: statusCode, message: ResponseStatus.serverError);
    }

    return Responses<T>(data: null, statusCode: statusCode, message: errorMessage);
  }

  Future<Responses<T>> get<T>(Params<T> param) async {
    try {
      final response = await _dio.get(
        param.path,
        data: param.body != null ? json.encode(param.body) : null,
        queryParameters: param.queryParameters,
        options: param.options,
      );
      final Responses<T> result = await _responseHandler<T>(response, param);
      return result;
    } on DioException catch (e) {
      final Responses<T> error = await _errorHandler(e);
      return error;
    }
  }

  Future<Responses<T>> post<T>(Params<T> param) async {
    try {
      final response = await _dio.post(
        param.path,
        data: param.body != null ? json.encode(param.body) : null,
        queryParameters: param.queryParameters,
        options: param.options,
      );
      final Responses<T> result = await _responseHandler<T>(response, param);
      return result;
    } on DioException catch (e) {
      final Responses<T> error = await _errorHandler(e);
      return error;
    }
  }

  Future<Responses<T>> patch<T>(Params<T> param) async {
    try {
      final response = await _dio.patch(
        param.path,
        data: param.body != null ? json.encode(param.body) : null,
        queryParameters: param.queryParameters,
        options: param.options,
      );
      final Responses<T> result = await _responseHandler<T>(response, param);
      return result;
    } on DioException catch (e) {
      final Responses<T> error = await _errorHandler(e);
      return error;
    }
  }

  Future<Responses<T>> put<T>(Params<T> param) async {
    try {
      final response = await _dio.put(
        param.path,
        data: param.body != null ? json.encode(param.body) : null,
        queryParameters: param.queryParameters,
        options: param.options,
      );
      final Responses<T> result = await _responseHandler<T>(response, param);
      return result;
    } on DioException catch (e) {
      final Responses<T> error = await _errorHandler(e);
      return error;
    }
  }

  Future<Responses<T>> delete<T>(Params<T> param) async {
    try {
      final response = await _dio.delete(
        param.path,
        data: param.body != null ? json.encode(param.body) : null,
        queryParameters: param.queryParameters,
        options: param.options,
      );
      final Responses<T> result = await _responseHandler<T>(response, param);
      return result;
    } on DioException catch (e) {
      final Responses<T> error = await _errorHandler(e);
      return error;
    }
  }
}

final ApiClient apiClient = ApiClient();
