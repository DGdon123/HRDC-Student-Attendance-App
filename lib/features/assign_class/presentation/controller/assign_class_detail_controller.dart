import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/assign_class_studenslist_model/class_section_params_model.dart';
import 'package:ym_daa_toce/features/assign_class/data/repository/assigned_class_repository.dart';

import '../../data/models/assign_class_studenslist_model/assign_class_students_list_model.dart';

class AssignClassDetailController
    extends StateNotifier<AsyncValue<AssignClassStudentModel>> {
  final AssignedClassRepository assignedClassRepository;
  final ClassSectionParams classSectionModel;
  AssignClassDetailController(
      {required this.assignedClassRepository, required this.classSectionModel})
      : super(AsyncValue.loading()) {
    getAssignedClassDetail();
  }
  getAssignedClassDetail() async {
    final result = await assignedClassRepository
        .getAssignedClassDetailRepo(classSectionModel);
    return result.fold(
        (l) => state =
            AsyncValue.error(l.message, StackTrace.fromString(l.message)),
        (r) => state = AsyncValue.data(r));
  }
}

final assignedClassDetailControllerProvider = StateNotifierProvider.family
    .autoDispose<
        AssignClassDetailController,
        AsyncValue<AssignClassStudentModel>,
        ClassSectionParams>((ref, classectionModel) {
  return AssignClassDetailController(
      assignedClassRepository: ref.read(assignedClassRepositoryProvider),
      classSectionModel: classectionModel);
});
