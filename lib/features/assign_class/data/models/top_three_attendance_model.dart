// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class TopThreeAttendanceModel {
  final String attendanceDateAd;
  final String totalAbsent;
  final String totalPresent;
  TopThreeAttendanceModel({
    required this.attendanceDateAd,
    required this.totalAbsent,
    required this.totalPresent,
  });

  TopThreeAttendanceModel copyWith({
    String? attendanceDateAd,
    String? totalAbsent,
    String? totalPresent,
  }) {
    return TopThreeAttendanceModel(
      attendanceDateAd: attendanceDateAd ?? this.attendanceDateAd,
      totalAbsent: totalAbsent ?? this.totalAbsent,
      totalPresent: totalPresent ?? this.totalPresent,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'attendanceDateAd': attendanceDateAd,
      'totalAbsent': totalAbsent,
      'totalPresent': totalPresent,
    };
  }

  factory TopThreeAttendanceModel.fromMap(Map<String, dynamic> map) {
    return TopThreeAttendanceModel(
      attendanceDateAd: map['attendance_date_ad'] ?? '',
      totalAbsent: map['total_absent'] ?? '',
      totalPresent: map['total_present'] ?? '',
    );
  }

  String toJson() => json.encode(toMap());

  factory TopThreeAttendanceModel.fromJson(String source) =>
      TopThreeAttendanceModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TopThreeAttendanceModel(attendanceDateAd: $attendanceDateAd, totalAbsent: $totalAbsent, totalPresent: $totalPresent)';

  @override
  bool operator ==(covariant TopThreeAttendanceModel other) {
    if (identical(this, other)) return true;

    return other.attendanceDateAd == attendanceDateAd &&
        other.totalAbsent == totalAbsent &&
        other.totalPresent == totalPresent;
  }

  @override
  int get hashCode =>
      attendanceDateAd.hashCode ^ totalAbsent.hashCode ^ totalPresent.hashCode;
}
