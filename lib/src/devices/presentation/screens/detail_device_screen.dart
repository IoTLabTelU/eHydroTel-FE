import 'dart:math';

import 'package:flutter/material.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';

class DetailDeviceScreen extends StatefulWidget {
  const DetailDeviceScreen({
    super.key,
    required this.deviceId,
    required this.deviceName,
    required this.pH,
    required this.ppm,
    this.deviceDescription,
  });

  final String deviceId;
  final String deviceName;
  final double pH;
  final int ppm;
  final String? deviceDescription;

  @override
  State<DetailDeviceScreen> createState() => _DetailDeviceScreenState();
}

class _DetailDeviceScreenState extends State<DetailDeviceScreen> with SingleTickerProviderStateMixin {
  String get deviceId => widget.deviceId;
  String get deviceName => widget.deviceName;
  double get ph => widget.pH;
  int get ppm => widget.ppm;
  String? get deviceDescription => widget.deviceDescription;

  late AnimationController _controller;

  int random = Random().nextInt(5);

  bool isOn = true;

  double maxPh = 14.0;
  double maxPPM = 2000.0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 3))
      ..addListener(() {
        setState(() {});
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<Color> _getStatusColorForPh() {
    if (!isOn) return [ColorValues.neutral700, ColorValues.neutral500];
    if (ph < 5.5 || ph > 7.5) return [ColorValues.danger700, ColorValues.danger500];
    if ((ph >= 5.5 && ph < 6) || (ph > 7 && ph <= 7.5)) return [ColorValues.warning700, ColorValues.warning500];
    return [ColorValues.success700, ColorValues.success500];
  }

  List<Color> _getStatusColorForPPM() {
    if (!isOn) return [ColorValues.neutral700, ColorValues.neutral500];
    if (ppm < 700 || ppm > 1200) return [ColorValues.danger700, ColorValues.danger500];
    if (ppm >= 700 && ppm < 800) return [ColorValues.warning700, ColorValues.warning500];
    return [ColorValues.success700, ColorValues.success500];
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverAppBar.medium(
          backgroundColor: ColorValues.neutral200,
          automaticallyImplyLeading: false,
          expandedHeight: heightQuery(context) * 0.3,
          floating: true,
          snap: true,
          centerTitle: true,
          title: Text(
            deviceName,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
            textAlign: TextAlign.center,
          ),
          flexibleSpace: FlexibleSpaceBar(
            background: Center(
              child: Text.rich(
                TextSpan(
                  text: '$deviceName\n',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
                  children: [
                    TextSpan(
                      text: 'Device ID: $deviceId',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800, fontSize: 20),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16.h),
                _buildPowerButton(() {
                  setState(() {
                    if (isOn) {
                      _controller.reverse();
                    } else {
                      _controller.forward();
                    }
                    isOn = !isOn;
                  });
                }, isOn),

                SizedBox(height: 50.h),
                Row(
                  children: [
                    Expanded(child: Divider(color: ColorValues.blackColor, thickness: 3)),
                    SizedBox(width: 5.w),
                    Text('Details', style: Theme.of(context).textTheme.bodyLarge),
                    SizedBox(width: 5.w),
                    Expanded(child: Divider(color: ColorValues.blackColor, thickness: 3)),
                  ],
                ),
                SizedBox(height: 50.h),
                _buildSensorInfo(),
                SizedBox(height: 16.h),
                _buildStatusCard(),
                SizedBox(height: 16.h),
                _buildDescriptionCard(),
                SizedBox(height: 16.h),
                _buildActionButtons(context),
                SizedBox(height: 16.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPowerButton(VoidCallback onPressed, bool isOn) {
    return GestureDetector(
      onTap: onPressed,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: widthQuery(context) * 0.353),
        child: PhysicalModel(
          color: Colors.transparent,
          elevation: isOn ? 5 : 0,
          borderRadius: BorderRadius.circular(48.r),
          child: AnimatedContainer(
            height: 50.h,
            duration: const Duration(milliseconds: 100),
            decoration: BoxDecoration(
              color: isOn ? ColorValues.iotMainColor : ColorValues.neutral500,
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.power_settings_new, color: isOn ? ColorValues.whiteColor : ColorValues.neutral100, size: 30.r),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.online_prediction_outlined, color: Colors.black54, size: 65),
          const SizedBox(height: 8),
          Text(
            isOn ? 'Online' : 'Offline',
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(color: Colors.black54, fontWeight: FontWeight.w800, fontSize: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [BoxShadow(color: Colors.grey.withValues(alpha: 0.3), blurRadius: 10, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Icon(Icons.cable_outlined, color: Colors.black54, size: 65),
          const SizedBox(height: 8),
          Text(
            deviceDescription!,
            style: const TextStyle(fontSize: 18, color: Colors.black54),
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSensorInfo() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildSensorCard(
          painterColors: _getStatusColorForPh(),
          icon: Icons.opacity,
          label: 'pH',
          value: ph,
          color: Colors.blueAccent,
          maxValue: maxPh,
        ),
        SizedBox(height: heightQuery(context) * 0.05),
        _buildSensorCard(
          painterColors: _getStatusColorForPPM(),
          icon: Icons.bubble_chart,
          label: 'PPM',
          value: ppm.toDouble(),
          color: Colors.deepPurpleAccent,
          maxValue: maxPPM,
        ),
      ],
    );
  }

  Widget _buildSensorCard({
    List<Color>? painterColors,
    required IconData icon,
    required String label,
    required double value,
    required Color color,
    required double maxValue,
  }) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return SizedBox(
          width: widthQuery(context) * 0.7,
          height: heightQuery(context) * 0.4,
          child: Stack(
            alignment: AlignmentDirectional.center,
            fit: StackFit.expand,
            clipBehavior: Clip.antiAlias,
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: RadialProgressPainter(
                    value: _controller.value * value,
                    minValue: 0,
                    maxValue: maxValue,
                    backgroundGradientColors: painterColors!,
                  ),
                ),
              ),
              Positioned(
                top: heightQuery(context) * 0.05,
                child: SizedBox(
                  height: heightQuery(context) * 0.33,
                  child: Column(
                    children: [
                      Icon(icon, color: color, size: 100),
                      const SizedBox(height: 10),
                      Text(
                        value.toStringAsFixed(2),
                        style: Theme.of(context).textTheme.displaySmall?.copyWith(color: color, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        label,
                        style: Theme.of(
                          context,
                        ).textTheme.headlineMedium?.copyWith(color: Colors.black26, fontWeight: FontWeight.w200),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.orangeAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {},
          icon: Icon(Icons.refresh, color: ColorValues.whiteColor),
          label: Text('Refresh', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.whiteColor)),
        ),
        ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          onPressed: () {},
          icon: Icon(Icons.delete, color: ColorValues.whiteColor),
          label: Text('Delete', style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: ColorValues.whiteColor)),
        ),
      ],
    );
  }
}
