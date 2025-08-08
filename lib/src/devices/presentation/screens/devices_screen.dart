import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/src/devices/presentation/widgets/crud_device_list.dart';
import 'package:hydro_iot/utils/utils.dart';

class DevicesScreen extends StatefulWidget {
  const DevicesScreen({super.key});

  static const String path = 'devices';

  @override
  State<DevicesScreen> createState() => _DevicesScreenState();
}

class _DevicesScreenState extends State<DevicesScreen> {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      children: [
        Text('Devices Operation', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 20),
        SizedBox(
          height: heightQuery(context) * 0.8,
          child: GridView.custom(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 1,
              crossAxisSpacing: 8.w,
              mainAxisSpacing: 8.h,
            ),
            childrenDelegate: SliverChildBuilderDelegate((context, index) {
              final operation = crudOperationList[index];
              return InkWell(
                borderRadius: BorderRadius.circular(12.r),
                splashColor: operation['color'].withValues(alpha: 0.2) as Color,
                onTap: () {
                  Future.delayed(Duration(milliseconds: 650), () {
                    if (context.mounted) {
                      context.push(operation['route'] as String);
                    }
                  });
                },
                child: Card(
                  color: operation['color'] as Color,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(operation['icon'] as IconData, size: 10.sp, color: ColorValues.whiteColor),
                        const SizedBox(height: 8),
                        Text(
                          operation['title'] as String,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: ColorValues.whiteColor,
                            fontSize: 8.sp,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }, childCount: 4),
          ),
        ),
      ],
    );
  }
}
