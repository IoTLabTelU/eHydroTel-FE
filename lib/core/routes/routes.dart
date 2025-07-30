import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hydro_iot/src/auth/presentation/screens/change_password_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/forgot_password_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/landing_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/login_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/register_screen.dart';
import 'package:hydro_iot/src/common/error_screen.dart';
import 'package:hydro_iot/src/common/home/navbar.dart';
import 'package:hydro_iot/src/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:hydro_iot/src/device_detail/presentation/screens/device_detail_screen.dart';
import 'package:hydro_iot/src/history/presentation/screens/history_screen.dart';
import 'package:hydro_iot/src/profile/presentation/screens/profile_screen.dart';

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
    GoRoute(
      path: '/${ChangePasswordScreen.path}',
      name: ChangePasswordScreen.path,
      builder: (context, state) => const ChangePasswordScreen(),
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ChangePasswordScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) => Navbar(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${DashboardScreen.path}',
              name: DashboardScreen.path,
              builder: (context, state) => const DashboardScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${DeviceDetailScreen.path}',
              name: DeviceDetailScreen.path,
              builder: (context, state) => const DeviceDetailScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/${HistoryScreen.path}', name: HistoryScreen.path, builder: (context, state) => const HistoryScreen()),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(path: '/${ProfileScreen.path}', name: ProfileScreen.path, builder: (context, state) => const ProfileScreen()),
          ],
        ),
      ],
    ),
  ],
  observers: [routeObserver],
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => ErrorScreen(errorMessage: state.error!.message),
);

/// Route observer to use with RouteAware
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
