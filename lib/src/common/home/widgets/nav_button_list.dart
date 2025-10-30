import 'package:flutter/widgets.dart';
import 'package:hydro_iot/l10n/app_localizations.dart';
import 'package:hydro_iot/res/nav_icons.dart';

List<Map<String, dynamic>> navButtonList(BuildContext context) {
  final local = AppLocalizations.of(context)!;
  return [
    {'icon': NavIcons.plant, 'text': local.home},
    {'icon': NavIcons.device, 'text': local.devices},
    {'icon': NavIcons.notification2, 'text': local.activity},
    {'icon': NavIcons.profile, 'text': local.account},
  ];
}
