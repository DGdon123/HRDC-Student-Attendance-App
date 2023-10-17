import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/assign_class_studenslist_model/class_section_params_model.dart';

import '../../data/models/attendance_list_model.dart';
import '../../data/repository/edit_attendance_repo.dart';

class AttendanceListController
    extends StateNotifier<AsyncValue<AttendanceListModel>> {
  final EditAttendanceRepo assignedClassRepository;
  final ClassSectionParams classSectionModel;
  AttendanceListController(
      {required this.assignedClassRepository, required this.classSectionModel})
      : super(AsyncValue.loading()) {
    getAttendanceList();
  }
  getAttendanceList() async {
    final result =
        await assignedClassRepository.getAttendanceListRepo(classSectionModel);
    return result.fold(
        (l) => state =
            AsyncValue.error(l.message, StackTrace.fromString(l.message)),
        (r) => state = AsyncValue.data(r));
  }
}

final attendancelistControllerProvider = StateNotifierProvider.family
    .autoDispose<AttendanceListController, AsyncValue<AttendanceListModel>,
        ClassSectionParams>((ref, classectionModel) {
  return AttendanceListController(
      assignedClassRepository: ref.read(editrepoProvider),
      classSectionModel: classectionModel);
});
