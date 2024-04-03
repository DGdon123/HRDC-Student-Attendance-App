import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nepali_utils/nepali_utils.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_dimension.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/attendance_reason/attendance_resons_model.dart';
import 'package:ym_daa_toce/utils/bottom_bar/bottom_bar.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';
import 'package:ym_daa_toce/features/offline/offline_attendance/data/models/offline_attendance_model.dart';
import '../../../../../utils/custom_navigation/app_nav.dart';
import '../../../../assign_class/data/data_source/assign_class_data_source.dart';
import '../../../../assign_class/data/models/assign_class_studenslist_model/assign_class_students_list_model.dart';
import '../../../../dashboard/presentation/views/dashboard.dart';
import '../../../offline_dashboard/data/models/offline_class_model.dart';
import '../../../offline_dashboard/data/models/shared_prefs_model.dart';
import '../../../offline_dashboard/presentation/controllers/offline_controller.dart';
import '../../data/models/offline_reasons_model.dart';
import '../../data/models/population_model.dart';

final showDropdownProvider = StateProvider<int?>((ref) {
  return null;
});

final absentReasonMissingStudentsProvider = StateProvider<List<String>>((ref) {
  return [];
});

final studentReasonListProvider =
    StateProvider<List<StudentReasonModel>>((ref) {
  return [];
});

class StudentReasonModel {
  final int studentId;
  int? reasonId;
  final int status;
  StudentReasonModel({
    required this.studentId,
    this.reasonId,
    required this.status,
  });

  StudentReasonModel copyWith({
    int? studentId,
    int? reasonId,
    int? status,
  }) {
    return StudentReasonModel(
      studentId: studentId ?? this.studentId,
      reasonId: reasonId ?? this.reasonId,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'studentId': studentId,
      'reasonId': reasonId,
      'status': status,
    };
  }

  factory StudentReasonModel.fromMap(Map<String, dynamic> map) {
    return StudentReasonModel(
      studentId: map['studentId'] as int,
      reasonId: map['reasonId'] != null ? map['reasonId'] as int : null,
      status: map['status'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory StudentReasonModel.fromJson(String source) =>
      StudentReasonModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'StudentReasonModel(studentId: $studentId, reasonId: $reasonId, status: $status)';

  @override
  bool operator ==(covariant StudentReasonModel other) {
    if (identical(this, other)) return true;

    return other.studentId == studentId &&
        other.reasonId == reasonId &&
        other.status == status;
  }

  @override
  int get hashCode => studentId.hashCode ^ reasonId.hashCode ^ status.hashCode;
}

class OfflineAttendanceScreen extends ConsumerStatefulWidget {
  const OfflineAttendanceScreen({
    super.key,
  });

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AttendanceScreenState();
}

class _AttendanceScreenState extends ConsumerState<OfflineAttendanceScreen> {
  List<AttendanceReasonModel> presentStatusList = [];
  int? selectedChoiceChipIndex;
  Map<String, int> selectedReasonsMap = {};

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
  List<String> dropdownValues = [];
  PopulationModel? pop;
  OfflineClassModel? what;

  List<StudentsList> attendanceStudents = [];
  bool presentButtonSelected = false;
  bool absentButtonSelected = false;
  List<OfflineAttendanceReasonModel> offabsent = [];
  List<AttendanceReasonModel> presentReasons = [];
  List<AttendanceReasonModel> absentReasons = [];
  int selectedPresentReasonIndex = -1;
  int selectedAbsentReasonIndex = -1;
  List<String>? stdValue;
  List<String>? idlist;
  Map<int, bool> selectedIndices = {};
  List<String>? stdFind;
  List<String>? studentname;
  List<int> stdAttend = [];
  List<int> stdReason = [];
  List<String>? studentroll;
  List<String>? studentid;
  List<String>? nreasonList;

  OfflineAttendanceReasonModel? stats;

  // Function to save data offline
  Future<void> saveDataOffline(OfflineAttendanceModel data) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Map<String, dynamic> dataMap = data.toMap();
    String dataJson = json.encode(dataMap);
    prefs.setString('offline_data', dataJson);
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

  void loadSharedPrefsData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    what = OfflineClassModel(
        school_id: prefs.getString('school_id').toString(),
        class_id: prefs.getString('class_id').toString(),
        class_name: prefs.getString('class_name').toString(),
        section_id: prefs.getString('section_id').toString(),
        section: prefs.getString('section').toString(),
        teacher_name: prefs.getString('teacher_name').toString(),
        teacher_id: prefs.getInt('teacher_id'));
    pop = PopulationModel(
        females: prefs.getString('females').toString(),
        males: prefs.getString('males').toString(),
        other: prefs.getString('other').toString(),
        total: prefs.getString('total').toString());
    SharedPreferences.getInstance().then((prefs) {
      studentname = prefs.getStringList('stdname');
      studentroll = prefs.getStringList('stdroll');
      studentid = prefs.getStringList('stdid');
      stdValue = prefs.getStringList('stdvalue');
      stdFind = prefs.getStringList('stdfind');
      nreasonList = prefs.getStringList('areason');

      idlist = prefs.getStringList('id');
      if (studentname != null &&
          studentroll != null &&
          studentid != null &&
          pop != null &&
          nreasonList != null &&
          what != null &&
          idlist != null) {
        log(studentname.toString());
        log(nreasonList.toString());
        log(studentroll.toString());
        log(studentid.toString());
        log(idlist.toString());
        log(pop.toString());
        log(what.toString());
      }
    });
    setState(() {
      isLoading = false;
    });
  }

  submit() async {
    var studentReasonList = ref.watch(studentReasonListProvider);

    // Submit attendance for day 1
    final currentDate = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final date = dateFormat.format(currentDate);
    final nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    final englishCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final nepaliCurrentDate =
        NepaliDateFormat('yyyy-MM-dd').format(nepaliDateTime);
    final devanagariDate = NepaliUnicode.convert(nepaliCurrentDate);

    final OfflineAttendanceModel formData = OfflineAttendanceModel(
      section_id: int.parse(what!.section_id.toString()),
      attendanceDateAd: date,
      school_id: int.parse(what!.school_id.toString()),
      attendanceDateBs: devanagariDate,
      teacher_id: int.parse(what!.teacher_id.toString()),
      attendanceDate: nepaliCurrentDate,
      classID: int.parse(what!.class_id.toString()),
      reason_id: studentReasonList.map((e) => e.reasonId).toList(),
      status_id: studentReasonList.map((e) => e.status).toList(),
      student_id: studentReasonList.map((e) => e.studentId).toList(),
    );

    await saveDataOffline(formData);
    log(formData.toString());
    await ref.read(offlineControllerProvider.notifier).setData(1, formData);
    log(formData.toString());

    if (!mounted) return;
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text:
          'Day 1 attendance has been saved locally and will be stored when you get online!'
              .tr(),
      confirmBtnColor: AppColorConst.kappprimaryColorBlue,
      onConfirmBtnTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBar(
                    initialIndex: 1,
                  )),
          (route) => false, // This condition removes all routes from the stack
        );
      },
    );
  }

  submit2() async {
    var studentReasonList = ref.watch(studentReasonListProvider);

    // Submit attendance for day 1
    final currentDate = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final date = dateFormat.format(currentDate);
    final nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    final englishCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final nepaliCurrentDate =
        NepaliDateFormat('yyyy-MM-dd').format(nepaliDateTime);
    final devanagariDate = NepaliUnicode.convert(nepaliCurrentDate);

    final OfflineAttendanceModel formData = OfflineAttendanceModel(
      section_id: int.parse(what!.section_id.toString()),
      attendanceDateAd: date,
      school_id: int.parse(what!.school_id.toString()),
      attendanceDateBs: devanagariDate,
      teacher_id: int.parse(what!.teacher_id.toString()),
      attendanceDate: nepaliCurrentDate,
      classID: int.parse(what!.class_id.toString()),
      reason_id: studentReasonList.map((e) => e.reasonId).toList(),
      status_id: studentReasonList.map((e) => e.status).toList(),
      student_id: studentReasonList.map((e) => e.studentId).toList(),
    );

    await saveDataOffline(formData);
    log(formData.toString());
    await ref.read(offlineControllerProvider.notifier).setData(2, formData);
    log(formData.toString());
    if (!mounted) return;
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text:
          'Day 2 attendance has been saved locally and will be stored when you get online!'
              .tr(),
      confirmBtnColor: AppColorConst.kappprimaryColorBlue,
      onConfirmBtnTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBar(
                    initialIndex: 1,
                  )),
          (route) => false, // This condition removes all routes from the stack
        );
      },
    );
  }

  submit3() async {
    var studentReasonList = ref.watch(studentReasonListProvider);

    // Submit attendance for day 1
    final currentDate = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final date = dateFormat.format(currentDate);
    final nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    final englishCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final nepaliCurrentDate =
        NepaliDateFormat('yyyy-MM-dd').format(nepaliDateTime);
    final devanagariDate = NepaliUnicode.convert(nepaliCurrentDate);

    final OfflineAttendanceModel formData = OfflineAttendanceModel(
      section_id: int.parse(what!.section_id.toString()),
      attendanceDateAd: date,
      school_id: int.parse(what!.school_id.toString()),
      attendanceDateBs: devanagariDate,
      teacher_id: int.parse(what!.teacher_id.toString()),
      attendanceDate: nepaliCurrentDate,
      classID: int.parse(what!.class_id.toString()),
      reason_id: studentReasonList.map((e) => e.reasonId).toList(),
      status_id: studentReasonList.map((e) => e.status).toList(),
      student_id: studentReasonList.map((e) => e.studentId).toList(),
    );

    await saveDataOffline(formData);
    log(formData.toString());
    await ref.read(offlineControllerProvider.notifier).setData(3, formData);
    log(formData.toString());
    if (!mounted) return;
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text:
          'Day 3 attendance has been saved locally and will be stored when you get online!'
              .tr(),
      confirmBtnColor: AppColorConst.kappprimaryColorBlue,
      onConfirmBtnTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBar(
                    initialIndex: 1,
                  )),
          (route) => false, // This condition removes all routes from the stack
        );
      },
    );
  }

  submit4() async {
    var studentReasonList = ref.watch(studentReasonListProvider);

    // Submit attendance for day 1
    final currentDate = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final date = dateFormat.format(currentDate);
    final nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    final englishCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final nepaliCurrentDate =
        NepaliDateFormat('yyyy-MM-dd').format(nepaliDateTime);
    final devanagariDate = NepaliUnicode.convert(nepaliCurrentDate);

    final OfflineAttendanceModel formData = OfflineAttendanceModel(
      section_id: int.parse(what!.section_id.toString()),
      attendanceDateAd: date,
      school_id: int.parse(what!.school_id.toString()),
      attendanceDateBs: devanagariDate,
      teacher_id: int.parse(what!.teacher_id.toString()),
      attendanceDate: nepaliCurrentDate,
      classID: int.parse(what!.class_id.toString()),
      reason_id: studentReasonList.map((e) => e.reasonId).toList(),
      status_id: studentReasonList.map((e) => e.status).toList(),
      student_id: studentReasonList.map((e) => e.studentId).toList(),
    );

    await saveDataOffline(formData);
    log(formData.toString());
    await ref.read(offlineControllerProvider.notifier).setData(4, formData);
    log(formData.toString());
    if (!mounted) return;
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text:
          'Day 4 attendance has been saved locally and will be stored when you get online!'
              .tr(),
      confirmBtnColor: AppColorConst.kappprimaryColorBlue,
      onConfirmBtnTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBar(
                    initialIndex: 1,
                  )),
          (route) => false, // This condition removes all routes from the stack
        );
      },
    );
  }

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

  submit5() async {
    var studentReasonList = ref.watch(studentReasonListProvider);

    // Submit attendance for day 1
    final currentDate = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final date = dateFormat.format(currentDate);
    final nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    final englishCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final nepaliCurrentDate =
        NepaliDateFormat('yyyy-MM-dd').format(nepaliDateTime);
    final devanagariDate = NepaliUnicode.convert(nepaliCurrentDate);

    final OfflineAttendanceModel formData = OfflineAttendanceModel(
      section_id: int.parse(what!.section_id.toString()),
      attendanceDateAd: date,
      school_id: int.parse(what!.school_id.toString()),
      attendanceDateBs: devanagariDate,
      teacher_id: int.parse(what!.teacher_id.toString()),
      attendanceDate: nepaliCurrentDate,
      classID: int.parse(what!.class_id.toString()),
      reason_id: studentReasonList.map((e) => e.reasonId).toList(),
      status_id: studentReasonList.map((e) => e.status).toList(),
      student_id: studentReasonList.map((e) => e.studentId).toList(),
    );

    await saveDataOffline(formData);
    log(formData.toString());
    await ref.read(offlineControllerProvider.notifier).setData(5, formData);
    log(formData.toString());

    if (!mounted) return;
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text:
          'Day 5 attendance has been saved locally and will be stored when you get online!'
              .tr(),
      confirmBtnColor: AppColorConst.kappprimaryColorBlue,
      onConfirmBtnTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBar(
                    initialIndex: 1,
                  )),
          (route) => false, // This condition removes all routes from the stack
        );
      },
    );
  }

  submit6() async {
    var studentReasonList = ref.watch(studentReasonListProvider);

    // Submit attendance for day 1
    final currentDate = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final date = dateFormat.format(currentDate);
    final nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    final englishCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final nepaliCurrentDate =
        NepaliDateFormat('yyyy-MM-dd').format(nepaliDateTime);
    final devanagariDate = NepaliUnicode.convert(nepaliCurrentDate);

    final OfflineAttendanceModel formData = OfflineAttendanceModel(
      section_id: int.parse(what!.section_id.toString()),
      attendanceDateAd: date,
      school_id: int.parse(what!.school_id.toString()),
      attendanceDateBs: devanagariDate,
      teacher_id: int.parse(what!.teacher_id.toString()),
      attendanceDate: nepaliCurrentDate,
      classID: int.parse(what!.class_id.toString()),
      reason_id: studentReasonList.map((e) => e.reasonId).toList(),
      status_id: studentReasonList.map((e) => e.status).toList(),
      student_id: studentReasonList.map((e) => e.studentId).toList(),
    );

    await saveDataOffline(formData);
    log(formData.toString());
    await ref.read(offlineControllerProvider.notifier).setData(6, formData);
    log(formData.toString());

    if (!mounted) return;
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text:
          'Day 6 attendance has been saved locally and will be stored when you get online!'
              .tr(),
      confirmBtnColor: AppColorConst.kappprimaryColorBlue,
      onConfirmBtnTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
              builder: (context) => BottomBar(
                    initialIndex: 1,
                  )),
          (route) => false, // This condition removes all routes from the stack
        );
      },
    );
  }

  submit7() async {
    var studentReasonList = ref.watch(studentReasonListProvider);

    // Submit attendance for day 1
    final currentDate = DateTime.now();
    final dateFormat = DateFormat('yyyy-MM-dd');
    final date = dateFormat.format(currentDate);
    final nepaliDateTime = NepaliDateTime.fromDateTime(currentDate);
    final englishCurrentDate = DateFormat('yyyy-MM-dd').format(currentDate);
    final nepaliCurrentDate =
        NepaliDateFormat('yyyy-MM-dd').format(nepaliDateTime);
    final devanagariDate = NepaliUnicode.convert(nepaliCurrentDate);

    final OfflineAttendanceModel formData = OfflineAttendanceModel(
      section_id: int.parse(what!.section_id.toString()),
      attendanceDateAd: date,
      school_id: int.parse(what!.school_id.toString()),
      attendanceDateBs: devanagariDate,
      teacher_id: int.parse(what!.teacher_id.toString()),
      attendanceDate: nepaliCurrentDate,
      classID: int.parse(what!.class_id.toString()),
      reason_id: studentReasonList.map((e) => e.reasonId).toList(),
      status_id: studentReasonList.map((e) => e.status).toList(),
      student_id: studentReasonList.map((e) => e.studentId).toList(),
    );

    await saveDataOffline(formData);
    log(formData.toString());
    await ref.read(offlineControllerProvider.notifier).setData(7, formData);
    log(formData.toString());

    if (!mounted) return;
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      text:
          'Day 7 attendance has been saved locally and will be stored when you get online!'
              .tr(),
      confirmBtnColor: AppColorConst.kappprimaryColorBlue,
      onConfirmBtnTap: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => Dashboard()),
          (route) => false, // This condition removes all routes from the stack
        );
      },
    );
  }

  SharedPrefsData? sharedPrefsData;
  bool isLoading = true;

  void loadSharedPrefsData2() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    what = OfflineClassModel(
        school_id: prefs.getString('school_id').toString(),
        class_id: prefs.getString('class_id').toString(),
        class_name: prefs.getString('class_name').toString(),
        section_id: prefs.getString('section_id').toString(),
        section: prefs.getString('section').toString(),
        teacher_name: prefs.getString('teacher_name').toString(),
        teacher_id: prefs.getInt('teacher_id'));
    pop = PopulationModel(
        females: prefs.getString('females').toString(),
        males: prefs.getString('males').toString(),
        other: prefs.getString('other').toString(),
        total: prefs.getString('total').toString());
    stats = OfflineAttendanceReasonModel(
        id: prefs.getStringList('areason'), name: prefs.getStringList('id'));
    if (stats != null && stats!.id != null && stats!.name != null) {
      List<String>? id = stats!.id;
      List<String>? name = stats!.name;
      offabsent.add(OfflineAttendanceReasonModel(id: id, name: name));
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    isLoading = true;
    fetchAttendanceReasons();
    ispresent = true;
    status_id = [];
    student_id = [];
    reason_id = [];
    presentButtonSelected = false;
    absentButtonSelected = false;
    super.initState();
    loadSharedPrefsData();
    loadSharedPrefsData2();
  }

  bool getBoolValue(String stringValue) {
    return stringValue.toLowerCase() == 'true';
  }

  @override
  Widget build(BuildContext context) {
    var studentReasonList = ref.watch(studentReasonListProvider);
    var missedStudents = ref.watch(absentReasonMissingStudentsProvider);
    int index2 = idlist!.length;
    int indexing = index2 < idlist!.length ? index2 : 0;
    int hello = int.parse(idlist![indexing]);
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

    // final assingedClass = ref.watch(assignedClassDetailControllerProvider(
    //     ClassSectionParams(
    //         classId: int.parse(widget.e.class_id),
    //         sectionid: int.parse(widget.e.section_id))));
    // log(nepaliDate.toString());
    return Scaffold(
      floatingActionButton: currentDate.hour < 24
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
                            log(studentReasonList.length.toString());
                            log(studentname!.length.toString());
                            if (studentname?.length !=
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
                            }

                            var currentData = await ref
                                .read(offlineControllerProvider.notifier)
                                .getCurrentDataForDay(1);

                            var currentData1 = await ref
                                .read(offlineControllerProvider.notifier)
                                .getCurrentDataForDay(2);

                            var currentData2 = await ref
                                .read(offlineControllerProvider.notifier)
                                .getCurrentDataForDay(3);

                            var currentData3 = await ref
                                .read(offlineControllerProvider.notifier)
                                .getCurrentDataForDay(4);

                            var currentData4 = await ref
                                .read(offlineControllerProvider.notifier)
                                .getCurrentDataForDay(5);

                            var currentData5 = await ref
                                .read(offlineControllerProvider.notifier)
                                .getCurrentDataForDay(6);

                            var currentData6 = await ref
                                .read(offlineControllerProvider.notifier)
                                .getCurrentDataForDay(7);

                            log(currentData.toString());

                            if (currentData == null) {
                              log("Data for day 1 is null, submitting for day 1");
                              submit();
                            } else if (currentData1 == null) {
                              log("Data for day 2 is null, submitting for day 2");
                              submit2();
                            } else if (currentData2 == null) {
                              log("Data for day 3 is null, submitting for day 3");
                              submit3();
                            } else if (currentData3 == null) {
                              log("Data for day 4 is null, submitting for day 4");
                              submit4();
                            } else if (currentData4 == null) {
                              log("Data for day 5 is null, submitting for day 5");
                              submit5();
                            } else if (currentData5 == null) {
                              log("Data for day 6 is null, submitting for day 6");
                              submit6();
                            } else if (currentData6 == null) {
                              log("Data for day 7 is null, submitting for day 7");
                              submit7();
                            } else {
                              log("All data has been submitted");
                            }
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
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
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
                        "${what?.class_name} ${what?.section}",
                        style: TextStyle(
                            fontFamily: AppFont.kProductsanfont,
                            fontSize: AppDimensions.body_16,
                            fontWeight: AppDimensions.fontMedium),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "${"Total Students".tr()}: ${pop?.total}",
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
                            style:
                                TextStyle(fontFamily: AppFont.lProductsanfont),
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
                              Text("${"Boys".tr()}: ${pop?.males}"),
                              SizedBox(
                                height: 7,
                              ),
                              Text("${"Girls".tr()}: ${pop?.females}"),
                              SizedBox(
                                height: 7,
                              ),
                              Text("${"Others".tr()}: ${pop?.other}"),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Row(
                  //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                  //         "${"Teacher".tr()}: :${what?.teacher_name.toString()}"),
                  //     // Text("Attendace Status : Active")
                  //   ],
                  // ),
                ],
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.625,
              child: Container(
                decoration: BoxDecoration(
                  border: missedStudents.contains(studentroll)
                      ? Border.all(color: Colors.red)
                      : null,
                ),
                child: ListView.builder(
                    itemCount: studentname?.length,
                    itemBuilder: (context, index) {
                      dropdownValues.add("अन्य");
                      int rollIndex =
                          index < (studentroll?.length ?? 0) ? index : 0;
                      int valueIndex =
                          index < (stdValue?.length ?? 0) ? rollIndex : 0;
                      int idIndex =
                          index < (studentid?.length ?? 0) ? index : 0;
                      int findIndex =
                          index < (stdFind?.length ?? 0) ? index : 0;
                      bool value = getBoolValue(stdValue![valueIndex]);
                      bool find = getBoolValue(stdFind![findIndex]);

                      return Card(
                        elevation: 0.4,
                        color: Colors.white,
                        child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ListTile(
                                  title: Text(
                                    studentname![index].toString(),
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        color: Colors.grey.shade700),
                                  ),
                                  subtitle: Text(
                                      "${"Roll no".tr()}: ${studentroll?[rollIndex]}"),
                                ),
                                SizedBox(
                                  height: 4.0,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox.adaptive(
                                      fillColor: MaterialStateProperty.all(
                                          Colors.green),
                                      side: BorderSide(color: Colors.green),
                                      value: value,
                                      onChanged: (newValue) {
                                        setState(() {
                                          value = newValue!;
                                          find =
                                              false; // Uncheck the other checkbox
                                          stdValue?[valueIndex] =
                                              value.toString();
                                          stdFind?[findIndex] = find.toString();
                                          if (value) {
                                            final inputData =
                                                StudentReasonModel(
                                              status: 1,
                                              studentId: int.parse(
                                                studentid![idIndex].toString(),
                                              ),
                                            );
                                            List<int> studentIdList =
                                                studentReasonList
                                                    .map((e) => e.studentId)
                                                    .toList();
                                            if (studentIdList.contains(
                                                inputData.studentId)) {
                                              var prevData = studentReasonList
                                                  .where((element) =>
                                                      element.studentId ==
                                                      inputData.studentId)
                                                  .first;

                                              studentReasonList[
                                                  studentReasonList.indexOf(
                                                      prevData)] = inputData;
                                              ref
                                                  .watch(
                                                      studentReasonListProvider
                                                          .notifier)
                                                  .state = studentReasonList;
                                            } else {
                                              studentReasonList.add(inputData);
                                              ref
                                                  .watch(
                                                      studentReasonListProvider
                                                          .notifier)
                                                  .state = studentReasonList;
                                            }
                                            log(studentReasonList.toString());
                                          }
                                        });
                                      },
                                    ),
                                    Text('Present'.tr()),
                                    SizedBox(
                                      width: 8,
                                    ),
                                    Checkbox.adaptive(
                                      fillColor:
                                          MaterialStateProperty.all(Colors.red),
                                      side: BorderSide(color: Colors.red),
                                      value: find,
                                      onChanged: (newValue) {
                                        setState(() {
                                          find = newValue!;
                                          value =
                                              false; // Uncheck the other checkbox
                                          stdFind?[findIndex] = find.toString();
                                          stdValue?[valueIndex] =
                                              value.toString();
                                          if (find) {
                                            final inputData =
                                                StudentReasonModel(
                                              status: 0,
                                              studentId: int.parse(
                                                studentid![idIndex].toString(),
                                              ),
                                            );
                                            List<int> studentIdList =
                                                studentReasonList
                                                    .map((e) => e.studentId)
                                                    .toList();
                                            if (studentIdList.contains(
                                                inputData.studentId)) {
                                              var prevData = studentReasonList
                                                  .where((element) =>
                                                      element.studentId ==
                                                      inputData.studentId)
                                                  .first;

                                              studentReasonList[
                                                  studentReasonList.indexOf(
                                                      prevData)] = inputData;
                                              ref
                                                  .watch(
                                                      studentReasonListProvider
                                                          .notifier)
                                                  .state = studentReasonList;
                                            } else {
                                              studentReasonList.add(inputData);
                                              ref
                                                  .watch(
                                                      studentReasonListProvider
                                                          .notifier)
                                                  .state = studentReasonList;
                                            }
                                            log(studentReasonList.toString());
                                          }
                                        });
                                      },
                                    ),
                                    Text('Absent'.tr()),
                                  ],
                                ),
                                Visibility(
                                  visible: find,
                                  child: Wrap(
                                    spacing: 12,
                                    runSpacing: 6,
                                    children: List<Widget>.generate(
                                      idlist!.length,
                                      (int index) {
                                        String name = nreasonList![index];
                                        // Default to false if the index is not in selectedIndices
                                        int hello = int.parse(idlist![index]);
                                        return SizedBox(
                                          height: 40,
                                          child: ChoiceChip(
                                            onSelected: (bool isSelected) {
                                              setState(() {
                                                // Update the selected value in the dropdownValues list
                                                dropdownValues[idIndex] =
                                                    nreasonList![index];

                                                selectedReasonsMap[
                                                        studentid![idIndex]
                                                            .toString()] =
                                                    (isSelected
                                                        ? index
                                                        : null)!;

                                                if (isSelected) {
                                                  var missedStudents = ref.watch(
                                                      absentReasonMissingStudentsProvider);
                                                  if (missedStudents.contains(
                                                    studentid![idIndex]
                                                        .toString(),
                                                  )) {
                                                    missedStudents.remove(
                                                      studentid![idIndex]
                                                          .toString(),
                                                    );
                                                    ref
                                                        .watch(
                                                            absentReasonMissingStudentsProvider
                                                                .notifier)
                                                        .state = missedStudents;
                                                  }

                                                  final inputData =
                                                      StudentReasonModel(
                                                    status: 0,
                                                    studentId: int.parse(
                                                      studentid![idIndex]
                                                          .toString(),
                                                    ),
                                                    reasonId: isSelected
                                                        ? hello
                                                        : null,
                                                  );

                                                  List<int> studentIdList =
                                                      studentReasonList
                                                          .map((e) =>
                                                              e.studentId)
                                                          .toList();
                                                  if (studentIdList.contains(
                                                      inputData.studentId)) {
                                                    var prevData =
                                                        studentReasonList
                                                            .where((element) =>
                                                                element
                                                                    .studentId ==
                                                                inputData
                                                                    .studentId)
                                                            .first;

                                                    studentReasonList[
                                                            studentReasonList
                                                                .indexOf(
                                                                    prevData)] =
                                                        inputData;
                                                    ref
                                                        .watch(
                                                            studentReasonListProvider
                                                                .notifier)
                                                        .state = studentReasonList;
                                                  } else {
                                                    studentReasonList
                                                        .add(inputData);
                                                    ref
                                                        .watch(
                                                            studentReasonListProvider
                                                                .notifier)
                                                        .state = studentReasonList;
                                                  }
                                                } else {
                                                  final inputData =
                                                      StudentReasonModel(
                                                    status: 0,
                                                    studentId: int.parse(
                                                      studentid![idIndex]
                                                          .toString(),
                                                    ),
                                                    reasonId:
                                                        null, // Set the reasonId to null when not selected
                                                  );

                                                  var prevData =
                                                      studentReasonList
                                                          .where((element) =>
                                                              element
                                                                  .studentId ==
                                                              inputData
                                                                  .studentId)
                                                          .first;
                                                  if (prevData == inputData) {
                                                    var missedStudents = ref.watch(
                                                        absentReasonMissingStudentsProvider);
                                                    missedStudents.add(
                                                      studentid![idIndex]
                                                          .toString(),
                                                    );
                                                    ref
                                                        .watch(
                                                            absentReasonMissingStudentsProvider
                                                                .notifier)
                                                        .state = missedStudents;
                                                    studentReasonList[
                                                            studentReasonList
                                                                .indexOf(
                                                                    prevData)]
                                                        .reasonId = null;
                                                    ref
                                                        .watch(
                                                            studentReasonListProvider
                                                                .notifier)
                                                        .state = studentReasonList;
                                                  }
                                                }
                                              });
                                            },
                                            label: Text(name),
                                            selected: selectedReasonsMap[
                                                    studentid![idIndex]
                                                        .toString()] ==
                                                index,
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      );
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
