import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/app/app.dart';
import 'package:ym_daa_toce/core/app_initialize/app_initialize.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  await AppInitialize.appInitialize();
  await EasyLocalization.ensureInitialized();
  // await DbClient().reset();
  runApp(
     ProviderScope(  child: EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('ne', 'NP')],
      path: 'assets/translations', // Path to your translation files
      fallbackLocale: Locale('en', 'US'), // Default language
      child: DaaToceApp(),)
    ),
  );
  await Future.delayed(const Duration(milliseconds: 1));
  FlutterNativeSplash.remove();
}
