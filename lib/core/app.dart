import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hydro_iot/res/res.dart';
import 'core.dart';

class App extends ConsumerStatefulWidget {
  const App({super.key});
  @override
  ConsumerState<App> createState() => _AppState();
}

class _AppState extends ConsumerState<App> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      enableScaleWH: () => true,
      builder: (context, child) {
        return MaterialApp.router(
          debugShowCheckedModeBanner: false,
          theme: AppThemeData.getTheme(),
          // darkTheme: AppThemeData.getDarkTheme(),
          themeMode: ref.watch(themeProvider).themeMode,
          themeAnimationCurve: Easing.emphasizedAccelerate,
          themeAnimationDuration: const Duration(milliseconds: 500),
          title: AppStrings.appName,
          routeInformationParser: router.routeInformationParser,
          routerDelegate: router.routerDelegate,
          routeInformationProvider: router.routeInformationProvider,
        );
      },
    );
  }
}
