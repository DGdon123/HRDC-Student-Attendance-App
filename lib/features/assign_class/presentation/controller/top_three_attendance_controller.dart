// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/features/assign_class/data/repository/assigned_class_repository.dart';

import '../../data/models/top_three_attendance_model.dart';

class TopThreeParams {
  final String classNum;
  final String sectionNum;
  TopThreeParams({
    required this.classNum,
    required this.sectionNum,
  });

  TopThreeParams copyWith({
    String? classNum,
    String? sectionNum,
  }) {
    return TopThreeParams(
      classNum: classNum ?? this.classNum,
      sectionNum: sectionNum ?? this.sectionNum,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'classNum': classNum,
      'sectionNum': sectionNum,
    };
  }

  factory TopThreeParams.fromMap(Map<String, dynamic> map) {
    return TopThreeParams(
      classNum: map['classNum'] as String,
      sectionNum: map['sectionNum'] as String,
    );
  }

  String toJson() => json.encode(toMap());

  factory TopThreeParams.fromJson(String source) =>
      TopThreeParams.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'TopThreeParams(classNum: $classNum, sectionNum: $sectionNum)';

  @override
  bool operator ==(covariant TopThreeParams other) {
    if (identical(this, other)) return true;

    return other.classNum == classNum && other.sectionNum == sectionNum;
  }

  @override
  int get hashCode => classNum.hashCode ^ sectionNum.hashCode;
}

class TopThreeAttendanceController
    extends StateNotifier<AsyncValue<List<TopThreeAttendanceModel>>> {
  final AssignedClassRepository repository;
  TopThreeAttendanceController(this.repository, this.params)
      : super(AsyncValue.loading()) {
    getData();
  }
  final TopThreeParams params;
  getData() async {
    final result = await repository.getTopThreeAttendance(
        params.classNum, params.sectionNum);
    return result.fold(
        (l) => state =
            AsyncValue.error(l.message, StackTrace.fromString(l.message)),
        (r) => state = AsyncValue.data(r));
  }
}

final topThreeAttendanceControllerProvider = StateNotifierProvider.family
    .autoDispose<
        TopThreeAttendanceController,
        AsyncValue<List<TopThreeAttendanceModel>>,
        TopThreeParams>((ref, params) {
  return TopThreeAttendanceController(
      ref.read(assignedClassRepositoryProvider), params);
});
