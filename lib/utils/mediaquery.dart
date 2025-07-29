import 'package:flutter/material.dart';

double heightQuery(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double widthQuery(BuildContext context) {
  return MediaQuery.of(context).size.width;
}
