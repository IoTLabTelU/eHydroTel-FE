import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';

List<Map<String, dynamic>> crudOperationList = [
  {'title': 'Add New Device', 'icon': Icons.add_circle_outline, 'color': ColorValues.iotMainColor, 'route': '/devices/create'},
  {'title': 'View All Devices', 'icon': Icons.visibility, 'color': ColorValues.success600, 'route': '/devices/view'},
  {'title': 'Update Device', 'icon': Icons.edit, 'color': ColorValues.warning500, 'route': '/devices/update'},
  {'title': 'Delete Device', 'icon': Icons.delete, 'color': ColorValues.danger600, 'route': '/devices/delete'},
];
