// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class AttendanceReasonModel {
  final int id;
  final String name;
  AttendanceReasonModel({
    required this.id,
    required this.name,
  });

  AttendanceReasonModel copyWith({
    int? id,
    String? name,
  }) {
    return AttendanceReasonModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
    };
  }

  factory AttendanceReasonModel.fromMap(Map<String, dynamic> map) {
    return AttendanceReasonModel(
      id: map['id'] ?? 0,
      name: map['name'] ?? "",
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceReasonModel.fromJson(String source) =>
      AttendanceReasonModel.fromMap(
          json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'AttendanceReasonModel(id: $id, name: $name)';

  @override
  bool operator ==(covariant AttendanceReasonModel other) {
    if (identical(this, other)) return true;

    return other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
