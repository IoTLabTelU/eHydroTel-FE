import 'package:flutter/material.dart';

class DashboardHeaderWidget extends StatelessWidget {
  const DashboardHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Welcome, Alex Marnocha', style: Theme.of(context).textTheme.bodyLarge),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Dashboard', style: Theme.of(context).textTheme.titleLarge),
            IconButton(onPressed: () {}, icon: const Icon(Icons.settings)),
          ],
        ),
      ],
    );
  }
}
