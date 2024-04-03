// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nepali_date_picker/nepali_date_picker.dart';
import 'package:nepali_utils/nepali_utils.dart';

import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_dimension.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/features/search_attendance/data/model/search_attendance_response_model.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

import '../../../const/app_colors_const.dart';
import '../../assign_class/data/models/assign_class_model/assign_class_model.dart';
import '../../assign_class/presentation/controller/assign_class_controller.dart';
import '../../edit_attendance/presentation/views/edit_attendance_screen.dart';
import '../../edit_attendance/presentation/views/edit_attendance_section.dart';
import '../../search_attendance/presentation/controllers/search_controller.dart';

class PreviousAttendeneDetailScreen extends ConsumerWidget {
  const PreviousAttendeneDetailScreen({
    required this.classNum,
    required this.sectionNum,
    required this.date,
    required this.teacherName,
    required this.className,
    required this.sectionName,
    required this.sectionid,
    required this.classid,
  });
  final String classNum;
  final String sectionNum;
  final String date;
  final String teacherName;
  final String className;
  final String sectionName;
  final int sectionid;
  final int classid;

  @override
  Widget build(BuildContext context, ref) {
    final dateFormat = DateTime.parse(date);
    final currentDate = DateTime.now();
    final nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    final nepaliDate = dateFormat.toNepaliDateTime();
    final year = NepaliDateFormat.y().format(nepaliDate);
    final month = NepaliDateFormat.M().format(nepaliDate);
    final day = NepaliDateFormat.d().format(nepaliDate);
    final showIcon = currentDate.hour < 24;
    String convertToNepaliDate(DateTime gregorianDate) {
      final NepaliDateTime nepaliDateTime =
          NepaliDateTime.fromDateTime(gregorianDate);
      final NepaliDateFormat formatter = NepaliDateFormat('y-MM-dd');
      final String nepaliDate = formatter.format(nepaliDateTime);
      return nepaliDate.replaceAll('0', '०'); // Replace '0' with '०'
    }

    final nepaliCurrentDate =
        NepaliDateFormat('yyyy-MM-dd').format(nepaliDateTime);
    log(nepaliDate.toString());
    List<String> hello;
    int present = 1, absent = 0;
    List<String> tableHeader = [
      "Roll No.".tr(),
      "Name".tr(),
      "Status".tr(),
    ];
    AssignedClassModel show = AssignedClassModel(
        class_id: 0,
        class_name: '',
        school_id: 0,
        section_id: '',
        section: '',
        teacher_id: 0,
        teacher_name: '');
    var studentReasonList = ref.watch(editstudentReasonListProvider);
    final assingedClass = ref.watch(assignedClassControllerProvider);
    final presentList = studentReasonList
        .map((e) => e.text)
        .where((text) => text == "Present")
        .toList();

    final absentList = studentReasonList
        .map((e) => e.text)
        .where((text) => text == "Absent")
        .toList();

    List<String> combinedList = [...presentList, ...absentList];

    final nepaliDate2 = convertToNepaliDate(dateFormat);
    final devanagariDate = NepaliUnicode.convert(nepaliDate2);
    log(devanagariDate);
    return Scaffold(
        appBar: AppBar(
          title: Text("Attendance Detail".tr()),
          actions: <Widget>[
            if (showIcon)
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                onPressed: () {
                  assingedClass.when(
                      data: (data) {
                        show = data;
                      },
                      error: (err, str) => Center(
                            child: Text(err.toString()),
                          ),
                      loading: () => Center(
                            child: CircularProgressIndicator(
                              color: AppColorConst.kappprimaryColorBlue,
                            ),
                          ));
                  normalNav(
                      context,
                      EditAttendanceScreen(
                        e: show,
                        offlineAttendance: "offlineAttendance",
                      ));
                  // handle the press
                },
              ),
          ],
        ),
        body: ref
            .watch(searchAttendaceControllerProvider(
                SearchParam(classNum, sectionNum, "${year}-${month}-${day}")))
            .when(
                data: (data) {
                  final totalStudents = data.count.totalFamales +
                      data.count.totalMales +
                      data.count.totalOthers;
                  return Padding(
                    padding: EdgeInsets.symmetric(
                        horizontal: context.widthPct(0.015),
                        vertical: context.heightPct(0.01)),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 14, vertical: 14),
                            margin: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${className} ${sectionName}",
                                      style: TextStyle(
                                          fontFamily: AppFont.kProductsanfont,
                                          fontSize: AppDimensions.body_16,
                                          fontWeight: AppDimensions.fontMedium),
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          "${"Total Students".tr()}: ${totalStudents}",
                                          style: TextStyle(
                                              fontFamily:
                                                  AppFont.kProductsanfont,
                                              fontSize: AppDimensions.body_16,
                                              fontWeight:
                                                  AppDimensions.fontMedium),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 16,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${"Date".tr()}: ${context.locale.languageCode == 'en' ? nepaliCurrentDate ?? devanagariDate : devanagariDate}",
                                          style: TextStyle(
                                              fontFamily:
                                                  AppFont.lProductsanfont),
                                        ),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                            "${"Total Present".tr()}: ${data.count.present}"),
                                        SizedBox(
                                          height: 7,
                                        ),
                                        Text(
                                            "${"Total Absent".tr()}: ${data.count.absent}"),
                                      ],
                                    ),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            Text(
                                                "${"Boys".tr()}: ${data.count.totalMales}"),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                                "${"Girls".tr()}: ${data.count.totalFamales}"),
                                            SizedBox(
                                              height: 7,
                                            ),
                                            Text(
                                                "${"Others".tr()}: ${data.count.totalOthers}"),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ],
                                ),

                                // Row(
                                //   mainAxisAlignment:
                                //       MainAxisAlignment.spaceBetween,
                                //   children: [
                                //     Text(
                                //         "${"Teacher".tr()} : ${teacherName}"),
                                //     // Text("Attendace Status : Active")
                                //   ],
                                // ),
                              ],
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 0),
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 10),
                            decoration: const BoxDecoration(
                              color: Colors.white,
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                ...tableHeader.map((e) => Container(
                                    decoration:
                                        const BoxDecoration(border: Border()),
                                    child: Text(
                                      e,
                                      style: TextStyle(
                                          color: AppColorConst
                                              .kappprimaryColorBlue,
                                          fontWeight: AppDimensions.fontMedium),
                                    )))
                              ],
                            ),
                          ),
                          ...data.data.map((e) {
                            return Container(
                              color: AppColorConst.kappWhiteColor,
                              margin: const EdgeInsets.symmetric(vertical: 4),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14, horizontal: 10),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(e.rollNo.toString()),
                                  Text(e.name),
                                  Text(e.attendanceStatus),
                                  // Text(e.date),
                                ],
                              ),
                            );
                          })
                        ],
                      ),
                    ),
                  );
                },
                error: (err, s) => Center(
                      child: Text(err.toString()),
                    ),
                loading: () => Center(
                      child: CircularProgressIndicator(),
                    )));
  }
}
