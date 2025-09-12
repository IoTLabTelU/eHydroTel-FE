import 'package:flutter/material.dart';
import 'package:hydro_iot/core/components/components.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class ViewAllPlantSessionScreen extends StatefulWidget {
  final String deviceName;
  final String serialNumber;

  const ViewAllPlantSessionScreen({super.key, required this.deviceName, required this.serialNumber});

  static const String path = 'view';

  @override
  State<ViewAllPlantSessionScreen> createState() => _ViewAllPlantSessionScreenState();
}

class _ViewAllPlantSessionScreenState extends State<ViewAllPlantSessionScreen> {
  bool isStopped = false;
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      children: [
        searchButton(onPressed: () => context.push('/dashboard/search'), context: context, text: 'Search sessions...'),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('All Sessions', style: Theme.of(context).textTheme.headlineSmall),
            ElevatedButton.icon(
              onPressed: () {},
              label: const Text('Add Session'),
              icon: const Icon(Icons.add),
              style: ElevatedButton.styleFrom(
                backgroundColor: ColorValues.iotMainColor,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text('on ${widget.deviceName}', style: dmSansHeadText(color: ColorValues.neutral600)),
        // Add your device list or other widgets here
        const SizedBox(height: 10),
        ...List.generate(2, (index) {
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 8.h),
            child: PlantSessionCard(
              deviceName: 'Meja ${index + 1}',
              onDashboard: false,
              plantName: 'Lettuce',
              startDate: DateTime.utc(2025, 9, 2),
              totalDays: 20,
              minPh: 5.6,
              maxPh: 6.6,
              minPpm: 500,
              maxPpm: 750,
              onHistoryTap: () => context.push(
                '/devices/HWTX88${index + 1}/history',
                extra: {
                  'deviceName': 'Meja ${index + 1}',
                  'pH': 10.0,
                  'ppm': 850,
                  'deviceDescription': 'This is the Description of Meja ${index + 1}',
                },
              ),
              onStopSession: () {
                showAdaptiveDialog(
                  context: context,
                  builder: (context) {
                    return alertDialog(
                      context: context,
                      title: 'Stop Session',
                      content: 'Are you sure you want to stop this session?',
                      onConfirm: () => setState(() {
                        isStopped = true;
                      }),
                    );
                  },
                );
              },
              onTap: () => context.push(
                '/devices/HWTX88${index + 1}',
                extra: {
                  'deviceName': 'Meja ${index + 1}',
                  'pH': 10.0,
                  'ppm': 850,
                  'deviceDescription': 'This is the Description of Meja ${index + 1}',
                },
              ),
              isStopped: isStopped,
              onRestartSession: () {
                setState(() {
                  isStopped = false;
                });
              },
            ),
          );
        }),
      ],
    );
  }
}
