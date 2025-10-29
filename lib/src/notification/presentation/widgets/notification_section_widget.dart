import '../../../../pkg.dart';

class NotificationSection extends StatelessWidget {
  final String title;
  final List<Widget> notifications;

  const NotificationSection({super.key, required this.title, required this.notifications});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleMedium!.copyWith(fontWeight: FontWeight.w600, color: Colors.grey[800]),
            ),
          ),
          const SizedBox(height: 6),
          ...notifications,
        ],
      ),
    );
  }
}
