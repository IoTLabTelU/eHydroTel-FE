import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/animated_refresh_button_widget.dart';

class HistoryToolbar extends StatelessWidget {
  final String rangeText;
  final VoidCallback onPickRange;
  final Future<void> Function() onRefresh;
  final bool loading;

  const HistoryToolbar({
    super.key,
    required this.rangeText,
    required this.onPickRange,
    required this.onRefresh,
    required this.loading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: ColorValues.whiteColor,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
      ),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onPickRange,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: ColorValues.neutral300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.date_range, size: 18),
                    const SizedBox(width: 8),
                    Text(rangeText, style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          AnimatedRefreshButton(onRefresh: onRefresh, loading: loading),
        ],
      ),
    );
  }
}
