import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_dimension.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

import '../../data/models/attendance_ranking_model.dart';

class AttendanceRankingTable extends StatelessWidget {
  const AttendanceRankingTable({super.key, required this.rankings});
  final List<AttendanceRankingModel> rankings;

  @override
  Widget build(BuildContext context) {
    List<String> tableHeader = [
      "Roll No.".tr(),
      "Name".tr(),
      "Total Present".tr(),
    ];
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: context.widthPct(0.015),
          vertical: context.heightPct(0.01)),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 0),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ...tableHeader.map((e) => Container(
                    decoration: const BoxDecoration(border: Border()),
                    child: Text(
                      e,
                      style: TextStyle(
                          color: Colors.black,
                          fontWeight: AppDimensions.fontMedium),
                    )))
              ],
            ),
          ),
          ...rankings.map((e) {
            return Container(
              color: AppColorConst.kappWhiteColor,
              margin: const EdgeInsets.symmetric(vertical: 4),
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(e.rollNumber.toString()),
                  Text(e.studentName),
                  Text(e.totalPresent), // Displaying 'Present' or 'Absent'
                  // Text(e.date),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
