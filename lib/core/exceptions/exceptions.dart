import 'package:freezed_annotation/freezed_annotation.dart';

part 'exceptions.freezed.dart';

@freezed
///
class Exceptions with _$Exceptions implements Exception {
  const Exceptions._();

  /// Unexpected error
  const factory Exceptions.unprocessableEntity({required String message}) =
      _UnprocessableEntityExceptions;

  /// Expected value is null or empty
  const factory Exceptions.empty() = _EmptyExceptions;

  /// 400 Error Response Code
  const factory Exceptions.badRequest({required dynamic message}) =
      _BadRequestExceptions;

  /// 500 Error Response Code
  const factory Exceptions.internalServerError({required dynamic message}) =
      _InternalServerErrorExceptions;

  /// 404 Error Response Code
  const factory Exceptions.notFound({required dynamic message}) =
      _NotFoundExceptions;

  /// Get the error message for specified failure
  String get unknownError => this is _UnprocessableEntityExceptions
      ? (this as _UnprocessableEntityExceptions).message
      : '$this';

  /// Get the error message for specified failure
  dynamic get badRequestError => this is _BadRequestExceptions
      ? (this as _BadRequestExceptions).message
      : '$this';

  /// Get the error message for specified failure
  dynamic get internalServerError => this is _InternalServerErrorExceptions
      ? (this as _InternalServerErrorExceptions).message
      : '$this';

  /// Get the error message for specified failure
  dynamic get notFoundError => this is _NotFoundExceptions
      ? (this as _NotFoundExceptions).message
      : '$this';

  /// Get all of the error message
  dynamic get allError => this is _UnprocessableEntityExceptions
      ? (this as _UnprocessableEntityExceptions).message
      : this is _BadRequestExceptions
      ? (this as _BadRequestExceptions).message
      : this is _InternalServerErrorExceptions
      ? (this as _InternalServerErrorExceptions).message
      : this is _NotFoundExceptions
      ? (this as _NotFoundExceptions).message
      : '$this';
}
