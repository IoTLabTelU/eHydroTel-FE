import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:hydro_iot/core/core.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class DevicesStatusChartWidget extends StatefulWidget {
  const DevicesStatusChartWidget({super.key});

  @override
  State<DevicesStatusChartWidget> createState() => _DevicesStatusChartWidgetState();
}

class _DevicesStatusChartWidgetState extends State<DevicesStatusChartWidget> {
  int touchedIndex = -1;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: ColorValues.iotMainColor,
      elevation: 2,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              'Monitor your devices!',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: ColorValues.whiteColor.withValues(alpha: 0.4),
              ),
            ),
            Text(
              'Device Status',
              style: Theme.of(
                context,
              ).textTheme.headlineLarge!.copyWith(fontWeight: FontWeight.w800, color: ColorValues.whiteColor),
            ),
            const SizedBox(height: 10),
            Divider(color: ColorValues.whiteColor.withValues(alpha: 0.5), thickness: 5, radius: BorderRadius.circular(20.r)),
            const SizedBox(height: 20),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: AspectRatio(
                    aspectRatio: 1.0,
                    child: PhysicalModel(
                      shape: BoxShape.circle,
                      clipBehavior: Clip.antiAlias,
                      color: ColorValues.neutral200.withValues(alpha: 0.4),
                      child: PieChart(
                        PieChartData(
                          pieTouchData: PieTouchData(
                            touchCallback: (FlTouchEvent event, pieTouchResponse) {
                              setState(() {
                                if (!event.isInterestedForInteractions ||
                                    pieTouchResponse == null ||
                                    pieTouchResponse.touchedSection == null) {
                                  touchedIndex = -1;
                                  return;
                                }
                                touchedIndex = pieTouchResponse.touchedSection!.touchedSectionIndex;
                              });
                            },
                          ),
                          borderData: FlBorderData(show: false),
                          sectionsSpace: 5,
                          centerSpaceRadius: widthQuery(context) * 0.1,
                          startDegreeOffset: 180,
                          sections: showingSections(),
                        ),
                      ),
                    ),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Indicator(
                      color: ColorValues.iotNodeMCUColor,
                      text: 'Normal',
                      isSquare: true,
                      size: 10,
                      textColor: ColorValues.neutral100,
                    ),
                    const SizedBox(height: 4),
                    const Indicator(
                      color: ColorValues.warning700,
                      text: 'Unstable',
                      isSquare: true,
                      size: 10,
                      textColor: ColorValues.neutral100,
                    ),
                    const SizedBox(height: 4),
                    const Indicator(
                      color: ColorValues.danger700,
                      text: 'Critical',
                      isSquare: true,
                      size: 10,
                      textColor: ColorValues.neutral100,
                    ),
                    const SizedBox(height: 4),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 25.0 : 16.0;
      final radius = isTouched ? 60.0 : 50.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];
      switch (i) {
        case 0:
          return PieChartSectionData(
            color: ColorValues.iotNodeMCUColor,
            value: 40,
            title: '40%',
            radius: radius,
            titleStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: ColorValues.whiteColor,
              shadows: shadows,
            ),
          );
        case 1:
          return PieChartSectionData(
            color: ColorValues.warning700,
            value: 30,
            title: '30%',
            radius: radius,
            titleStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: ColorValues.whiteColor,
              shadows: shadows,
            ),
          );
        case 2:
          return PieChartSectionData(
            color: Colors.red,
            value: 15,
            title: '15%',
            radius: radius,
            titleStyle: Theme.of(context).textTheme.bodyLarge!.copyWith(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: ColorValues.whiteColor,
              shadows: shadows,
            ),
          );

        default:
          throw Error();
      }
    });
  }
}
