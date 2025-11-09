import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/config/config.dart';
import 'package:hydro_iot/utils/storage.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket;

final sensorWebsocketProvider = Provider((ref) {
  ref.onDispose(() {
    debugPrint('Disposing SensorWebsocket');
  });
  ref.onCancel(() {
    debugPrint('SensorWebsocket connection cancelled');
  });
  ref.onResume(() {
    debugPrint('SensorWebsocket connection resumed');
  });
  ref.onAddListener(() {
    debugPrint('SensorWebsocket listener added');
  });
  ref.onRemoveListener(() {
    debugPrint('SensorWebsocket listener removed');
  });
  return SensorWebsocket();
}, isAutoDispose: true);

class SensorWebsocket {
  final url = BaseConfigs.baseUrl;

  SensorWebsocket() {
    debugPrint('SensorWebsocket initialized with URL: $url');
  }

  Future<socket.Socket> connect() async {
    Map<String, dynamic> headers = {};
    headers['Authorization'] = 'Bearer ${await Storage().readAccessToken}';
    final channel = socket.io(
      url?.replaceAll('/api', ''),
      socket.OptionBuilder().setTransports(['websocket']).setExtraHeaders(headers).disableAutoConnect().build(),
    );
    log(url?.replaceAll('/api', '').toString() ?? 'No URL');
    channel.connect();
    return channel;
  }
}
