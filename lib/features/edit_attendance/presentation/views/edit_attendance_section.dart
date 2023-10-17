// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'dart:convert';
import 'dart:developer';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';

import 'package:ym_daa_toce/features/assign_class/data/models/assign_class_studenslist_model/assign_class_students_list_model.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/attendance_reason/attendance_resons_model.dart';

import '../../../assign_class/data/models/assign_class_model/assign_class_model.dart';
import '../../../assign_class/presentation/controller/attendance_reason_controller.dart';
import '../../data/models/attendance_list_model.dart';

final absentReasonMissingStudentsProvider = StateProvider<List<String>>((ref) {
  return [];
});

var editstudentReasonListProvider =
    StateProvider<List<EditStudentReasonModel>>((ref) {
  return [];
});

class EditStudentReasonModel {
  final int studentId;
  int? reasonId;
  int status;
  String text;
  EditStudentReasonModel({
    required this.studentId,
    this.reasonId,
    required this.status,
    required this.text,
  });

  EditStudentReasonModel copyWith(
      {int? studentId, int? reasonId, int? status, String? text}) {
    return EditStudentReasonModel(
        studentId: studentId ?? this.studentId,
        reasonId: reasonId ?? this.reasonId,
        status: status ?? this.status,
        text: text ?? this.text);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'student_id': studentId,
      'reason_id': reasonId,
      'status': status,
      'text': text
    };
  }

  factory EditStudentReasonModel.fromMap(Map<String, dynamic> map) {
    return EditStudentReasonModel(
      studentId: map['student_id'] as int,
      reasonId: map['reason_id'] != null ? map['reason_id'] as int : null,
      status: map['status'] as int,
      text: map['text'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory EditStudentReasonModel.fromJson(String source) =>
      EditStudentReasonModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'EditStudentReasonModel(student_id: $studentId, reason_id: $reasonId, status: $status, text: $text)';

  @override
  bool operator ==(covariant EditStudentReasonModel other) {
    if (identical(this, other)) return true;

    return other.studentId == studentId &&
        other.reasonId == reasonId &&
        other.status == status &&
        other.text == text;
  }

  @override
  int get hashCode =>
      studentId.hashCode ^ reasonId.hashCode ^ status.hashCode ^ text.hashCode;
}

class EditAttendanceSection extends ConsumerStatefulWidget {
  const EditAttendanceSection({
    required this.student,
    required this.assignedClassModel,
    required this.reasons,
  });

  final StudentsList student;
  final AssignedClassModel assignedClassModel;
  final AttendanceListModel? reasons;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _AttendanceSectionState();
}

class _AttendanceSectionState extends ConsumerState<EditAttendanceSection> {
  bool presentButtonSelected = false;
  bool absentButtonSelected = false;
  List<AttendanceReasonModel> presentReasons = [];
  List<AttendanceReasonModel> absentReasons = [];
  int selectedPresentReasonIndex = -1;
  int firstAttendanceStatus = 1;
  int secondAttendanceStatus = 0;
  int selectedAbsentReasonIndex = -1;
  @override
  void initState() {
    super.initState();
    // Update the loop to set the selected indices
    if (widget.reasons!.attendList.isNotEmpty) {
      // Initialize the flags to false
      presentButtonSelected = false;
      absentButtonSelected = false;

      // Loop through the attendList to check student status
      for (var student in widget.reasons!.attendList) {
        if (widget.student.studentId == student.student_id) {
          if (student.status == "0") {
            absentButtonSelected = true;
            selectedAbsentReasonIndex = int.parse(student.reason_id.toString());
            break; // Stop looping once Absent status is found
          } else if (student.status == "1") {
            presentButtonSelected = true;
            break; // Stop looping once Present status is found
          }
        }
      }
    }
  }

  void updateStudentReasonList(EditStudentReasonModel inputData) {
    var studentReasonList = ref.watch(editstudentReasonListProvider);
    final index = studentReasonList.indexWhere(
      (model) => model.studentId == inputData.studentId,
    );

    if (index != -1) {
      studentReasonList[index] = inputData;
    }

    ref.watch(editstudentReasonListProvider.notifier).state = studentReasonList;
    log(studentReasonList.toString());
  }

  bool isDataAdded = false;
  @override
  Widget build(BuildContext context) {
    var studentReasonList = ref.watch(editstudentReasonListProvider);
    var missedStudents = ref.watch(absentReasonMissingStudentsProvider);

    if (!isDataAdded && widget.reasons!.attendList.isNotEmpty) {
      for (var student in widget.reasons!.attendList) {
        if (widget.student.studentId == student.student_id) {
          if (student.status == "1") {
            final inputData = EditStudentReasonModel(
              text: "Present",
              status: 1,
              studentId: int.parse(widget.student.studentId),
            );

            List<int> studentIdList =
                studentReasonList.map((e) => e.studentId).toList();
            if (studentIdList.contains(inputData.studentId)) {
              var prevData = studentReasonList
                  .where((element) => element.studentId == inputData.studentId)
                  .first;
              studentReasonList[studentReasonList.indexOf(prevData)] =
                  inputData;
              ref.watch(editstudentReasonListProvider.notifier).state =
                  studentReasonList;
            } else {
              studentReasonList.add(inputData);
              ref.watch(editstudentReasonListProvider.notifier).state =
                  studentReasonList;
            }
            isDataAdded = true; // Set the flag to true
            break; // Stop looping once Absent status is found
          } else if (student.status == "0") {
            final inputData2 = EditStudentReasonModel(
              text: "Absent",
              status: 0,
              reasonId: int.parse(student.reason_id.toString()),
              studentId: int.parse(widget.student.studentId),
            );
            List<int> studentIdList =
                studentReasonList.map((e) => e.studentId).toList();
            if (studentIdList.contains(inputData2.studentId)) {
              var prevData = studentReasonList
                  .where((element) => element.studentId == inputData2.studentId)
                  .first;
              studentReasonList[studentReasonList.indexOf(prevData)] =
                  inputData2;
              ref.watch(editstudentReasonListProvider.notifier).state =
                  studentReasonList;
            } else {
              studentReasonList.add(inputData2);
              ref.watch(editstudentReasonListProvider.notifier).state =
                  studentReasonList;
            }
            isDataAdded = true; // Set the flag to true
            break; // Stop looping once Present status is found
          }
        }
      }
    }

    log(studentReasonList.toString());
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

                                        if (value) {
                                          absentButtonSelected = !value;
                                          // Create/EditStudentReasonModel with status 1 (Present)
                                          final inputData =
                                              EditStudentReasonModel(
                                            text: "Present",
                                            status: 1,
                                            studentId: int.parse(
                                                widget.student.studentId),
                                          );
                                          // Update the existing item's status and text
                                          // Use the current studentReasonList from the context
                                          // Find the student in the list
                                          updateStudentReasonList(inputData);
                                        }
                                      });
                                    },
                                  ),
                                  Text("Present".tr()),
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
                                          final inputData =
                                              EditStudentReasonModel(
                                            text: "Absent",
                                            status: 0,
                                            studentId: int.parse(
                                                widget.student.studentId),
                                          );

                                          // Update the existing item's status and text
                                          // Use the current studentReasonList from the context
                                          // Find the student in the list
                                          updateStudentReasonList(inputData);
                                        }
                                      });
                                    }),
                                Text("Absent".tr()),
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
                        ...absentReasons.map(
                          (e) => SizedBox(
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
                                  final inputData = EditStudentReasonModel(
                                      text: "Absent",
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
                                        .watch(editstudentReasonListProvider
                                            .notifier)
                                        .state = studentReasonList;

                                    log(studentReasonList.toString());

// Update the provider state
                                  } else {
                                    studentReasonList.add(inputData);
                                    ref.watch(
                                        editstudentReasonListProvider.notifier);
                                  }

                                  setState(() {
                                    selectedAbsentReasonIndex =
                                        absentReasons.indexOf(e);
                                  });
                                }
                                if (!value) {
                                  final inputData = EditStudentReasonModel(
                                      text: "Absent",
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
                                        .watch(editstudentReasonListProvider
                                            .notifier)
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
                          ),
                        ),
                      ],
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
