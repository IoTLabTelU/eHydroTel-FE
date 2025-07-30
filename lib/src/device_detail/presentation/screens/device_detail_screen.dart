import 'package:flutter/material.dart';

class DeviceDetailScreen extends StatefulWidget {
  const DeviceDetailScreen({super.key});

  static const String path = 'device_detail';

  @override
  State<DeviceDetailScreen> createState() => _DeviceDetailScreenState();
}

class _DeviceDetailScreenState extends State<DeviceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('This is Device Detail Page'));
  }
}
