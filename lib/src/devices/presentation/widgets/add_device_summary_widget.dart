import 'package:flutter/material.dart';
import 'package:hydro_iot/res/colors.dart';

Widget buildAddDeviceSummaryWidget({
  required BuildContext context,
  required String deviceName,
  required String deviceDescription,
  required String deviceId,
  required RangeValues phValues,
  required RangeValues ppmValues,
}) {
  return ListView(
    children: [
      Text('Device Summary', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 20),
      Table(
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(0.2), 2: FlexColumnWidth(3)},
        border: TableBorder.all(
          color: ColorValues.iotMainColor,
          width: 2,
          style: BorderStyle.solid,
          borderRadius: BorderRadius.circular(8),
        ),
        children: [
          TableRow(
            children: [
              Text('\rDevice Name', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.start),
              Text(':', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text('\r$deviceName', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),
          TableRow(
            children: [
              Text('\rDevice ID', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.start),
              Text(':', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text('\r$deviceId', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),
          TableRow(
            children: [
              Text('\rDevice Desc.', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.start),
              Text(':', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text('\r$deviceDescription', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),
        ],
      ),

      const SizedBox(height: 20),
      Divider(color: ColorValues.iotMainColor, thickness: 2),
      const SizedBox(height: 20),
      Text('Sensor Threshold Summary', style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 20),
      Table(
        columnWidths: const {0: FlexColumnWidth(2), 1: FlexColumnWidth(0.2), 2: FlexColumnWidth(3)},
        border: TableBorder.all(
          color: ColorValues.iotMainColor,
          width: 2,
          style: BorderStyle.solid,
          borderRadius: BorderRadius.circular(8),
        ),
        children: [
          TableRow(
            children: [
              Text('\rpH Sensor', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.start),
              Text(':', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              Text(
                '\r${phValues.start.toStringAsFixed(2)} - ${phValues.end.toStringAsFixed(2)}',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ],
          ),
          TableRow(
            children: [
              Text('\rPPM Sensor', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.start),
              Text(':', style: Theme.of(context).textTheme.titleMedium, textAlign: TextAlign.center),
              Text('\r${ppmValues.start.toInt()} - ${ppmValues.end.toInt()}', style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ],
      ),
    ],
  );
}
