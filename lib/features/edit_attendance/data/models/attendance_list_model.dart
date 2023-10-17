// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AttendanceListModel {
  final List<Attendance> attendList;

  AttendanceListModel({
    required this.attendList,
  });

  AttendanceListModel copyWith({
    List<Attendance>? attendList,
  }) {
    return AttendanceListModel(
      attendList: attendList ?? this.attendList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'data': attendList.map((x) => x.toMap()).toList(),
    };
  }

  factory AttendanceListModel.fromMap(Map<String, dynamic> json) {
    return AttendanceListModel(
        attendList:
            List.from(json["data"]).map((e) => Attendance.fromMap(e)).toList());
  }

  String toJson() => json.encode(toMap());

  factory AttendanceListModel.fromJson(String source) =>
      AttendanceListModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AttendanceListModel( studentsList: $attendList)';

  @override
  bool operator ==(covariant AttendanceListModel other) {
    if (identical(this, other)) return true;

    return listEquals(other.attendList, attendList);
  }

  @override
  int get hashCode => attendList.hashCode;
}

class Attendance {
  int id;
  String class_id;
  String attendance_date;
  String attendance_date_bs;
  String attendance_date_ad;
  String? reason_id;
  String section_id;
  String school_id;
  String teacher_id;
  String student_id;
  String status;
  Attendance({
    required this.id,
    required this.class_id,
    required this.attendance_date,
    required this.attendance_date_bs,
    required this.attendance_date_ad,
    required this.reason_id,
    required this.section_id,
    required this.school_id,
    required this.teacher_id,
    required this.student_id,
    required this.status,
  });

  Attendance copyWith({
    int? id,
    String? class_id,
    String? attendance_date,
    String? attendance_date_bs,
    String? attendance_date_ad,
    String? reason_id,
    String? section_id,
    String? school_id,
    String? teacher_id,
    String? student_id,
    String? status,
  }) {
    return Attendance(
      id: id ?? this.id,
      class_id: class_id ?? this.class_id,
      attendance_date: attendance_date ?? this.attendance_date,
      attendance_date_bs: attendance_date_bs ?? this.attendance_date_bs,
      attendance_date_ad: attendance_date_ad ?? this.attendance_date_ad,
      reason_id: reason_id ?? this.reason_id,
      section_id: section_id ?? this.section_id,
      school_id: school_id ?? this.school_id,
      teacher_id: teacher_id ?? this.teacher_id,
      student_id: student_id ?? this.student_id,
      status: status ?? this.status,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'class_id': class_id,
      'attendance_date': attendance_date,
      'attendance_date_bs': attendance_date_bs,
      'attendance_date_ad': attendance_date_ad,
      'reason_id': reason_id,
      'section_id': section_id,
      'school_id': school_id,
      'teacher_id': teacher_id,
      'student_id': student_id,
      'status': status,
    };
  }

  factory Attendance.fromMap(Map<String, dynamic> map) {
    return Attendance(
      id: map['id'] as int,
      class_id: map['class_id'] as String,
      attendance_date: map['attendance_date'] as String,
      attendance_date_bs: map['attendance_date_bs'] as String,
      attendance_date_ad: map['attendance_date_ad'] as String,
      reason_id: map['reason_id'] != null ? map['reason_id'] as String : null,
      section_id: map['section_id'] as String,
      school_id: map['school_id'] as String,
      teacher_id: map['teacher_id'] as String,
      student_id: map['student_id'] as String,
      status: map['status'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory Attendance.fromJson(String source) =>
      Attendance.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AttendanceList(id: $id, class_id: $class_id, attendance_date: $attendance_date, attendance_date_bs: $attendance_date_bs, attendance_date_ad: $attendance_date_ad, reason_id: $reason_id, section_id: $section_id, school_id: $school_id, teacher_id: $teacher_id, student_id: $student_id, status: $status)';
  }

  @override
  bool operator ==(covariant Attendance other) {
    if (identical(this, other)) return true;

    return other.id == id &&
        other.class_id == class_id &&
        other.attendance_date == attendance_date &&
        other.attendance_date_bs == attendance_date_bs &&
        other.attendance_date_ad == attendance_date_ad &&
        other.reason_id == reason_id &&
        other.section_id == section_id &&
        other.school_id == school_id &&
        other.teacher_id == teacher_id &&
        other.student_id == student_id &&
        other.status == status;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        class_id.hashCode ^
        attendance_date.hashCode ^
        attendance_date_bs.hashCode ^
        attendance_date_ad.hashCode ^
        reason_id.hashCode ^
        section_id.hashCode ^
        school_id.hashCode ^
        teacher_id.hashCode ^
        student_id.hashCode ^
        status.hashCode;
  }
}
