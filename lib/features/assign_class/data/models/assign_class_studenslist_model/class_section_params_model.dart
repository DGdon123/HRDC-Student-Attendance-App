// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

class ClassSectionParams {
  final int classId;
  final int sectionid;
  ClassSectionParams({
    required this.classId,
    required this.sectionid,
  });

  ClassSectionParams copyWith({
    int? classId,
    int? sectionid,
  }) {
    return ClassSectionParams(
      classId: classId ?? this.classId,
      sectionid: sectionid ?? this.sectionid,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'classId': classId,
      'sectionid': sectionid,
    };
  }

  factory ClassSectionParams.fromMap(Map<String, dynamic> map) {
    return ClassSectionParams(
      classId: map['classId'] as int,
      sectionid: map['sectionid'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory ClassSectionParams.fromJson(String source) => ClassSectionParams.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() => 'ClassSectionParams(classId: $classId, sectionid: $sectionid)';

  @override
  bool operator ==(covariant ClassSectionParams other) {
    if (identical(this, other)) return true;
  
    return 
      other.classId == classId &&
      other.sectionid == sectionid;
  }

  @override
  int get hashCode => classId.hashCode ^ sectionid.hashCode;
}
