import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_dimension.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

import '../../../assign_class/data/models/assign_class_model/assign_class_model.dart';
import '../../data/model/search_attendance_response_model.dart';

class AttendanceResultScreen extends StatelessWidget {
  const AttendanceResultScreen(
      {super.key,
      required this.searchResponseModel,
      required this.assignedClassModel,
      required this.date});
  final SearchResponseModel searchResponseModel;
  final AssignedClassModel assignedClassModel;
  final String date;
  @override
  Widget build(BuildContext context) {
    final devanagariDate = NepaliUnicode.convert(date);
    final currentDate = DateTime.now();
    final nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    final nepaliCurrentDate =
        NepaliDateFormat('yyyy-MM-dd').format(nepaliDateTime);
    List<String> tableHeader = [
      "Roll No.".tr(),
      "Name".tr(),
      "Status".tr(),
    ];
    final totalStudents = searchResponseModel.count.totalOthers +
        searchResponseModel.count.totalFamales +
        searchResponseModel.count.totalMales;
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppConst.kappBarpreviousAttendenceDetail),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
            horizontal: context.widthPct(0.015),
            vertical: context.heightPct(0.01)),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                margin:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                alignment: Alignment.topLeft,
                width: context.widthPct(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: AppColorConst.kappWhiteColor,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 6,
                      spreadRadius: 1,
                      offset: Offset(0, 1),
                      color: CupertinoColors.lightBackgroundGray,
                    )
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          assignedClassModel.class_name +
                              " " +
                              assignedClassModel.section,
                          style: TextStyle(
                              fontFamily: AppFont.kProductsanfont,
                              fontSize: AppDimensions.body_16,
                              fontWeight: AppDimensions.fontMedium),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              "${"Total Students".tr()}: ${totalStudents}",
                              style: TextStyle(
                                  fontFamily: AppFont.kProductsanfont,
                                  fontSize: AppDimensions.body_16,
                                  fontWeight: AppDimensions.fontMedium),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 16,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "${"Date".tr()}: ${context.locale.languageCode == 'en' ? nepaliCurrentDate ?? devanagariDate : devanagariDate}",
                              style: TextStyle(
                                  fontFamily: AppFont.lProductsanfont),
                            ),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                                "${"Total Present".tr()}: ${searchResponseModel.count.present}"),
                            SizedBox(
                              height: 7,
                            ),
                            Text(
                                "${"Total Absent".tr()}: ${searchResponseModel.count.absent}"),
                          ],
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                    "${"Boys".tr()}: ${searchResponseModel.count.totalMales}"),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                    "${"Girls".tr()}: ${searchResponseModel.count.totalFamales}"),
                                SizedBox(
                                  height: 7,
                                ),
                                Text(
                                    "${"Others".tr()}: ${searchResponseModel.count.totalOthers}"),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 0),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 10),
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
                              color: AppColorConst.kappprimaryColorBlue,
                              fontWeight: AppDimensions.fontMedium),
                        )))
                  ],
                ),
              ),
              ...searchResponseModel.data.map((e) => Container(
                    color: AppColorConst.kappWhiteColor,
                    margin: const EdgeInsets.symmetric(vertical: 4),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(e.rollNo.toString()),
                        Text(e.name),
                        Text(e.attendanceStatus),
                        // Text(e.date),
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
