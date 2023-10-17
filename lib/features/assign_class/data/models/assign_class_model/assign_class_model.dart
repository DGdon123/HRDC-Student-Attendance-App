import 'dart:convert';

// ignore_for_file: public_member_api_docs, sort_constructors_first

class AssignedClassModel {
  String school_id;
  String class_id;
  String class_name;
  String section_id;
  String section;
  String teacher_name;
  String teacher_id;
  AssignedClassModel(
      {required this.school_id,
      required this.class_id,
      required this.class_name,
      required this.section_id,
      required this.section,
      required this.teacher_name,
      required this.teacher_id});

  AssignedClassModel copyWith(
      {String? school_id,
      String? class_id,
      String? class_name,
      String? section_id,
      String? section,
      String? teacher_name,
      String? teacher_id}) {
    return AssignedClassModel(
        school_id: school_id ?? this.school_id,
        class_id: class_id ?? this.class_id,
        class_name: class_name ?? this.class_name,
        section_id: section_id ?? this.section_id,
        section: section ?? this.section,
        teacher_name: teacher_name ?? this.teacher_name,
        teacher_id: teacher_id ?? this.teacher_id);
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'school_id': school_id,
      'class_id': class_id,
      'class_name': class_name,
      'section_id': section_id,
      'section': section,
      'teacher_name': teacher_name,
      "teacher_id": teacher_id
    };
  }

  factory AssignedClassModel.fromMap(Map<String, dynamic> map) {
    return AssignedClassModel(
        school_id: map['school_id'].toString() ?? "",
        class_id: map['class_id'].toString() ?? "",
        class_name: map['class_name'].toString() ?? "",
        section_id: map['section_id'].toString() ?? "",
        section: map['section'].toString() ?? "",
        teacher_name: map['teacher_name'].toString() ?? "",
        teacher_id: map["teacher_id"].toString() ?? "");
  }

  String toJson() => json.encode(toMap());

  factory AssignedClassModel.fromJson(String source) =>
      AssignedClassModel.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'AssignedClassModel(school_id: $school_id, class_id: $class_id, class_name: $class_name, section_id: $section_id, section: $section,teacher_id:$teacher_id, teacher_name: $teacher_name)';
  }

  @override
  bool operator ==(covariant AssignedClassModel other) {
    if (identical(this, other)) return true;

    return other.school_id == school_id &&
        other.class_id == class_id &&
        other.class_name == class_name &&
        other.section_id == section_id &&
        other.section == section &&
        other.teacher_id == teacher_id &&
        other.teacher_name == teacher_name;
  }

  @override
  int get hashCode {
    return school_id.hashCode ^
        class_id.hashCode ^
        class_name.hashCode ^
        section_id.hashCode ^
        section.hashCode ^
        teacher_id.hashCode ^
        teacher_name.hashCode;
  }
}
