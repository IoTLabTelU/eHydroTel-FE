import 'package:flutter/material.dart';
import 'package:hydro_iot/src/auth/presentation/screens/change_password_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/forgot_password_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/landing_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/login_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/register_screen.dart';
import 'package:hydro_iot/src/common/error_screen.dart';
import 'package:hydro_iot/src/common/home/navbar.dart';
import 'package:hydro_iot/src/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:hydro_iot/src/dashboard/presentation/screens/search_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/add_device/add_device_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/detail_device_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/devices_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/history/sensor_history_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/setting_device_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/view_all_session_screen.dart';
import 'package:hydro_iot/src/notification/presentation/screens/notification_screen.dart';
import 'package:hydro_iot/src/profile/presentation/screens/profile_screen.dart';
import 'package:hydro_iot/utils/utils.dart';

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
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const ChangePasswordScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    ),

    StatefulShellRoute.indexedStack(
      pageBuilder: (context, state, navigationShell) => CustomTransitionPage(
        key: state.pageKey,
        child: Navbar(navigationShell: navigationShell),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${DashboardScreen.path}',
              name: DashboardScreen.path,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const DashboardScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
              routes: [
                GoRoute(
                  path: '/${SearchScreen.path}',
                  name: SearchScreen.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: const SearchScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${DevicesScreen.path}',
              name: DevicesScreen.path,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const DevicesScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
              routes: [
                GoRoute(
                  path: '/${AddDeviceScreen.path}',
                  name: AddDeviceScreen.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: const AddDeviceScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                ),

                GoRoute(
                  path: '/:deviceId',
                  name: 'deviceDetail',
                  pageBuilder: (context, state) {
                    final deviceId = state.pathParameters['deviceId']!;
                    final extra = state.extra as Map<String, dynamic>;
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: DetailDeviceScreen(
                        deviceId: deviceId,
                        deviceName: extra['deviceName'] as String,
                        pH: extra['pH'] as double,
                        ppm: extra['ppm'] as int,
                        deviceDescription: extra['deviceDescription'] as String?,
                      ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    );
                  },
                  routes: [
                    GoRoute(
                      path: '/${SettingDeviceScreen.path}',
                      name: SettingDeviceScreen.path,
                      pageBuilder: (context, state) {
                        final deviceId = state.pathParameters['deviceId']!;
                        final extra = state.extra as Map<String, dynamic>;
                        return CustomTransitionPage(
                          key: state.pageKey,
                          child: SettingDeviceScreen(
                            deviceId: deviceId,
                            deviceName: extra['deviceName'] as String,
                            deviceDescription: extra['deviceDescription'] as String,
                            ssid: extra['ssid'] as String,
                          ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        );
                      },
                    ),
                    GoRoute(
                      path: '/${ViewAllPlantSessionScreen.path}',
                      name: ViewAllPlantSessionScreen.path,
                      pageBuilder: (context, state) {
                        final deviceId = state.pathParameters['deviceId']!;
                        final extra = state.extra as Map<String, dynamic>;
                        return CustomTransitionPage(
                          key: state.pageKey,
                          child: ViewAllPlantSessionScreen(
                            deviceName: extra['deviceName'] as String,
                            serialNumber: deviceId,
                          ),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        );
                      },
                    ),
                    GoRoute(
                      path: '/${SensorHistoryScreen.path}',
                      name: SensorHistoryScreen.path,
                      pageBuilder: (context, state) {
                        final deviceId = state.pathParameters['deviceId']!;
                        final extra = state.extra as Map<String, dynamic>;
                        return CustomTransitionPage(
                          key: state.pageKey,
                          child: SensorHistoryScreen(deviceId: deviceId, deviceName: extra['deviceName'] as String),
                          transitionsBuilder: (context, animation, secondaryAnimation, child) {
                            return FadeTransition(opacity: animation, child: child);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${NotificationCenterScreen.path}',
              name: NotificationCenterScreen.path,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const NotificationCenterScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/${ProfileScreen.path}',
              name: ProfileScreen.path,
              pageBuilder: (context, state) => CustomTransitionPage(
                key: state.pageKey,
                child: const ProfileScreen(),
                transitionsBuilder: (context, animation, secondaryAnimation, child) {
                  return FadeTransition(opacity: animation, child: child);
                },
              ),
            ),
          ],
        ),
      ],
    ),
  ],
  observers: [routeObserver],
  debugLogDiagnostics: true,
  errorBuilder: (context, state) => ErrorScreen(errorMessage: state.error!.message),
  redirect: (context, state) async {
    final isLoggedIn = await Storage.readIsLoggedIn();
    final role = await Storage.readRole();
    if (isLoggedIn == null) {
      return '/${LandingScreen.path}';
    }
    if (!isLoggedIn) {
      return '/${LoginScreen.path}';
    }

    if (role != 'CUSTOMER') {
      if (context.mounted) Toast().showErrorToast(context: context, title: 'Error', description: 'Account not supported');
      return '/${LoginScreen.path}';
    }

    final loggingIn = state.matchedLocation == '/${LoginScreen.path}';
    final landing = state.matchedLocation == '/${LandingScreen.path}';

    if ((loggingIn || landing) && isLoggedIn) {
      return '/${DashboardScreen.path}';
    }
    return null;
  },
);

/// Route observer to use with RouteAware
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
