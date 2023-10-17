import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class AttendaceReportModel {
  final String name;
  final double percent;
  final Color color;

  AttendaceReportModel(
      {required this.name, required this.percent, required this.color});

  static List<AttendaceReportModel> attendenceRepostList = [
    AttendaceReportModel(
        name: "Boys", percent: 55, color: const Color(0xff2DA9D8)),
    AttendaceReportModel(
        name: "Girls", percent: 60, color: const Color(0xffB73377)),
    AttendaceReportModel(name: "Other", percent: 10, color: Colors.yellow),
  ];
}
