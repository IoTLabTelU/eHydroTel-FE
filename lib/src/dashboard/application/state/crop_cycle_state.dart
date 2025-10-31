import '../../domain/entities/crop_cycle_response.dart';

class CropCycleState {
  final bool isLoading;
  final CropCycleResponse? cropCycleResponse;
  final String? error;

  const CropCycleState({this.isLoading = false, this.cropCycleResponse, this.error});

  CropCycleState copyWith({bool? isLoading, CropCycleResponse? cropCycleResponse, String? error}) {
    return CropCycleState(
      isLoading: isLoading ?? this.isLoading,
      cropCycleResponse: cropCycleResponse ?? this.cropCycleResponse,
      error: error ?? this.error,
    );
  }
}

class CropCycleStateInitial extends CropCycleState {
  const CropCycleStateInitial() : super();
}

class CropCycleStateLoading extends CropCycleState {
  const CropCycleStateLoading() : super(isLoading: true);
}

class CropCycleStateLoaded extends CropCycleState {
  const CropCycleStateLoaded(CropCycleResponse response) : super(cropCycleResponse: response);
}

class CropCycleStateError extends CropCycleState {
  const CropCycleStateError(String errorMessage) : super(error: errorMessage);
}
