import 'package:flutter/material.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';

class DashboardHeaderWidget extends StatelessWidget {
  const DashboardHeaderWidget({super.key, required this.username});

  final String username;

  @override
  Widget build(BuildContext context) {
    final local = AppLocalizations.of(context)!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${local.welcome}, $username', style: Theme.of(context).textTheme.bodyLarge?.copyWith()),
        Text('Dashboard', style: Theme.of(context).textTheme.titleLarge?.copyWith()),
      ],
    );
  }
}
