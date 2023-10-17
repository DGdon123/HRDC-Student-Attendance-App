import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_exception/dio_exception.dart';

import '../../data/data_source/assign_class_data_source.dart';
import '../../data/models/attendance_reason/attendance_resons_model.dart';

final attendanceReasonControllerProvider = StateNotifierProvider.family
    .autoDispose<AttendanceReasonController,
        AsyncValue<List<AttendanceReasonModel>>, int>((ref, id) {
  return AttendanceReasonController(
      ref.read(assignedClassDataSourceProvider), id);
});

class AttendanceReasonController
    extends StateNotifier<AsyncValue<List<AttendanceReasonModel>>> {
  AttendanceReasonController(this.dataSource, this.id)
      : super(AsyncValue.loading()) {
    fetchData();
  }

  final AssignedClassDataSource dataSource;
  final int id;

  fetchData() async {
    try {
      final result = await dataSource.getAttendanceStatusList(id);
      state = AsyncValue.data(result);
    } on DioException catch (e) {
      state = AsyncValue.error(
        e.message!,
        StackTrace.fromString(e.message!),
      );
    }
  }
}
