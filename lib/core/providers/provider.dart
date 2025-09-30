import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hydro_iot/core/api/api.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:flutter/material.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final String? languageCode = await Storage.readLocale();
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  Future<void> changeLanguage(Locale newLocale) async {
    await Storage.writeLocale(newLocale.languageCode);
    state = newLocale;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});
