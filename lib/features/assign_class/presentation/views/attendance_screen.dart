import 'dart:convert';
import 'dart:developer';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:loader_skeleton/loader_skeleton.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_dimension.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/attendance_reason/attendance_resons_model.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

import '../../data/data_source/assign_class_data_source.dart';
import '../../data/models/assign_class_model/assign_class_model.dart';
import '../../data/models/assign_class_studenslist_model/assign_class_students_list_model.dart';
import '../../data/models/assign_class_studenslist_model/class_section_params_model.dart';
import '../../data/repository/assigned_class_repository.dart';
import '../controller/assign_class_detail_controller.dart';
import '../controller/top_three_attendance_controller.dart';
import 'attendance_section.dart';

final showDropdownProvider = StateProvider<int?>((ref) {
  return null;
});

class AttendanceScreen extends ConsumerStatefulWidget {
  const AttendanceScreen({
    super.key,
    required this.e,
    required this.offlineAttendance,
  });
  final AssignedClassModel e;
  final String offlineAttendance;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<AttendanceScreen> {
  List<AttendanceReasonModel> presentStatusList = [];

  // List<AttendanceReasonModel> presentStatusList = [
  //   AttendanceReasonModel(id: 1, name: "अस्वस्थता"),
  //   AttendanceReasonModel(id: 2, name: "घरायसी काम\t"),
  //   AttendanceReasonModel(id: 3, name: "संस्कार/चाडपर्व"),
  // ];
  List<AttendanceReasonModel> absentStatusList = [];
  // List<String> absentStatusList = [
  //   "अस्वस्थता",
  //   "घरायसी काम",
  //   "संस्कार/चाडपर्व",
  //   "गृहकार्य नसकेर ",
  // ];
  late List<int> status_id;
  late List<int> student_id;
  late List<int> reason_id;
  late bool ispresent;
  List<String>? studentname;
  List<String>? studentroll;
  List<String>? stdValue;
  List<String>? stdFind;

  Count? pop;

  void loadSharedPrefsData() async {
    SharedPreferences.getInstance().then((prefs) {
      studentname = prefs.getStringList('stdname');
      studentroll = prefs.getStringList('stdroll');
      stdValue = prefs.getStringList('stdvalue');
      stdFind = prefs.getStringList('stdfind');
      if (stdFind != null && stdValue != null) {
        log(stdFind.toString());

        log(stdValue.toString());
      }
    });

    setState(() {});
  }

  List<StudentsList> attendanceStudents = [];
  fetchAttendanceReasons() async {
    final List<AttendanceReasonModel> presentStatusList = await ref
        .read(assignedClassDataSourceProvider)
        .getAttendanceStatusList(0);
    setState(() {
      this.presentStatusList = presentStatusList;
    });
    final List<AttendanceReasonModel> absentStatusList = await ref
        .read(assignedClassDataSourceProvider)
        .getAttendanceStatusList(1);
    setState(() {
      this.absentStatusList = absentStatusList;
    });
  }

  bool isLoading = false;

  void saveDataObjectToSharedPreferences(
      Map<String, dynamic> dataObject) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final dataObjectJson = json.encode(dataObject);
      prefs.setString('dataObject', dataObjectJson);
      log(dataObjectJson);
    } catch (e) {
      print('Error saving dataObject to SharedPreferences: $e');
    }
  }

  void saveStudentReasonListToSharedPreferences(
      List<StudentReasonModel> studentReasonList) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final studentReasonListJson =
          json.encode(studentReasonList.map((e) => e.toJson()).toList());
      prefs.setString('studentReasonList', studentReasonListJson);
      log(studentReasonListJson);
    } catch (e) {
      print('Error saving studentReasonList to SharedPreferences: $e');
    }
  }

  @override
  void initState() {
    isLoading = false;
    fetchAttendanceReasons();
    ispresent = true;
    status_id = [];
    student_id = [];
    reason_id = [];

    super.initState();
    loadSharedPrefsData();
  }

  @override
  Widget build(BuildContext context) {
    final showReason = ref.watch(showDropdownProvider);
    // final currentDate = DateTime.now();
    // final formattedDate = DateFormat('yyyy-MM-dd').format(currentDate);

    // final nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    // final nepaliDate = NepaliDateFormat('yyyy-MM-dd').format(nepaliDateTime);
    final currentDate = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final date = dateFormat.format(currentDate);
    final nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    final englishCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final nepaliCurrentDate =
        NepaliDateFormat('yyyy-MM-dd').format(nepaliDateTime);
    final devanagariDate = NepaliUnicode.convert(nepaliCurrentDate);

    // log(englishCurrentDate);
    // log(nepaliCurrentDate);

    final assingedClass = ref.watch(assignedClassDetailControllerProvider(
        ClassSectionParams(
            classId: int.parse(widget.e.class_id),
            sectionid: int.parse(widget.e.section_id))));
    // log(nepaliDate.toString());
    return Scaffold(
        floatingActionButton: currentDate.hour < 12
            ? isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      color: AppColorConst.kappprimaryColorBlue,
                    ),
                  )
                : SizedBox(
                    height: 50,
                    child: isLoading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: AppColorConst.kappprimaryColorBlue,
                            ),
                          )
                        : FloatingActionButton.extended(
                            onPressed: () async {
                              var studentReasonList =
                                  ref.watch(studentReasonListProvider);
                              print(studentReasonList.length);
                              log(attendanceStudents.length.toString());
                              if (attendanceStudents.length !=
                                  studentReasonList.length) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    "Please select all students".tr(),
                                  ),
                                ));
                                return;
                              }

                              var missedCount = 0;

                              for (var item in studentReasonList) {
                                if (item.status == 0 && item.reasonId == null) {
                                  var missedStudents = ref.watch(
                                      absentReasonMissingStudentsProvider);
                                  missedStudents.add(item.studentId.toString());
                                  var uniqueMissed = missedStudents.toSet();
                                  ref
                                      .watch(absentReasonMissingStudentsProvider
                                          .notifier)
                                      .state = uniqueMissed.toList();
                                  missedCount += 1;
                                }
                              }
                              if (missedCount > 0) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  backgroundColor: Colors.red,
                                  behavior: SnackBarBehavior.floating,
                                  content: Text(
                                    "Please select reason for absence".tr(),
                                  ),
                                ));
                                return;
                              }
                              Map<String, dynamic> dataObject = {
                                "class_id": int.parse(widget.e.class_id),
                                "attendance_date": nepaliCurrentDate,
                                // "attendance_date": "2024-01-03",
                                "attendance_date_ad": date,
                                // "attendance_date_ad": "2024-01-03",
                                "attendance_date_bs": devanagariDate,
                                // "attendance_date_bs": "2081-01-03",
                                "school_id": int.parse(widget.e.school_id),
                                "teacher_id": int.parse(widget.e.teacher_id),
                                "section_id": int.parse(widget.e.section_id)
                              };

                              for (int i = 0;
                                  i < studentReasonList.length;
                                  i++) {
                                dataObject.addAll({
                                  "student_id[${i}]":
                                      studentReasonList[i].studentId,
                                  "reason_id[${i}]":
                                      studentReasonList[i].reasonId,
                                  "status[${i}]": studentReasonList[i].status
                                });
                              }
                              dataObject.removeWhere((key, value) =>
                                  key.startsWith("reason_id") && value == null);

                              FormData formData = FormData.fromMap(dataObject);
                              saveDataObjectToSharedPreferences(dataObject);
                              saveStudentReasonListToSharedPreferences(
                                  studentReasonList);
                              setState(() {
                                isLoading = true;
                              });
                              final result = await ref
                                  .read(assignedClassRepositoryProvider)
                                  .storeAttendenceRepo(formData);
                              result.fold((l) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.red,
                                  content: Text(l.message),
                                ));
                              }, (r) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  behavior: SnackBarBehavior.floating,
                                  backgroundColor: Colors.green,
                                  content: Text(r.message),
                                ));
                              });
                              setState(() {
                                isLoading = false;
                              });
                              ref.refresh(
                                topThreeAttendanceControllerProvider(
                                  TopThreeParams(
                                    classNum: widget.e.class_id.toString(),
                                    sectionNum: widget.e.section_id.toString(),
                                  ),
                                ),
                              );
                              Navigator.of(context).pop();
                            },
                            label: Text(
                              "Submit".tr(),
                              style: TextStyle(color: Colors.white),
                            ),
                            icon: Icon(
                              Icons.done,
                              color: Colors.white,
                            ),
                            backgroundColor: Colors.blue.shade700,
                          ),
                  )
            : null,
        appBar: AppBar(
          title: Text("Attendance".tr()),
        ),
        body: assingedClass.when(
            data: (data) {
              final studentname =
                  data.studentsList.map((item) => item.name).toList();
              final studentid =
                  data.studentsList.map((item) => item.studentId).toList();
              final studentroll =
                  data.studentsList.map((item) => item.rollNumber).toList();
              final studentlistvalue =
                  data.studentsList.map((item) => item.value).toList();
              final studentlistfind =
                  data.studentsList.map((item) => item.find).toList();
              SharedPreferences.getInstance().then((prefs) {
                prefs.setStringList('stdname', studentname);
                prefs.setStringList('stdroll', studentroll);
                prefs.setStringList('stdid', studentid);
                prefs.setStringList(
                    'stdvalue',
                    studentlistvalue
                        .map((value) => value.toString())
                        .toList()); // Convert bool list to string list
                prefs.setStringList(
                    'stdfind',
                    studentlistfind
                        .map((value) => value.toString())
                        .toList()); // Convert bool list to string list// Save as list of bool
              });

              final females = data.scount.totalFemales;
              final males = data.scount.totalMales;
              final other = data.scount.totalOthers;
              final total = data.scount.totalStudents;
              SharedPreferences.getInstance().then((prefs) {
                prefs.setString('females', females.toString());
                prefs.setString('males', males.toString());
                prefs.setString('other', other.toString());
                prefs.setString('total', total.toString());
              });
              log(stdValue.toString());
              log(studentid.toString());
              attendanceStudents = data.studentsList;

              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${widget.e.class_name} ${widget.e.section}",
                                style: TextStyle(
                                    fontFamily: AppFont.kProductsanfont,
                                    fontSize: AppDimensions.body_16,
                                    fontWeight: AppDimensions.fontMedium),
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    "${"Total Students".tr()}: ${data.scount.totalStudents}",
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
                            height: 12,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "${"Date".tr()}: ${context.locale.languageCode == 'en' ? nepaliCurrentDate ?? devanagariDate : devanagariDate}",
                                    style: TextStyle(
                                        fontFamily: AppFont.lProductsanfont),
                                  ),
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
                                          "${"Boys".tr()}: ${data.scount.totalMales}"),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                          "${"Girls".tr()}: ${data.scount.totalFemales}"),
                                      SizedBox(
                                        height: 7,
                                      ),
                                      Text(
                                          "${"Others".tr()}: ${data.scount.totalOthers}"),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),

                          // Row(
                          //   crossAxisAlignment: CrossAxisAlignment.start,
                          //   children: const [
                          //     Text("Total Present: 22/45"),
                          //     Text("Total Absent: 23/45"),
                          //   ],
                          // ),
                          // Row(
                          //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          //   children: [
                          //     Text(
                          //         "${"Teacher".tr()}: ${widget.e.teacher_name.toString()}"),
                          //     // Text("Attendace Status : Active")
                          //   ],
                          // ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.625,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ...data.studentsList.map((e) => AttendanceSection(
                                  student: e,
                                  assignedClassModel: widget.e,
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
            error: (er, s) => Text(er.toString()),
            loading: () => Center(
                    child: CardPageSkeleton(
                  totalLines: 5,
                ))));
  }
}
