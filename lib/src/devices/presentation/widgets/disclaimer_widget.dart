import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';

class Disclaimer extends StatelessWidget {
  const Disclaimer({super.key});
  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.info_outline, size: 18, color: ColorValues.neutral500),
        SizedBox(width: 8),
        Expanded(
          child: Text(
            'Tip: Filter tanggal di halaman History untuk menentukan periode data yang akan diexport.',
            style: TextStyle(color: ColorValues.neutral600),
          ),
        ),
      ],
    );
  }
}
