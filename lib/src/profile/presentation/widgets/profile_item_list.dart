import '../../../../pkg.dart';

List<Map<String, dynamic>> settingsItemList(BuildContext context) {
  final local = AppLocalizations.of(context)!;
  return [
    {'icon': IconAssets.history, 'title': local.cropCycleHistory, 'iconColor': hexColorize('#58A45C')},
    {'icon': IconAssets.password, 'title': local.changePassword, 'iconColor': hexColorize('#A2C76B')},
    {'icon': IconAssets.language, 'title': local.switchLanguage, 'iconColor': hexColorize('#75AB00')},
  ];
}

List<Map<String, dynamic>> legalItemList(BuildContext context) {
  final local = AppLocalizations.of(context)!;
  return [
    {'icon': IconAssets.privacy, 'title': local.privacyPolicy, 'iconColor': ColorValues.neutral500},
    {'icon': IconAssets.terms, 'title': local.termsOfService, 'iconColor': ColorValues.neutral500},
  ];
}
