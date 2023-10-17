// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AttendanceRankingModel {
  final String studentName;
  final String totalPresent;
  final String rollNumber;
  AttendanceRankingModel({
    required this.studentName,
    required this.totalPresent,
    required this.rollNumber,
  });

  AttendanceRankingModel copyWith({
    String? studentName,
    String? totalPresent,
    String? rollNumber,
  }) {
    return AttendanceRankingModel(
      studentName: studentName ?? this.studentName,
      totalPresent: totalPresent ?? this.totalPresent,
      rollNumber: rollNumber ?? this.rollNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'studentName': studentName,
      'totalPresent': totalPresent,
      'rollNumber': rollNumber,
    };
  }

  factory AttendanceRankingModel.fromMap(Map<String, dynamic> map) {
    return AttendanceRankingModel(
      studentName: map['student']['name'].toString() ?? "",
      totalPresent: map['total_present'].toString() ?? "",
      rollNumber:
          map['student']['student_admission']['roll_no'].toString() ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceRankingModel.fromJson(String source) =>
      AttendanceRankingModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AttendanceRankingModel(studentName: $studentName, totalPresent: $totalPresent, rollNumber: $rollNumber)';

  @override
  bool operator ==(covariant AttendanceRankingModel other) {
    if (identical(this, other)) return true;

    return other.studentName == studentName &&
        other.totalPresent == totalPresent &&
        other.rollNumber == rollNumber;
  }

  @override
  int get hashCode =>
      studentName.hashCode ^ totalPresent.hashCode ^ rollNumber.hashCode;
}
