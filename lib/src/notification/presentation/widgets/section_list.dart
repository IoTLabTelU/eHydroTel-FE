import 'package:hydro_iot/pkg.dart';

List<Map<String, dynamic>> notificationSections(BuildContext context) {
  final local = AppLocalizations.of(context)!;
  return [
    {
      'title': local.today,
      'start': DateTime.now().subtract(
        Duration(
          hours: DateTime.now().hour,
          minutes: DateTime.now().minute,
          seconds: DateTime.now().second,
          milliseconds: DateTime.now().millisecond,
          microseconds: DateTime.now().microsecond,
        ),
      ),
      'end': DateTime.now(),
    },
    {
      'title': local.yesterday,
      'start': DateTime.now().subtract(
        Duration(
          days: 1,
          hours: DateTime.now().hour,
          minutes: DateTime.now().minute,
          seconds: DateTime.now().second,
          milliseconds: DateTime.now().millisecond,
          microseconds: DateTime.now().microsecond,
        ),
      ),
      'end': DateTime.now().subtract(
        Duration(
          hours: DateTime.now().hour,
          minutes: DateTime.now().minute,
          seconds: DateTime.now().second,
          milliseconds: DateTime.now().millisecond,
          microseconds: DateTime.now().microsecond,
        ),
      ),
    },
    {
      'title': local.thisWeek,
      'start': DateTime.now().subtract(
        Duration(
          days: DateTime.now().weekday - 1,
          hours: DateTime.now().hour,
          minutes: DateTime.now().minute,
          seconds: DateTime.now().second,
          milliseconds: DateTime.now().millisecond,
          microseconds: DateTime.now().microsecond,
        ),
      ),
      'end': DateTime.now().subtract(
        Duration(
          hours: DateTime.now().hour,
          minutes: DateTime.now().minute,
          seconds: DateTime.now().second,
          milliseconds: DateTime.now().millisecond,
          microseconds: DateTime.now().microsecond,
        ),
      ),
    },
    {
      'title': local.lastMonth,
      'start': DateTime(DateTime.now().year, DateTime.now().month - 1, 1),
      'end': DateTime.now().subtract(
        Duration(
          days: DateTime.now().day - 1,
          hours: DateTime.now().hour,
          minutes: DateTime.now().minute,
          seconds: DateTime.now().second,
          milliseconds: DateTime.now().millisecond,
          microseconds: DateTime.now().microsecond,
        ),
      ),
    },
    {
      'title': local.older,
      'start': DateTime(2000),
      'end': DateTime.now().subtract(
        Duration(
          days: DateTime.now().day - 1,
          hours: DateTime.now().hour,
          minutes: DateTime.now().minute,
          seconds: DateTime.now().second,
          milliseconds: DateTime.now().millisecond,
          microseconds: DateTime.now().microsecond,
        ),
      ),
    },
  ];
}
