import 'package:flutter/material.dart';
import 'package:hydro_iot/src/auth/presentation/screens/auth_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/change_password_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/forgot_password_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/landing_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/login_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/otp_password_screen.dart';
import 'package:hydro_iot/src/auth/presentation/screens/register_screen.dart';
import 'package:hydro_iot/src/common/error_screen.dart';
import 'package:hydro_iot/src/common/home/navbar.dart';
import 'package:hydro_iot/src/dashboard/presentation/screens/dashboard_screen.dart';
import 'package:hydro_iot/src/dashboard/presentation/screens/search_crop_cycle_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/add_device/add_device_form_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/add_device/add_device_pairing_step_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/add_device/add_device_preparing_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/search_device_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/add_device/add_device_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/detail_device_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/devices_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/history/sensor_history_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/setting_device_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/view_all_session_screen.dart';
import 'package:hydro_iot/src/devices/presentation/screens/add_device/serial_number_scanner_screen.dart';
import 'package:hydro_iot/src/notification/presentation/screens/notification_screen.dart';
import 'package:hydro_iot/src/profile/presentation/screens/change_password_request_screen.dart';
import 'package:hydro_iot/src/profile/presentation/screens/change_password_screen.dart';
import 'package:hydro_iot/src/profile/presentation/screens/change_password_verify_otp_screen.dart';
import 'package:hydro_iot/src/profile/presentation/screens/profile_screen.dart';
import 'package:hydro_iot/utils/utils.dart';

final router = GoRouter(
  navigatorKey: NavigationService.rootNavigatorKey,
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
      path: '/${AuthScreen.path}',
      name: AuthScreen.path,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AuthScreen(),
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
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
          return SlideTransition(position: tween.animate(curvedAnimation), child: child);
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
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
          return SlideTransition(position: tween.animate(curvedAnimation), child: child);
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
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
          return SlideTransition(position: tween.animate(curvedAnimation), child: child);
        },
      ),
    ),
    GoRoute(
      path: '/${OtpPasswordScreen.path}',
      name: OtpPasswordScreen.path,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: OtpPasswordScreen(email: extra?['email'] as String),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
            return SlideTransition(position: tween.animate(curvedAnimation), child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/${ChangePasswordScreen.path}',
      name: ChangePasswordScreen.path,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ChangePasswordScreen(email: extra?['email'] as String, resetToken: extra?['resetToken'] as String),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
            return SlideTransition(position: tween.animate(curvedAnimation), child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/${AddDeviceScreen.path}',
      name: AddDeviceScreen.path,
      pageBuilder: (context, state) => CustomTransitionPage(
        key: state.pageKey,
        child: const AddDeviceScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          const begin = Offset(1.0, 0.0);
          const end = Offset.zero;
          const curve = Curves.easeInOut;

          final tween = Tween(begin: begin, end: end);
          final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
          return SlideTransition(position: tween.animate(curvedAnimation), child: child);
        },
      ),
      routes: [
        GoRoute(
          path: '/${SerialNumberScannerScreen.path}',
          name: SerialNumberScannerScreen.path,
          pageBuilder: (context, state) {
            return CustomTransitionPage(
              key: state.pageKey,
              child: const SerialNumberScannerScreen(),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                final tween = Tween(begin: begin, end: end);
                final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
                return SlideTransition(position: tween.animate(curvedAnimation), child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/${AddDeviceFormScreen.path}',
          name: AddDeviceFormScreen.path,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: AddDeviceFormScreen(serialNumber: extra?['serialNumber'] as String? ?? ''),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                final tween = Tween(begin: begin, end: end);
                final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
                return SlideTransition(position: tween.animate(curvedAnimation), child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/${AddDevicePreparingScreen.path}',
          name: AddDevicePreparingScreen.path,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: AddDevicePreparingScreen(
                serialNumber: extra?['serialNumber'] as String? ?? '',
                deviceName: extra?['deviceName'] as String? ?? '',
                deviceDescription: extra?['deviceDescription'] as String? ?? '',
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                final tween = Tween(begin: begin, end: end);
                final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
                return SlideTransition(position: tween.animate(curvedAnimation), child: child);
              },
            );
          },
        ),
        GoRoute(
          path: '/${AddDevicePairingStepScreen.path}',
          name: AddDevicePairingStepScreen.path,
          pageBuilder: (context, state) {
            final extra = state.extra as Map<String, dynamic>?;
            return CustomTransitionPage(
              key: state.pageKey,
              child: AddDevicePairingStepScreen(
                serialNumber: extra?['serialNumber'] as String? ?? '',
                deviceName: extra?['deviceName'] as String? ?? '',
                deviceDescription: extra?['deviceDescription'] as String? ?? '',
              ),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                const begin = Offset(1.0, 0.0);
                const end = Offset.zero;
                const curve = Curves.easeInOut;

                final tween = Tween(begin: begin, end: end);
                final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
                return SlideTransition(position: tween.animate(curvedAnimation), child: child);
              },
            );
          },
        ),
      ],
    ),
    GoRoute(
      path: '/${SettingDeviceScreen.path}',
      name: SettingDeviceScreen.path,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          key: state.pageKey,
          child: SettingDeviceScreen(
            deviceId: extra['deviceId'] as String,
            deviceName: extra['deviceName'] as String,
            deviceDescription: extra['deviceDescription'] as String,
            addedAt: extra['addedAt'] as String,
            updatedAt: extra['updatedAt'] as String,
            ssid: extra['ssid'] as String,
            serialNumber: extra['serialNumber'] as String,
          ),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(0.0, 1.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
            return SlideTransition(position: tween.animate(curvedAnimation), child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/${ChangePasswordRequestScreen.path}',
      name: ChangePasswordRequestScreen.path,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ChangePasswordRequestScreen(email: extra?['email'] as String),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
            return SlideTransition(position: tween.animate(curvedAnimation), child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/${ChangePasswordVerifyOtpScreen.path}',
      name: ChangePasswordVerifyOtpScreen.path,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        return CustomTransitionPage(
          key: state.pageKey,
          child: ChangePasswordVerifyOtpScreen(email: extra?['email'] as String),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
            return SlideTransition(position: tween.animate(curvedAnimation), child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/${AuthedChangePasswordScreen.path}',
      name: AuthedChangePasswordScreen.path,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          key: state.pageKey,
          child: AuthedChangePasswordScreen(email: extra['email'] as String, resetToken: extra['resetToken'] as String),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
            return SlideTransition(position: tween.animate(curvedAnimation), child: child);
          },
        );
      },
    ),
    GoRoute(
      path: '/${SensorHistoryScreen.path}',
      name: SensorHistoryScreen.path,
      pageBuilder: (context, state) {
        final extra = state.extra as Map<String, dynamic>;
        return CustomTransitionPage(
          key: state.pageKey,
          child: SensorHistoryScreen(cropCycleId: extra['cropCycleId'] as String),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            final tween = Tween(begin: begin, end: end);
            final curvedAnimation = CurvedAnimation(parent: animation, curve: curve);
            return SlideTransition(position: tween.animate(curvedAnimation), child: child);
          },
        );
      },
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
                  path: '/${SearchDeviceScreen.path}',
                  name: SearchDeviceScreen.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: const SearchDeviceScreen(),
                    transitionsBuilder: (context, animation, secondaryAnimation, child) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                  ),
                ),
                GoRoute(
                  path: '/${SearchCropCycleScreen.path}',
                  name: SearchCropCycleScreen.path,
                  pageBuilder: (context, state) => CustomTransitionPage(
                    key: state.pageKey,
                    child: const SearchCropCycleScreen(),
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
                  path: '/:serialNumber',
                  name: 'deviceDetail',
                  pageBuilder: (context, state) {
                    final serialNumber = state.pathParameters['serialNumber']!;
                    final extra = state.extra as Map<String, dynamic>;
                    return CustomTransitionPage(
                      key: state.pageKey,
                      child: DetailDeviceScreen(
                        deviceId: serialNumber,
                        deviceName: extra['deviceName'] as String,
                        pH: extra['pH'] as double,
                        ppm: (extra['ppm'] as double).toInt(),
                        deviceDescription: extra['deviceDescription'] as String?,
                      ),
                      transitionsBuilder: (context, animation, secondaryAnimation, child) {
                        return FadeTransition(opacity: animation, child: child);
                      },
                    );
                  },
                  routes: [
                    GoRoute(
                      path: '/${ViewAllPlantSessionScreen.path}',
                      name: ViewAllPlantSessionScreen.path,
                      pageBuilder: (context, state) {
                        final serialNumber = state.pathParameters['serialNumber']!;
                        final extra = state.extra as Map<String, dynamic>;
                        return CustomTransitionPage(
                          key: state.pageKey,
                          child: ViewAllPlantSessionScreen(
                            deviceId: extra['deviceId'] as String,
                            deviceName: extra['deviceName'] as String,
                            serialNumber: serialNumber,
                          ),
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
    final isLoggedIn = await Storage().readIsLoggedIn;
    final role = await Storage().readRole();
    debugPrint('isLoggedIn: $isLoggedIn, role: $role, path: ${state.matchedLocation}');
    final publicPaths = [
      '/',
      '/${LandingScreen.path}',
      '/${AuthScreen.path}',
      '/${LoginScreen.path}',
      '/${RegisterScreen.path}',
      '/${ChangePasswordScreen.path}',
      '/${ForgotPasswordScreen.path}',
      '/${OtpPasswordScreen.path}',
    ];

    if (isLoggedIn == null) {
      return '/${LandingScreen.path}';
    }
    if (role == 'ADMIN' && isLoggedIn) {
      await Storage().clearSession();
      return '/${AuthScreen.path}';
    }
    if (!isLoggedIn && !publicPaths.contains(state.matchedLocation)) {
      await Storage().clearSession();
      return '/${AuthScreen.path}';
    }
    if (isLoggedIn && publicPaths.contains(state.matchedLocation)) {
      return '/${DashboardScreen.path}';
    }
    return null;
  },
);

/// Route observer to use with RouteAware
final RouteObserver<ModalRoute<void>> routeObserver = RouteObserver<ModalRoute<void>>();
