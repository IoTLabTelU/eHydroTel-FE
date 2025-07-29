import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_iot/src/auth/landing/presentation/screens/landing_screen.dart';
import 'package:hydro_iot/src/common/error_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/${LandingScreen.path}',
  routes: [
    GoRoute(
      path: '/${LandingScreen.path}',
      name: LandingScreen.path,
      builder: (context, state) => const LandingScreen(),
    ),
  ],
  observers: [routeObserver],
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => ErrorScreen(errorMessage: state.error!.message),
);

/// Route observer to use with RouteAware
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
