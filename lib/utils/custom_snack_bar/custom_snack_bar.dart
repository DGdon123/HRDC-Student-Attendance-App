import 'package:flutter/material.dart';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:ym_daa_toce/const/app_dimension.dart';

void showCustomSnackBar(String message, BuildContext context,
    {bool isError = true}) {
  final width = MediaQuery.of(context).size.width;
  ResponsiveHelper.isDesktop(context)
      ? ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            message,
          ),
          margin: ResponsiveHelper.isDesktop(context)
              ? EdgeInsets.only(
                  right: width * 0.75,
                  bottom: AppDimensions.paddingEXTRALARGE,
                  left: AppDimensions.paddingEXTRALARGE)
              : const EdgeInsets.only(bottom: AppDimensions.paddingEXTRALARGE),
          behavior: SnackBarBehavior.floating,
          dismissDirection: DismissDirection.down,
          duration: Duration(
              milliseconds: ResponsiveHelper.isDesktop(context) ? 1000 : 600),
          backgroundColor: isError ? Colors.red : Colors.green))
      : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: isError ? Colors.red : Colors.green,
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(10),
          content: Text(
            message,
            style: TextStyle(fontWeight: FontWeight.normal),
          ),
          duration: const Duration(seconds: 4),
        ));
}

class ResponsiveHelper {
  static bool isMobilePhone() {
    if (!kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  static bool isWeb() {
    return kIsWeb;
  }

  static bool isMobile(context) {
    final size = MediaQuery.of(context).size.width;
    if (size < 650 || !kIsWeb) {
      return true;
    } else {
      return false;
    }
  }

  static bool isTab(context) {
    final size = MediaQuery.of(context).size.width;
    if (size < 1300 && size >= 650) {
      return true;
    } else {
      return false;
    }
  }

  static bool isDesktop(context) {
    final size = MediaQuery.of(context).size.width;
    if (size >= 1300) {
      return true;
    } else {
      return false;
    }
  }
}
