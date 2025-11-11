import 'dart:developer';

import 'package:hydro_iot/core/api/api.dart';
import 'package:hydro_iot/res/constant.dart';
import 'package:hydro_iot/src/devices/data/models/history_model.dart';
import 'package:hydro_iot/src/devices/domain/repositories/history_repository.dart';
import 'package:intl/intl.dart';

class HistoryRepositoryImpl implements HistoryRepository {
  final ApiClient apiClient;
  HistoryRepositoryImpl({required this.apiClient});
  @override
  Future<Responses<HistoryModel>> getCropCycleHistory({required String cropCycleId, DateTime? start, DateTime? end}) {
    return apiClient
        .get(
          Params<HistoryModel>(
            path: EndpointStrings.historySensor,
            fromJson: (json) {
              log(json.toString());
              return HistoryModel.fromJson(json['data']);
            },
            queryParameters: {
              'cropCycleId': cropCycleId,
              if (start != null) 'start': DateFormat('yyyy-MM-dd').format(start),
              if (end != null) 'end': DateFormat('yyyy-MM-dd').format(end),
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
