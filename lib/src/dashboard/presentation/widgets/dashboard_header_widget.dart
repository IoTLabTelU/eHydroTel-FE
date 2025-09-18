import 'package:flutter/material.dart';

class DashboardHeaderWidget extends StatelessWidget {
  const DashboardHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome, Telyu Sigma', style: Theme.of(context).textTheme.bodyLarge?.copyWith()),
        Text('Dashboard', style: Theme.of(context).textTheme.titleLarge?.copyWith()),
      ],
    );
  }
}
