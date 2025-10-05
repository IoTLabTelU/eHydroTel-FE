import 'package:flutter/material.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/colors.dart';

Widget buildAddDeviceSummaryWidget({
  required BuildContext context,
  required String deviceName,
  required String deviceDescription,
  required String serialNumber,
}) {
  final local = AppLocalizations.of(context)!;
  return ListView(
    children: [
      Text(local.deviceSummary, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: ColorValues.iotMainColor)),
      const SizedBox(height: 20),
      // REPLACED: Table -> Card + Column
      Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: ColorValues.iotMainColor, width: 2),
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 0,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Column(
            children: [
              _InfoRow(label: local.deviceName, value: deviceName, multiline: true),
              const Divider(height: 12),
              _InfoRow(label: local.serialNumber, value: serialNumber, multiline: true),
              const Divider(height: 12),
              _InfoRow(label: local.deviceDescription, value: deviceDescription, multiline: true),
            ],
          ),
        ),
      ),
      const SizedBox(height: 20),
    ],
  );
}

// New helper widget replacing table rows.
class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  final bool multiline;
  const _InfoRow({required this.label, required this.value, this.multiline = false});

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(
      context,
    ).textTheme.titleMedium?.copyWith(color: ColorValues.iotMainColor, fontWeight: FontWeight.w600);
    final valueStyle = Theme.of(context).textTheme.bodyLarge;
    final content = multiline
        ? Text(value, style: valueStyle, softWrap: true)
        : SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Text(value, style: valueStyle),
          );

    return Semantics(
      label: label,
      value: value,
      child: Row(
        crossAxisAlignment: multiline ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        children: [
          // Label
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 110, maxWidth: 160),
            child: Text(label, style: labelStyle),
          ),
          const SizedBox(width: 8),
          Text(':', style: labelStyle),
          const SizedBox(width: 8),
          // Value
          Expanded(child: content),
        ],
      ),
    );
  }
}
