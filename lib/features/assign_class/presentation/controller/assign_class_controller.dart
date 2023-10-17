import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/assign_class_model/assign_class_model.dart';
import 'package:ym_daa_toce/features/assign_class/data/repository/assigned_class_repository.dart';

class AssignedClassController
    extends StateNotifier<AsyncValue<AssignedClassModel>> {
  final AssignedClassRepository assignedClassRepository;
  AssignedClassController(this.assignedClassRepository)
      : super(AsyncValue.loading()) {
    getProfileC();
  }
  getProfileC() async {
    final result = await assignedClassRepository.getAssignedClassRepo();
    return result.fold(
        (l) => state =
            AsyncValue.error(l.message, StackTrace.fromString(l.message)),
        (r) => state = AsyncValue.data(r));
  }
}

final assignedClassControllerProvider = StateNotifierProvider.autoDispose<
    AssignedClassController, AsyncValue<AssignedClassModel>>((ref) {
  return AssignedClassController(ref.read(assignedClassRepositoryProvider));
});
