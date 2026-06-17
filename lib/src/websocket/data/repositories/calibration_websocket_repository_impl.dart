import 'dart:async';
import 'dart:developer';

import 'package:hydro_iot/src/devices/domain/entities/calibration_timer_entity.dart';
import 'package:hydro_iot/src/devices/domain/entities/step_advance_result_entity.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket;

import '../../../../core/providers/websocket_provider.dart';
import '../../domain/repositories/calibration_websocket_repository.dart';

class CalibrationWebsocketRepositoryImpl implements CalibrationWebsocketRepository {
  final CalibrationWebsocket _websocket;
  CalibrationWebsocketRepositoryImpl(this._websocket);

  socket.Socket? channel;
  bool isDisposed = false;
  bool isConnected = false;
  bool isListening = false;
  int _retryCount = 0;
  Timer? _reconnectTimer;

  // Serial device yang sedang di-join. Dipakai untuk membangun nama event
  // ('calibration:${serial}:timer_start', dst) karena backend menyisipkan
  // serial number di nama event-nya, bukan di payload.
  String? _serial;

  // StreamController untuk masing-masing event. broadcast karena bisa ada
  // lebih dari satu listener (controller riverpod + widget lain jika perlu).
  final _timerStartController = StreamController<CalibrationTimerEntity>.broadcast();
  final _stepAdvanceController = StreamController<StepAdvanceResultEntity>.broadcast();
  final _reconnectController = StreamController<void>.broadcast();

  @override
  void joinRoom(String serial) async {
    _serial = serial;
    channel = await _websocket.connect();
    isConnected = true;
    isDisposed = false;

    channel?.emit('calibration:join', {'serial': serial});

    _attachListeners(serial);
  }

  void _attachListeners(String serial) {
    if (isListening) return;
    isListening = true;

    // Event timer_start — payload sesuai dokumen:
    // { session_id, step, started_at, duration_sec, ends_at }
    channel?.on('calibration:$serial:timer_start', (data) {
      try {
        final timer = CalibrationTimerEntity.fromJson(data as Map<String, dynamic>);
        _timerStartController.add(timer);
      } catch (e, st) {
        log('Failed to parse timer_start payload: $e\n$st');
      }
    });

    // Event step_advance — payload sesuai dokumen:
    // { session_id, completed_step, next_step, progress }
    channel?.on('calibration:$serial:step_advance', (data) {
      try {
        final result = StepAdvanceResultEntity.fromJson(data as Map<String, dynamic>);
        _stepAdvanceController.add(result);
      } catch (e, st) {
        log('Failed to parse step_advance payload: $e\n$st');
      }
    });

    // Socket.IO bawaan: 'connect' setelah reconnect berhasil.
    // Re-join room otomatis supaya backend tetap kirim event ke koneksi baru,
    // lalu beri tahu listener (controller) untuk resync via GET /:serial/session.
    channel?.onConnect((_) {
      final wasReconnecting = _retryCount > 0;
      _retryCount = 0;
      _reconnectTimer?.cancel();

      if (wasReconnecting) {
        channel?.emit('calibration:join', {'serial': serial});
        _reconnectController.add(null);
      }
    });

    channel?.onDisconnect((_) {
      isConnected = false;
      _scheduleReconnectTracking();
    });

    channel?.onConnectError((err) {
      isConnected = false;
      log('Calibration socket connect error: $err');
    });

    channel?.onError((err) {
      log('Calibration socket error: $err');
    });
  }

  /// socket_io_client sudah handle reconnect attempt secara internal
  /// (default: reconnection true). Method ini hanya melacak bahwa kita
  /// memang dalam proses reconnect, supaya saat 'connect' nyala lagi
  /// kita tahu itu reconnect bukan initial connect.
  void _scheduleReconnectTracking() {
    _retryCount++;
    _reconnectTimer?.cancel();
    _reconnectTimer = Timer(const Duration(seconds: 2), () {
      // no-op timer, hanya placeholder jika nanti perlu backoff/give-up logic
    });
  }

  @override
  void leaveRoom(String serial) {
    channel?.emit('calibration:leave', {'serial': serial});
    dispose();
  }

  @override
  Stream<CalibrationTimerEntity> get onTimerStart => _timerStartController.stream;

  @override
  Stream<StepAdvanceResultEntity> get onStepAdvance => _stepAdvanceController.stream;

  @override
  Stream<void> get onReconnect => _reconnectController.stream;

  @override
  void dispose() {
    isDisposed = true;
    isListening = false;
    isConnected = false;
    channel?.off('calibration:$_serial:timer_start');
    channel?.off('calibration:$_serial:step_advance');
    channel?.dispose();
    _reconnectTimer?.cancel();

    // PENTING: jangan close StreamController di sini jika repository ini
    // di-reuse (provider non-autoDispose) — karena controller yang sudah
    // di-close tidak bisa dipakai lagi. Jika repository dibuat per-screen
    // (autoDispose / dibuat ulang tiap join), aman untuk close semua:
    //
    // _timerStartController.close();
    // _stepAdvanceController.close();
    // _reconnectController.close();
  }
}
