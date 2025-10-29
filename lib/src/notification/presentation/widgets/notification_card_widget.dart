import '../../../../pkg.dart';

class NotificationCardWidget extends StatelessWidget {
  const NotificationCardWidget({super.key, required this.title, required this.body, required this.time});

  final String title;
  final String body;
  final String time;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorValues.whiteColor,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: ColorValues.neutral100, width: 1),
      ),
      margin: EdgeInsets.only(bottom: 5.h),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 12.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title,
                  style: Theme.of(
                    context,
                  ).textTheme.titleMedium?.copyWith(color: ColorValues.green600, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                Text(
                  time,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: ColorValues.neutral500, fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              body,
              style: Theme.of(
                context,
              ).textTheme.labelSmall?.copyWith(color: ColorValues.blackColor, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
