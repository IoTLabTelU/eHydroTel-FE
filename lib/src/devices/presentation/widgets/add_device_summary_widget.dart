import 'package:flutter/material.dart';
import 'package:hydro_iot/res/colors.dart';

Widget buildAddDeviceSummaryWidget({
  required BuildContext context,
  required String deviceName,
  required String deviceDescription,
  required String serialNumber,
}) {
  return ListView(
    children: [
      Text('Device Summary', style: Theme.of(context).textTheme.titleLarge?.copyWith(color: ColorValues.iotMainColor)),
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
              Text(
                '\rDevice Name',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.start,
              ),
              Text(
                ':',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text('\r$deviceName\r', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),
          TableRow(
            children: [
              Text(
                '\rSerial Number',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.start,
              ),
              Text(
                ':',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text('\r$serialNumber\r', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),
          TableRow(
            children: [
              Text(
                '\rDevice Desc.',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.start,
              ),
              Text(
                ':',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(color: ColorValues.iotMainColor),
                textAlign: TextAlign.center,
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Text('\r$deviceDescription\r', style: Theme.of(context).textTheme.bodyLarge),
              ),
            ],
          ),
        ],
      ),

      const SizedBox(height: 20),
    ],
  );
}
