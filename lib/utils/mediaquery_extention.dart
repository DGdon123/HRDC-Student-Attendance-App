import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double heightPct(double percent) {
    return MediaQuery.sizeOf(this).height * percent;
  }

  double widthPct(double percent) {
    // return MediaQuery.of(this).size.width * percent;
    return MediaQuery.of(this).size.width * percent;
  }

  double get textScaleFactor => MediaQuery.of(this).textScaleFactor;
}
