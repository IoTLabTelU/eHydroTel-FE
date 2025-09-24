import 'package:freezed_annotation/freezed_annotation.dart';

part 'register_my_device_request.freezed.dart';
part 'register_my_device_request.g.dart';

@freezed
sealed class RegisterMyDeviceRequest with _$RegisterMyDeviceRequest {
  @JsonSerializable(fieldRename: FieldRename.snake, explicitToJson: true)
  const factory RegisterMyDeviceRequest({required String name, required String description, required String serialNumber}) =
      _RegisterMyDeviceRequest;

  factory RegisterMyDeviceRequest.fromJson(Map<String, dynamic> json) => _$RegisterMyDeviceRequestFromJson(json);
}
