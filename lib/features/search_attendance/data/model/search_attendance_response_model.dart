// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class SearchResponseModel {
  List<StudentDataModel> data;
  Count count;

  SearchResponseModel({
    required this.data,
    required this.count,
  });

  factory SearchResponseModel.fromJson(Map<String, dynamic> json) =>
      SearchResponseModel(
        data: List.from(json["data"])
            .map((e) => StudentDataModel.fromJson(e))
            .toList(),
        count: Count.fromMap(json["count"]),
      );
}

class StudentDataModel {
  int studentId;
  String name;
  int rollNo;
  String attendanceStatus;

  StudentDataModel({
    required this.studentId,
    required this.name,
    required this.rollNo,
    required this.attendanceStatus,
  });

  factory StudentDataModel.fromJson(Map<String, dynamic> json) =>
      StudentDataModel(
        studentId: json["student_id"] ?? "",
        name: json["name"] ?? "",
        rollNo: json["roll_no"] ?? "",
        attendanceStatus: json["attendance_status"] ?? "",
      );
}

class Count {
  int present;
  int absent;
  int totalMales;
  int totalFamales;
  int totalOthers;

  Count(
      {required this.present,
      required this.absent,
      required this.totalMales,
      required this.totalFamales,
      required this.totalOthers});

  Count copyWith({
    int? present,
    int? absent,
    int? totalMales,
    int? totalFamales,
    int? totalOthers,
  }) {
    return Count(
      present: present ?? this.present,
      absent: absent ?? this.absent,
      totalMales: totalMales ?? this.totalMales,
      totalFamales: totalFamales ?? this.totalFamales,
      totalOthers: totalOthers ?? this.totalOthers,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'present': present,
      'absent': absent,
      'totalMales': totalMales,
      'totalFamales': totalFamales,
      'totalOthers': totalOthers,
    };
  }

  factory Count.fromMap(Map<String, dynamic> map) {
    return Count(
      present: map['present'] ?? 0,
      absent: map['absent'] ?? 0,
      totalMales: map['total_males'] ?? 0,
      totalFamales: map['total_females'] ?? 0,
      totalOthers: map['total_others'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory Count.fromJson(String source) =>
      Count.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Count(present: $present, absent: $absent, totalMales: $totalMales, totalFamales: $totalFamales, totalOthers: $totalOthers)';
  }

  @override
  bool operator ==(covariant Count other) {
    if (identical(this, other)) return true;

    return other.present == present &&
        other.absent == absent &&
        other.totalMales == totalMales &&
        other.totalFamales == totalFamales &&
        other.totalOthers == totalOthers;
  }

  @override
  int get hashCode {
    return present.hashCode ^
        absent.hashCode ^
        totalMales.hashCode ^
        totalFamales.hashCode ^
        totalOthers.hashCode;
  }
}

class SearchParam {
  final String searechClass;
  final String section;
  final String searchData;

  SearchParam(
    this.searechClass,
    this.section,
    this.searchData,
  );

  SearchParam copyWith({
    String? searechClass,
    String? section,
    String? searchData,
  }) {
    return SearchParam(
      searechClass ?? this.searechClass,
      section ?? this.section,
      searchData ?? this.searchData,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'searechClass': searechClass,
      'section': section,
      'searchData': searchData,
    };
  }

  factory SearchParam.fromMap(Map<String, dynamic> map) {
    return SearchParam(
      map['searechClass'] as String,
      map['section'] as String,
      map['searchData'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory SearchParam.fromJson(String source) =>
      SearchParam.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'SearchParam(searechClass: $searechClass, section: $section, searchData: $searchData)';

  @override
  bool operator ==(covariant SearchParam other) {
    if (identical(this, other)) return true;

    return other.searechClass == searechClass &&
        other.section == section &&
        other.searchData == searchData;
  }

  @override
  int get hashCode =>
      searechClass.hashCode ^ section.hashCode ^ searchData.hashCode;
}
