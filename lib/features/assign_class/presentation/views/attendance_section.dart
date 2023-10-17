// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/assign_class_studenslist_model/assign_class_students_list_model.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/attendance_reason/attendance_resons_model.dart';

import '../../../offline/offline_attendance/data/models/offline_reasons_model.dart';
import '../../data/models/assign_class_model/assign_class_model.dart';
import '../controller/attendance_reason_controller.dart';

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

class AttendanceSection extends ConsumerStatefulWidget {
  const AttendanceSection(
      {super.key, required this.student, required this.assignedClassModel});
  final StudentsList student;
  final AssignedClassModel assignedClassModel;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AttendanceSectionState();
}

class _AttendanceSectionState extends ConsumerState<AttendanceSection> {
  bool presentButtonSelected = false;
  bool absentButtonSelected = false;
  List<AttendanceReasonModel> presentReasons = [];
  List<AttendanceReasonModel> absentReasons = [];
  List<OfflineAttendanceReasonModel> offabsent = [];
  int selectedPresentReasonIndex = -1;
  int selectedAbsentReasonIndex = -1;
  List<String>? idlist;
  @override
  void initState() {
    presentButtonSelected = false;
    absentButtonSelected = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var studentReasonList = ref.watch(studentReasonListProvider);
    var missedStudents = ref.watch(absentReasonMissingStudentsProvider);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          border: missedStudents.contains(widget.student.studentId)
              ? Border.all(color: Colors.red)
              : null,
        ),
        child: Card(
          elevation: 0.4,
          color: Colors.white,
          child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.student.name,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Colors.grey.shade700),
                  ),
                  Text("${"Roll no".tr()} : ${widget.student.rollNumber}"),
                  SizedBox(
                    height: 4.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ref.watch(attendanceReasonControllerProvider(1)).when(
                            data: (present) {
                              presentReasons = present;
                              return Row(
                                children: [
                                  Checkbox.adaptive(
                                    fillColor:
                                        MaterialStateProperty.all(Colors.green),
                                    side: BorderSide(color: Colors.green),
                                    value: presentButtonSelected,
                                    onChanged: (value) {
                                      setState(() {
                                        presentButtonSelected = value!;
                                        selectedAbsentReasonIndex = -1;
                                        // studentReasonList.remove(studentReasonList[studentReasonList.indexOf()]);

                                        if (value) {
                                          absentButtonSelected = !value;
                                          final inputData = StudentReasonModel(
                                            status: 1,
                                            studentId: int.parse(
                                                widget.student.studentId),
                                          );
                                          List<int> studentIdList =
                                              studentReasonList
                                                  .map((e) => e.studentId)
                                                  .toList();
                                          if (studentIdList
                                              .contains(inputData.studentId)) {
                                            var prevData = studentReasonList
                                                .where((element) =>
                                                    element.studentId ==
                                                    inputData.studentId)
                                                .first;

                                            studentReasonList[studentReasonList
                                                .indexOf(prevData)] = inputData;
                                            ref
                                                .watch(studentReasonListProvider
                                                    .notifier)
                                                .state = studentReasonList;
                                          } else {
                                            studentReasonList.add(inputData);
                                            ref
                                                .watch(studentReasonListProvider
                                                    .notifier)
                                                .state = studentReasonList;
                                          }
                                        }
                                      });
                                    },
                                  ),
                                  Text("Present".tr())
                                ],
                              );
                            },
                            error: (err, s) => Text(err.toString()),
                            loading: () => Center(),
                          ),
                      SizedBox(
                        width: 8,
                      ),
                      ref.watch(attendanceReasonControllerProvider(0)).when(
                          data: (absent) {
                            absentReasons = absent;
                            return Row(
                              children: [
                                Checkbox.adaptive(
                                  fillColor:
                                      MaterialStateProperty.all(Colors.red),
                                  side: BorderSide(color: Colors.red),
                                  value: absentButtonSelected,
                                  onChanged: (value) {
                                    setState(() {
                                      absentButtonSelected = value!;
                                      selectedPresentReasonIndex = -1;
                                      if (value) {
                                        presentButtonSelected = !value;
                                        final inputData = StudentReasonModel(
                                          status: 0,
                                          studentId: int.parse(
                                              widget.student.studentId),
                                        );
                                        List<int> studentIdList =
                                            studentReasonList
                                                .map((e) => e.studentId)
                                                .toList();
                                        if (studentIdList
                                            .contains(inputData.studentId)) {
                                          var prevData = studentReasonList
                                              .where((element) =>
                                                  element.studentId ==
                                                  inputData.studentId)
                                              .first;

                                          studentReasonList[studentReasonList
                                              .indexOf(prevData)] = inputData;
                                          ref
                                              .watch(studentReasonListProvider
                                                  .notifier)
                                              .state = studentReasonList;
                                        } else {
                                          studentReasonList.add(inputData);
                                          ref
                                              .watch(studentReasonListProvider
                                                  .notifier)
                                              .state = studentReasonList;
                                        }
                                      }
                                    });
                                  },
                                ),
                                Text("Absent".tr())
                              ],
                            );
                          },
                          error: (err, s) => Text(err.toString()),
                          loading: () => Center()),
                    ],
                  ),
                  if (absentButtonSelected)
                    Wrap(
                      spacing: 12,
                      runSpacing: 6,
                      children: [
                        ...absentReasons.map((e) {
                          List<String> reasonList =
                              absentReasons.map((e) => e.name).toList();

                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setStringList('areason', reasonList);
                          });
                          final studentlistvalue =
                              absentReasons.map((item) => item.id).toList();
                          SharedPreferences.getInstance().then((prefs) {
                            prefs.setStringList(
                                'id',
                                studentlistvalue
                                    .map((value) => value.toString())
                                    .toList()); // Convert bool list to string list
                          });

// Logging the reasonList
                          log(reasonList.toString());
                          log(studentlistvalue.toString());

                          return SizedBox(
                            height: 40,
                            child: ChoiceChip(
                              onSelected: (value) {
                                if (value) {
                                  var missedStudents = ref.watch(
                                      absentReasonMissingStudentsProvider);
                                  if (missedStudents
                                      .contains(widget.student.studentId)) {
                                    missedStudents
                                        .remove(widget.student.studentId);
                                    ref
                                        .watch(
                                            absentReasonMissingStudentsProvider
                                                .notifier)
                                        .state = missedStudents;
                                  }
                                  final inputData = StudentReasonModel(
                                      status: 0,
                                      studentId:
                                          int.parse(widget.student.studentId),
                                      reasonId: absentReasons[
                                              absentReasons.indexOf(e)]
                                          .id);
                                  List<int> studentIdList = studentReasonList
                                      .map((e) => e.studentId)
                                      .toList();
                                  if (studentIdList
                                      .contains(inputData.studentId)) {
                                    var prevData = studentReasonList
                                        .where((element) =>
                                            element.studentId ==
                                            inputData.studentId)
                                        .first;

                                    studentReasonList[studentReasonList
                                        .indexOf(prevData)] = inputData;
                                    ref
                                        .watch(
                                            studentReasonListProvider.notifier)
                                        .state = studentReasonList;
                                  } else {
                                    studentReasonList.add(inputData);
                                    ref
                                        .watch(
                                            studentReasonListProvider.notifier)
                                        .state = studentReasonList;
                                  }

                                  setState(() {
                                    selectedAbsentReasonIndex =
                                        absentReasons.indexOf(e);
                                  });
                                }
                                if (!value) {
                                  final inputData = StudentReasonModel(
                                      status: 0,
                                      studentId:
                                          int.parse(widget.student.studentId),
                                      reasonId: absentReasons[
                                              absentReasons.indexOf(e)]
                                          .id);

                                  var prevData = studentReasonList
                                      .where((element) =>
                                          element.studentId ==
                                          inputData.studentId)
                                      .first;
                                  if (prevData == inputData) {
                                    missedStudents
                                        .add(widget.student.studentId);
                                    ref
                                        .watch(
                                            absentReasonMissingStudentsProvider
                                                .notifier)
                                        .state = missedStudents;
                                    studentReasonList[
                                            studentReasonList.indexOf(prevData)]
                                        .reasonId = null;

                                    ref
                                        .watch(
                                            studentReasonListProvider.notifier)
                                        .state = studentReasonList;
                                  }
                                  setState(() {
                                    selectedAbsentReasonIndex = -1;
                                  });
                                }
                              },
                              label: Text(e.name),
                              selected: (absentReasons.indexOf(e) ==
                                  selectedAbsentReasonIndex),
                            ),
                          );
                        }),
                      ],
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
