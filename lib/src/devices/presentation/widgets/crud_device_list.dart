import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';

List<Map<String, dynamic>> crudOperationList = [
  {'title': 'Add New Device', 'icon': Icons.add_box_rounded, 'color': ColorValues.iotMainColor, 'route': '/devices/create'},
  {
    'title': 'View All Devices',
    'icon': Icons.view_carousel_rounded,
    'color': ColorValues.success600,
    'route': '/devices/view',
  },
  {'title': 'Delete All Device', 'icon': Icons.delete_sweep, 'color': ColorValues.danger600, 'route': '/devices/delete'},
];
