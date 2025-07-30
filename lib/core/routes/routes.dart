import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_iot/src/auth/presentation/screens/forgot_password_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/landing_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/login_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/register_screen.dart';
import 'package:hydro_iot/src/common/error_screen.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/${LandingScreen.path}',
  routes: [
    GoRoute(
      path: '/${LandingScreen.path}',
      name: LandingScreen.path,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LandingScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/${LoginScreen.path}',
      name: LoginScreen.path,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const LoginScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/${RegisterScreen.path}',
      name: RegisterScreen.path,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const RegisterScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
    GoRoute(
      path: '/${ForgotPasswordScreen.path}',
      name: ForgotPasswordScreen.path,
      builder: (context, state) => const ForgotPasswordScreen(),
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ForgotPasswordScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),
  ],
  observers: [routeObserver],
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => ErrorScreen(errorMessage: state.error!.message),
);

/// Route observer to use with RouteAware
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
