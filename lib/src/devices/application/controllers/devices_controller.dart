import 'package:hydro_iot/src/devices/application/providers/device_provider.dart';
import 'package:hydro_iot/src/devices/domain/entities/device_entity.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'devices_controller.g.dart';

const _kLimit = 10;

enum DeviceOperation { none, update, delete }

@riverpod
class DevicesController extends _$DevicesController {
  DeviceOperation currentOperation = DeviceOperation.none;
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  bool get hasMore => _hasMore;
  bool get isLoadingMore => _isLoadingMore;

  @override
  FutureOr<List<DeviceEntity>> build() async {
    return _fetchPage(page: 1, replace: true);
  }

  /// Dipanggil oleh pull-to-refresh — reset ke halaman 1
  Future<void> fetchDevices() async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() => _fetchPage(page: 1, replace: true));
  }

  /// Dipanggil saat scroll mentok bawah
  Future<void> loadMore() async {
    // Guard: jangan fetch kalau masih loading, sudah tidak ada data, atau sedang load more
    if (_isLoadingMore || !_hasMore || state.isLoading) return;

    _isLoadingMore = true;
    // Rebuild screen supaya loading indicator di bawah list muncul
    ref.notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final newItems = await _fetchPage(page: nextPage, replace: false);

      // Gabungkan dengan data lama
      final current = state.value ?? [];
      state = AsyncValue.data([...current, ...newItems]);
    } catch (e, st) {
      // Gagal load more — jangan replace state, cukup set error sementara
      // biar list lama tetap tampil. Controller boleh surface error via snackbar di screen.
      state = AsyncValue.error(e, st);
    } finally {
      _isLoadingMore = false;
      ref.notifyListeners();
    }
  }

  Future<List<DeviceEntity>> _fetchPage({required int page, required bool replace}) async {
    final res = await ref.read(devicesRepositoryProvider).getMyDevices(page: page, limit: _kLimit);

    if (!res.isSuccess) {
      throw Exception(res.message ?? 'Failed to fetch devices');
    }

    final items = res.data ?? [];

    // Tandai apakah masih ada halaman berikutnya
    _hasMore = items.length >= _kLimit;
    _currentPage = page;

    return items;
  }

  Future<void> registerDevice({required String name, required String description, required String serialNumber}) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(devicesRepositoryProvider).registerDevice(name: name, description: description, serialNumber: serialNumber);
      return state.value ?? [];
    });
  }

  Future<DeviceEntity?> getDeviceDetails(String deviceId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(devicesRepositoryProvider).getDeviceDetails(deviceId);
      return state.value ?? [];
    });
    return null;
  }

  Future<void> updateDevice({required String deviceId, required String name, required String description, String? ssid, String? wifiPassword}) async {
    currentOperation = DeviceOperation.update;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref
          .read(devicesRepositoryProvider)
          .updateDevice(deviceId: deviceId, name: name, description: description, ssid: ssid, wifiPassword: wifiPassword);
      return state.value ?? [];
    });
    currentOperation = DeviceOperation.none;
  }

  Future<void> deleteDevice(String deviceId) async {
    currentOperation = DeviceOperation.delete;
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      await ref.read(devicesRepositoryProvider).deleteDevice(deviceId);
      return state.value ?? [];
    });
    currentOperation = DeviceOperation.none;
  }
}
