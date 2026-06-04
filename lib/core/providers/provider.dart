import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_riverpod/legacy.dart';
import 'package:hydro_iot/core/api/api.dart';
import 'package:hydro_iot/utils/utils.dart';
import 'package:flutter/material.dart';

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref);
});

class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('en')) {
    _loadLocale();
  }

  Future<void> _loadLocale() async {
    final String? languageCode = await Storage().readLocale();
    if (languageCode != null) {
      state = Locale(languageCode);
    }
  }

  Future<void> changeLanguage(Locale newLocale) async {
    await Storage().writeLocale(newLocale.languageCode);
    state = newLocale;
  }
}

final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

// Provider untuk status koneksi
final connectivityProvider = StateNotifierProvider<ConnectivityNotifier, bool>((ref) {
  return ConnectivityNotifier();
});

class ConnectivityNotifier extends StateNotifier<bool> {
  ConnectivityNotifier() : super(true) {
    _init();
  }

  late StreamSubscription<List<ConnectivityResult>> _subscription;

  void _init() {
    // Cek status awal
    Connectivity().checkConnectivity().then(_updateState);

    // Listen perubahan koneksi
    _subscription = Connectivity().onConnectivityChanged.listen(_updateState);
  }

  void _updateState(List<ConnectivityResult> results) {
    final isConnected = results.any((r) => r != ConnectivityResult.none);
    state = isConnected;
  }

  Future<void> recheck() async {
    final results = await Connectivity().checkConnectivity();
    _updateState(results);
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
