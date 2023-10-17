import 'package:flutter/material.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
        drawerTheme: const DrawerThemeData(
          backgroundColor: AppColorConst.kappscafoldbg,
        ),
        scaffoldBackgroundColor: AppColorConst.kappscafoldbg,
        fontFamily: AppFont.kProductsanfont,
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: AppColorConst.kappWhiteColor),
          backgroundColor: AppColorConst.kappprimaryColorBlue,
          titleTextStyle: TextStyle(
            fontSize: 14,
            color: AppColorConst.kappWhiteColor,
            fontFamily: AppFont.kProductsanfont,
          ),
          elevation: 0,
        ));
  }
}
