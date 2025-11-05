import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hydro_iot/core/config/config.dart';
import 'package:hydro_iot/utils/storage.dart';
import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

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

  Future<WebSocketChannel> connect() async {
    final uri = Uri.parse(url!.replaceFirst('https', 'ws'));
    Map<String, dynamic> headers = {};
    headers['Authorization'] = 'Bearer ${await Storage().readAccessToken}';
    final channel = IOWebSocketChannel.connect(uri, headers: headers);
    return channel;
  }
}
