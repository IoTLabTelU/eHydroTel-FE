import 'package:hydro_iot/core/api/api.dart';
import 'package:hydro_iot/res/constant.dart';
import 'package:hydro_iot/src/devices/data/models/history_model.dart';
import 'package:hydro_iot/src/devices/domain/repositories/history_repository.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final ApiClient apiClient;
  HistoryRepositoryImpl({required this.apiClient});
  @override
  Future<Responses<HistoryModel>> getCropCycleHistory({required String cropCycleId, DateTime? start, DateTime? end}) {
    return apiClient
        .get(
          Params<HistoryModel>(
            path: EndpointStrings.historySensor,
            fromJson: (json) => HistoryModel.fromJson(json['data']),
            queryParameters: {
              'cropCycleId': cropCycleId,
              if (start != null) 'start': start.toIso8601String(),
              if (end != null) 'end': end.toIso8601String(),
            },
          ),
        )
        .then((response) {
          if (!response.isSuccess) {
            throw Exception(response.message ?? 'Failed to get crop cycle history');
          }
          return response;
        });
  }
}
