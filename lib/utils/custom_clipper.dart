import 'package:flutter/material.dart';
import 'package:hydro_iot/utils/utils.dart';

class MyCustomClipper extends CustomClipper<Path> {
  final BuildContext context;
  MyCustomClipper(this.context);
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(widthQuery(context) / 100 * 3, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);
    path.lineTo(size.width - widthQuery(context) / 100 * 3, 0);

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}
