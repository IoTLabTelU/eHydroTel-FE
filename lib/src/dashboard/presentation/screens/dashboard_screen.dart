import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/dashboard/presentation/widgets/devices_status_chart_widget.dart';
import 'package:hydro_iot/utils/utils.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String path = 'dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final CarouselController carouselController = CarouselController();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          Text('Welcome, Alex Marnocha', style: Theme.of(context).textTheme.bodyLarge),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dashboard', style: Theme.of(context).textTheme.titleLarge),
              IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
            ],
          ),
          const SizedBox(height: 20),
          // Add your dashboard widgets here
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Divider(color: ColorValues.neutral300, thickness: 5)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text('Analytics', style: Theme.of(context).textTheme.bodyLarge),
              ),
              Expanded(child: Divider(color: ColorValues.neutral300, thickness: 5)),
            ],
          ),
          const SizedBox(height: 20),
          DevicesStatusChartWidget(),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(child: Divider(color: ColorValues.neutral300, thickness: 5)),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 2.w),
                child: Text('Devices', style: Theme.of(context).textTheme.bodyLarge),
              ),
              Expanded(child: Divider(color: ColorValues.neutral300, thickness: 5)),
            ],
          ),
          const SizedBox(height: 20),
          searchButton(onPressed: () => context.push('/dashboard/search'), context: context, text: 'Search devices...'),
          const SizedBox(height: 20),
          Text('Abnormal Devices', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          DeviceCard(
            deviceName: 'Meja 1',
            deviceId: 'HWTX883',
            isOnline: true,
            ph: 2.2,
            ppm: 850,
            lastUpdated: DateTime.now(),
            ringChart: null,
            onTapDetail: () => context.push(
              '/devices/HWTX883',
              extra: {
                'deviceName': 'Meja 1',
                'pH': 2.2,
                'ppm': 700,
                'deviceDescription': 'This is the Description of Meja 1',
              },
            ),
            onTapSetting: () => context.push(
              '/devices/HWTX883/settings',
              extra: {
                'deviceName': 'Meja 1',
                'initialMinPh': 2.2,
                'initialMaxPh': 7.0,
                'initialMinPPM': 850.0,
                'initialMaxPPM': 1000.0,
              },
            ),
            onTapHistory: () => context.push(
              '/devices/HWTX883/history',
              extra: {
                'deviceName': 'Meja 1',
                'pH': 2.2,
                'ppm': 700,
                'deviceDescription': 'This is the Description of Meja 1',
              },
            ),
          ),

          SizedBox(height: heightQuery(context) * 0.3),
        ],
      ),
    );
  }
}
