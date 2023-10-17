import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../utils/custom_navigation/app_nav.dart';
import '../../../../utils/custom_snack_bar/custom_snack_bar.dart';
import '../../../assign_class/data/models/assign_class_studenslist_model/class_section_params_model.dart';
import '../../../dashboard/presentation/views/dashboard.dart';
import '../../data/models/edit_attendance_response_model.dart';
import '../../data/repository/edit_attendance_repo.dart';

class EditAttendanceController
    extends StateNotifier<AsyncValue<EditStoreAttendanceResponseModel>> {
  final EditAttendanceRepo editClassRepository;
  final ClassSectionParams classSectionModel;
  EditAttendanceController(
      {required this.editClassRepository, required this.classSectionModel})
      : super(AsyncValue.loading());

  editAttendance(
      {required BuildContext context,
      required Map<String, dynamic> FormData}) async {
    final result =
        await editClassRepository.editrepo(classSectionModel, FormData);
    return result.fold((l) {
      showCustomSnackBar(l.message, context, isError: true);
      state = AsyncValue.error(l, StackTrace.fromString(l.message));
    }, (r) async {
      state = AsyncValue.data(r);
      if (context.mounted) {
        showCustomSnackBar(r.message, context, isError: false);
        pushAndRemoveUntil(context, const Dashboard());
      }
    });
  }
}

final editstoreAttendanceControllerProvider = StateNotifierProvider.family
    .autoDispose<
        EditAttendanceController,
        AsyncValue<EditStoreAttendanceResponseModel>,
        ClassSectionParams>((ref, classectionModel) {
  return EditAttendanceController(
      editClassRepository: ref.read(editrepoProvider),
      classSectionModel: classectionModel);
});
