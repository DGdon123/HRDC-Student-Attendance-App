// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter/foundation.dart';

class AssignClassStudentModel {
  final Count scount;
  final List<StudentsList> studentsList;
  bool attendaceStatus;
  AssignClassStudentModel(
      {required this.scount,
      required this.studentsList,
      this.attendaceStatus = false});

  AssignClassStudentModel copyWith({
    Count? scount,
    List<StudentsList>? studentsList,
  }) {
    return AssignClassStudentModel(
      scount: scount ?? this.scount,
      studentsList: studentsList ?? this.studentsList,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'count': scount.toMap(),
      'data': studentsList.map((x) => x.toMap()).toList(),
    };
  }

  factory AssignClassStudentModel.fromMap(Map<String, dynamic> json) {
    return AssignClassStudentModel(
        scount: Count.fromMap(json['count']),
        studentsList: List.from(json["data"])
            .map((e) => StudentsList.fromMap(e))
            .toList());
  }

  String toJson() => json.encode(toMap());

  factory AssignClassStudentModel.fromJson(String source) =>
      AssignClassStudentModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AssignClassStudentModel(scount: $scount, studentsList: $studentsList)';

  @override
  bool operator ==(covariant AssignClassStudentModel other) {
    if (identical(this, other)) return true;

    return other.scount == scount &&
        listEquals(other.studentsList, studentsList);
  }

  @override
  int get hashCode => scount.hashCode ^ studentsList.hashCode;
}

class Count {
  String totalStudents;
  String totalMales;
  String totalFemales;
  String totalOthers;
  Count({
    required this.totalStudents,
    required this.totalMales,
    required this.totalFemales,
    required this.totalOthers,
  });

  Count copyWith({
    String? totalStudents,
    String? totalMales,
    String? totalFemales,
    String? totalOthers,
  }) {
    return Count(
      totalStudents: totalStudents ?? this.totalStudents,
      totalMales: totalMales ?? this.totalMales,
      totalFemales: totalFemales ?? this.totalFemales,
      totalOthers: totalOthers ?? this.totalOthers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'total_students': totalStudents,
      'total_males': totalMales,
      'total_females': totalFemales,
      'total_others': totalOthers,
    };
  }

  factory Count.fromMap(Map<String, dynamic> map) {
    return Count(
      totalStudents: map['total_students'].toString() ?? "",
      totalMales: map['total_males'].toString() ?? "",
      totalFemales: map['total_females'].toString() ?? "",
      totalOthers: map['total_others'].toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory Count.fromJson(String source) =>
      Count.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Count(totalStudents: $totalStudents, totalMales: $totalMales, totalFemales: $totalFemales, totalOthers: $totalOthers)';
  }

  @override
  bool operator ==(covariant Count other) {
    if (identical(this, other)) return true;

    return other.totalStudents == totalStudents &&
        other.totalMales == totalMales &&
        other.totalFemales == totalFemales &&
        other.totalOthers == totalOthers;
  }

  @override
  int get hashCode {
    return totalStudents.hashCode ^
        totalMales.hashCode ^
        totalFemales.hashCode ^
        totalOthers.hashCode;
  }
}

class StudentsList {
  final int studentId;
  final String name;
  final String gender;
  final String section;
  final int rollNumber;
  final int status;
  bool value;
  bool find;
  StudentsList(
      {required this.studentId,
      required this.name,
      required this.gender,
      required this.section,
      required this.rollNumber,
      required this.status,
      this.value = false,
      this.find = false});

  StudentsList copyWith({
    int? studentId,
    String? name,
    String? gender,
    int? status,
    String? section,
    int? rollNumber,
  }) {
    return StudentsList(
      studentId: studentId ?? this.studentId,
      name: name ?? this.name,
      gender: gender ?? this.gender,
      section: section ?? this.section,
      status: status ?? this.status,
      rollNumber: rollNumber ?? this.rollNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'student_id': studentId,
      'name': name,
      'gender': gender,
      'section': section,
      'attendance_status': status
    };
  }

  factory StudentsList.fromMap(Map<String, dynamic> map) {
    return StudentsList(
        studentId: map['student_id'] ?? "",
        status: map['attendance_status'] ?? "",
        name: map['name'] ?? "",
        gender: map['gender'] ?? "",
        section: map['section'] ?? "",
        rollNumber: map['roll_no'] ?? "");
  }

  String toJson() => json.encode(toMap());

  factory StudentsList.fromJson(String source) =>
      StudentsList.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'StudentsList(studentId: $studentId, name: $name, gender: $gender, section: $section, attendance_status: $status)';
  }

  @override
  bool operator ==(covariant StudentsList other) {
    if (identical(this, other)) return true;

    return other.studentId == studentId &&
        other.name == name &&
        other.gender == gender &&
        other.status == status &&
        other.section == section;
  }

  @override
  int get hashCode {
    return studentId.hashCode ^
        name.hashCode ^
        gender.hashCode ^
        status.hashCode ^
        section.hashCode;
  }
}
