import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/controllers/auth_controller.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/presentation/views/login_screen.dart';
import 'package:ym_daa_toce/features/dashboard/presentation/views/dashboard.dart';
import 'package:ym_daa_toce/theme/app_theme.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ym_daa_toce/utils/bottom_bar/bottom_bar.dart';

class DaaToceApp extends ConsumerStatefulWidget {
  const DaaToceApp({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<DaaToceApp> {
  @override
  Widget build(BuildContext context) {
    return ResponsiveSizer(builder: (context, orientation, screenType) {
      return MaterialApp(
          theme: AppTheme.light(),
          debugShowCheckedModeBanner: false,
          localizationsDelegates: context.localizationDelegates,
          supportedLocales: context.supportedLocales,
          locale: context.locale,
          home: ref.watch(authControllerProvider).when(
              loggedIn: (data) {
                return BottomBar(
                  initialIndex: 0,
                );
              },
              loggedOut: () => LoginScreen(),
              loading: CircularProgressIndicator.adaptive));
    });
  }
}
