import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:vector_graphics/vector_graphics_compat.dart';

Widget oAuthButtonWidget({
  required BuildContext context,
  required String assetName,
  required String label,
  required VoidCallback onPressed,
}) {
  return ElevatedButton.icon(
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      minimumSize: const Size(double.infinity, 50),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(40.0),
        side: const BorderSide(color: ColorValues.neutral200),
      ),
    ),
    icon: VectorGraphic(loader: AssetBytesLoader(assetName), height: 16, width: 16),
    label: Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(color: ColorValues.neutral700, fontWeight: FontWeight.bold),
      textAlign: TextAlign.center,
    ),
    onPressed: onPressed,
  );
}
