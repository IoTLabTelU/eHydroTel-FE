import 'package:flutter/material.dart';
import 'package:hydro_iot/core/components/buttons.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/res.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class PlantSessionCard extends StatelessWidget {
  final bool onDashboard;
  final bool isStopped;
  final String deviceName;
  final String plantName;
  final DateTime startDate;
  final int totalDays;
  final double minPh;
  final double maxPh;
  final double minPpm;
  final double maxPpm;
  final VoidCallback onHistoryTap;
  final VoidCallback onStopSession;
  final VoidCallback onRestartSession;
  final VoidCallback onTap;

  const PlantSessionCard({
    super.key,
    required this.deviceName,
    required this.plantName,
    required this.startDate,
    required this.totalDays,
    required this.minPh,
    required this.maxPh,
    required this.minPpm,
    required this.maxPpm,
    required this.onHistoryTap,
    required this.onStopSession,
    required this.onTap,
    required this.onDashboard,
    required this.isStopped,
    required this.onRestartSession,
  });

  int get daysElapsed => DateTime.now().difference(startDate).inDays;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    final progress = (daysElapsed / totalDays).clamp(0.0, 1.0);

    return InkWell(
      onTap: onTap,
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        elevation: 2,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plantName,
                        style: dmSansNormalText(size: 20, color: Colors.black, weight: FontWeight.bold),
                      ),
                      if (onDashboard)
                        Text('${local.device}: $deviceName', style: dmSansNormalText(size: 14, color: Colors.grey)),
                    ],
                  ),
                  // Animasi Rive
                  Expanded(
                    child: Builder(
                      builder: (context) {
                        String asset;
                        switch (progress) {
                          case >= 0.0 && < 0.2:
                            asset = LottieAssets.plantSessionSeed;
                            break;
                          case >= 0.2 && < 0.4:
                            asset = LottieAssets.plantSessionSprout;
                            break;
                          case >= 0.4 && < 0.6:
                            asset = LottieAssets.plantSessionGrowth;
                            break;
                          case >= 0.6 && <= 1.0:
                            asset = LottieAssets.plantSessionFlower;
                            break;
                          default:
                            asset = LottieAssets.plantSessionFlower;
                        }
                        return Container(
                          margin: EdgeInsets.only(left: widthQuery(context) * 0.15),
                          decoration: BoxDecoration(
                            color: ColorValues.iotMainColor.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Align(
                            alignment: Alignment.center,
                            child: Lottie.asset(asset, fit: BoxFit.cover, frameRate: FrameRate.max, repeat: true),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// Progress timeline
              LinearProgressIndicator(
                value: progress,
                backgroundColor: Colors.grey.shade200,
                color: Colors.green,
                minHeight: 10,
                borderRadius: BorderRadius.circular(10),
              ),
              const SizedBox(height: 8),
              Text(
                '${local.day} $daysElapsed ${local.oof} $totalDays',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),

              const SizedBox(height: 16),

              /// Detail Info
              _buildInfoBox('🧪 pH Threshold', '$minPh – $maxPh'),
              const SizedBox(height: 12),
              _buildInfoBox('💧 PPM Threshold', '$minPpm – $maxPpm'),
              const SizedBox(height: 12),
              _buildInfoBox('🌱 ${local.plantedAt}', DateFormat.yMMMd().format(startDate)),
              const SizedBox(height: 20),

              /// Action Buttons
              Row(
                children: [
                  Expanded(
                    child: iconTextButtonWidget(
                      context: context,
                      icon: const Icon(Icons.history, size: 20),
                      label: local.history,
                      onPressed: onHistoryTap,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: progress == 1.0
                        ? iconTextButtonWidget(
                            context: context,
                            icon: const Icon(Icons.check),
                            label: local.harvest,
                            onPressed: () {},
                            backgroundColor: Colors.green.shade200,
                            foregroundColor: Colors.green.shade800,
                          )
                        : isStopped
                        ? iconTextButtonWidget(
                            context: context,
                            icon: const Icon(Icons.play_circle, size: 20),
                            label: 'Restart',
                            onPressed: onRestartSession,
                            backgroundColor: Colors.blue.shade100,
                            foregroundColor: Colors.black54,
                          )
                        : iconTextButtonWidget(
                            context: context,
                            icon: const Icon(Icons.stop_circle, size: 20),
                            label: 'Stop',
                            onPressed: onStopSession,
                            backgroundColor: Colors.red.shade600,
                            foregroundColor: ColorValues.whiteColor,
                          ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoBox(String title, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, color: Colors.black54)),
        const SizedBox(height: 4),
        Text(
          value,
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black),
        ),
      ],
    );
  }
}
