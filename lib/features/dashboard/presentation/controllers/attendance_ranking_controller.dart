// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_const/api_const.dart';
import 'package:ym_daa_toce/core/api_exception/dio_exception.dart';
import 'package:ym_daa_toce/features/dashboard/data/models/attendance_ranking_model.dart';

import '../../../../core/api_client/api_client.dart';

class AttendanceRankParams {
  final int classId;
  final int teacherId;
  AttendanceRankParams({
    required this.classId,
    required this.teacherId,
  });

  AttendanceRankParams copyWith({
    int? classId,
    int? teacherId,
  }) {
    return AttendanceRankParams(
      classId: classId ?? this.classId,
      teacherId: teacherId ?? this.teacherId,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'classId': classId,
      'teacherId': teacherId,
    };
  }

  factory AttendanceRankParams.fromMap(Map<String, dynamic> map) {
    return AttendanceRankParams(
      classId: map['classId'] as int,
      teacherId: map['teacherId'] as int,
    );
  }

  String toJson() => json.encode(toMap());

  factory AttendanceRankParams.fromJson(String source) =>
      AttendanceRankParams.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() =>
      'AttendanceRankParams(classId: $classId, teacherId: $teacherId)';

  @override
  bool operator ==(covariant AttendanceRankParams other) {
    if (identical(this, other)) return true;

    return other.classId == classId && other.teacherId == teacherId;
  }

  @override
  int get hashCode => classId.hashCode ^ teacherId.hashCode;
}

class AttendanceRankingController
    extends StateNotifier<AsyncValue<List<AttendanceRankingModel>>> {
  AttendanceRankingController(this._apiClient, this.params)
      : super(AsyncValue.loading()) {
    getData();
  }

  final ApiClient _apiClient;
  final AttendanceRankParams params;
  getData() async {
    try {
      final result = await _apiClient.request(
          path: ApiConst.kHighestLowest +
              "/" +
              params.classId.toString() +
              "/" +
              params.teacherId.toString());
      final List<AttendanceRankingModel> data = List.from(result['data'])
          .map((e) => AttendanceRankingModel.fromMap(e))
          .toList();
      state = AsyncValue.data(data);
    } on DioException catch (e) {
      state = AsyncValue.error(e.message!, StackTrace.fromString(e.message!));
    }
  }
}

final attendanceRankingControllerProvider = StateNotifierProvider.family
    .autoDispose<
        AttendanceRankingController,
        AsyncValue<List<AttendanceRankingModel>>,
        AttendanceRankParams>((ref, params) {
  return AttendanceRankingController(ref.read(apiClientProvider), params);
});
