// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class OfflineAttendanceModel {
  final int? classID;
  final String? attendanceDate;
  final String? attendanceDateAd;
  final String? attendanceDateBs;
  final int? school_id;
  final int? teacher_id;
  final int? section_id;
  final List<int> student_id;
  final List<int?> reason_id;
  final List<int> status_id;

  OfflineAttendanceModel({
    this.classID,
    this.attendanceDate,
    this.attendanceDateAd,
    this.attendanceDateBs,
    this.school_id,
    this.teacher_id,
    this.section_id,
    required this.student_id,
    required this.reason_id,
    required this.status_id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'classID': classID,
      'attendanceDate': attendanceDate,
      'attendanceDateAd': attendanceDateAd,
      'attendanceDateBs': attendanceDateBs,
      'school_id': school_id,
      'teacher_id': teacher_id,
      'section_id': section_id,
      'student_id': student_id,
      'reason_id': reason_id,
      'status_id': status_id,
    };
  }

  factory OfflineAttendanceModel.fromMap(Map<String, dynamic> map) {
    return OfflineAttendanceModel(
      classID: map['classID'] != null ? map['classID'] as int : null,
      attendanceDate: map['attendanceDate'] != null
          ? map['attendanceDate'] as String
          : null,
      attendanceDateAd: map['attendanceDateAd'] != null
          ? map['attendanceDateAd'] as String
          : null,
      attendanceDateBs: map['attendanceDateBs'] != null
          ? map['attendanceDateBs'] as String
          : null,
      school_id: map['school_id'] != null ? map['school_id'] as int : null,
      teacher_id: map['teacher_id'] != null ? map['teacher_id'] as int : null,
      section_id: map['section_id'] != null ? map['section_id'] as int : null,
      student_id: map['student_id'] != null
          ? List<int>.from(map['student_id'] as List<dynamic>)
          : [],
      reason_id: map['reason_id'] != null
          ? (map['reason_id'] as List<dynamic>)
              .map((item) => item as int?)
              .toList()
          : [null],
      status_id: map['status_id'] != null
          ? List<int>.from(map['status_id'] as List<dynamic>)
          : [],
    );
  }
  FormData toFormData() {
    final formData = FormData();

    formData.fields.addAll([
      MapEntry('class_id', classID.toString()),
      MapEntry('attendance_date', attendanceDate.toString()),
      MapEntry('attendance_date_ad', attendanceDateAd.toString()),
      MapEntry('attendance_date_bs', attendanceDateBs.toString()),
      MapEntry('school_id', school_id.toString()),
      MapEntry('teacher_id', teacher_id.toString()),
      MapEntry('section_id', section_id.toString()),
      // Add other fields if needed...
    ]);

    // Add lists as FormData fields
    for (int i = 0; i < student_id.length; i++) {
      formData.fields.add(MapEntry('student_id[$i]', student_id[i].toString()));
      if (reason_id[i] != null) {
        formData.fields.add(MapEntry('reason_id[$i]', reason_id[i].toString()));
      }
      formData.fields.add(MapEntry('status[$i]', status_id[i].toString()));
    }

    return formData;
  }

  String toJson() => json.encode(toMap());

  factory OfflineAttendanceModel.fromJson(String source) =>
      OfflineAttendanceModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'OfflineAttendanceModel(classID: $classID, attendanceDate: $attendanceDate, attendanceDateAd: $attendanceDateAd, attendanceDateBs: $attendanceDateBs, school_id: $school_id, teacher_id: $teacher_id, section_id: $section_id, student_id: $student_id, reason_id: $reason_id, status_id: $status_id)';
  }

  @override
  bool operator ==(covariant OfflineAttendanceModel other) {
    if (identical(this, other)) return true;

    return other.classID == classID &&
        other.attendanceDate == attendanceDate &&
        other.attendanceDateAd == attendanceDateAd &&
        other.attendanceDateBs == attendanceDateBs &&
        other.school_id == school_id &&
        other.teacher_id == teacher_id &&
        other.section_id == section_id &&
        listEquals(other.student_id, student_id) &&
        listEquals(other.reason_id, reason_id) &&
        listEquals(other.status_id, status_id);
  }

  @override
  int get hashCode {
    return classID.hashCode ^
        attendanceDate.hashCode ^
        attendanceDateAd.hashCode ^
        attendanceDateBs.hashCode ^
        school_id.hashCode ^
        teacher_id.hashCode ^
        section_id.hashCode ^
        student_id.hashCode ^
        reason_id.hashCode ^
        status_id.hashCode;
  }
}
