import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
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
          DevicesStatusChartWidget(),
          const SizedBox(height: 20),
          Text('All Devices', style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 10),
          searchButton(onPressed: () {}, context: context, text: 'Search devices...'),
          const SizedBox(height: 10),
          DeviceCard(
            deviceName: 'Meja 1',
            deviceId: 'HWTX883',
            isOnline: true,
            ph: 6.5,
            ppm: 850,
            lastUpdated: DateTime.now(),
            ringChart: null,
            onTapDetail: () => context.push('/device/HWTX883'),
            onTapSetting: () => context.push('/device/HWTX883/settings'),
          ),

          SizedBox(height: heightQuery(context) * 0.3),
        ],
      ),
    );
  }
}
