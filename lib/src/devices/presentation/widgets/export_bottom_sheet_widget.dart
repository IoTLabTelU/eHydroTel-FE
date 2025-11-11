import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/disclaimer_widget.dart';

class ExportBottomSheet extends StatelessWidget {
  final VoidCallback onExportCsv;
  final VoidCallback onExportXlsx;
  const ExportBottomSheet({super.key, required this.onExportCsv, required this.onExportXlsx});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 70),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 12),
              decoration: BoxDecoration(color: ColorValues.neutral300, borderRadius: BorderRadius.circular(4)),
            ),
          ),
          const Text('Export Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text(
            'Choose format and we\'ll generate an export file for this crop cycle.',
            style: TextStyle(color: ColorValues.neutral600),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _ExportTile(
                  icon: Icons.table_chart,
                  title: 'Excel (.xlsx)',
                  onTap: onExportXlsx,
                  color: ColorValues.iotNodeMCUColor,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _ExportTile(
                  icon: Icons.grid_on,
                  title: 'CSV (.csv)',
                  onTap: onExportCsv,
                  color: ColorValues.iotArduinoColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Disclaimer(),
        ],
      ),
    );
  }
}

class _ExportTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final Color color;
  const _ExportTile({required this.icon, required this.title, required this.onTap, required this.color});
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Ink(
        height: 90,
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 10),
            Text(
              title,
              style: TextStyle(color: color, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
