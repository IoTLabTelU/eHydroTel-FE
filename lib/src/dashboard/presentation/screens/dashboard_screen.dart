import 'package:flutter/material.dart';
import 'package:hydro_iot/core/components/dialogs.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/dashboard/presentation/widgets/dashboard_header_widget.dart';
import 'package:hydro_iot/src/dashboard/presentation/widgets/session_modal.dart';
// import 'package:hydro_iot/src/dashboard/presentation/widgets/devices_status_chart_widget.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:multi_dropdown/multi_dropdown.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  static const String path = 'dashboard';

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  var items = [
    DropdownItem(label: 'All', value: 'All'),
    DropdownItem(label: 'Active Only', value: 'Active'),
    DropdownItem(label: 'Inactive Only', value: 'Inactive'),
  ];
  final controller = MultiSelectController<String>();
  bool isStopped = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w),
      child: ListView(
        children: [
          const SizedBox(height: 20),
          const DashboardHeaderWidget(),
          // const SizedBox(height: 20),
          // Add your dashboard widgets here
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Expanded(child: Divider(color: ColorValues.neutral300, thickness: 5)),
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 2.w),
          //       child: Text('Analytics', style: Theme.of(context).textTheme.bodyLarge),
          //     ),
          //     const Expanded(child: Divider(color: ColorValues.neutral300, thickness: 5)),
          //   ],
          // ),
          // const SizedBox(height: 20),
          // const DevicesStatusChartWidget(),
          // const SizedBox(height: 20),
          // Row(
          //   mainAxisAlignment: MainAxisAlignment.center,
          //   children: [
          //     const Expanded(child: Divider(color: ColorValues.neutral300, thickness: 5)),
          //     Padding(
          //       padding: EdgeInsets.symmetric(horizontal: 2.w),
          //       child: Text('Plant Session', style: Theme.of(context).textTheme.bodyLarge),
          //     ),
          //     const Expanded(child: Divider(color: ColorValues.neutral300, thickness: 5)),
          //   ],
          // ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: searchButton(
                  onPressed: () => context.push('/dashboard/search'),
                  context: context,
                  text: 'Find Sessions...',
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                flex: 1,
                child: MultiDropdown<String>(
                  items: items,
                  controller: controller,
                  enabled: true,
                  singleSelect: true,
                  fieldDecoration: FieldDecoration(
                    hintText: 'Filter',
                    hintStyle: dmSansSmallText(
                      size: 12,
                      color: ColorValues.neutral700,
                    ),
                    showClearIcon: false,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: ColorValues.iotMainColor),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(
                        color: ColorValues.iotMainColor,
                        width: 3,
                      ),
                    ),
                  ),
                  dropdownDecoration: const DropdownDecoration(
                    marginTop: 2,
                    maxHeight: 500,
                  ),
                  dropdownItemDecoration: DropdownItemDecoration(
                    selectedIcon: const Icon(
                      Icons.check_box,
                      color: Colors.green,
                    ),
                    disabledIcon: Icon(Icons.lock, color: Colors.grey.shade300),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Plant Sessions',
                style: Theme.of(context).textTheme.titleLarge,
              ),
              ElevatedButton.icon(
                onPressed: () {
                  showModalBottomSheet(
                    useRootNavigator: true,
                    context: context,
                    builder: (context) => const SessionModal(),
                  );
                },
                label: const Text('Add Session'),
                icon: const Icon(Icons.add),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorValues.iotMainColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          PlantSessionCard(
            onDashboard: true,
            deviceName: 'Meja 1',
            plantName: 'Broccoli',
            startDate: DateTime.utc(2025, 8, 30),
            totalDays: 30,
            minPh: 5.5,
            maxPh: 7.0,
            minPpm: 800,
            maxPpm: 1200,
            onHistoryTap: () => context.push(
              '/devices/HWTX883/history',
              extra: {
                'deviceName': 'Meja 1',
                'pH': 5.7,
                'ppm': 800,
                'deviceDescription': 'This is the Description of Meja 1',
              },
            ),
            onStopSession: () {
              showAdaptiveDialog(
                barrierDismissible: true,
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
              '/devices/HWTX883',
              extra: {
                'deviceName': 'Meja 1',
                'pH': 5.7,
                'ppm': 800,
                'deviceDescription': 'This is the Description of Meja 1',
              },
            ),
            isStopped: isStopped,
            onRestartSession: () {
              setState(() {
                isStopped = false;
              });
            },
          ),

          SizedBox(height: heightQuery(context) * 0.3),
        ],
      ),
    );
  }
}
