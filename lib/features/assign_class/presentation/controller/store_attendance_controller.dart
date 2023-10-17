import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/features/dashboard/presentation/views/dashboard.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';
import 'package:ym_daa_toce/utils/custom_snack_bar/custom_snack_bar.dart';

import '../../data/models/store_model/store_attendence_res_model.dart';
import '../../data/repository/assigned_class_repository.dart';

class StoreAttendanceController
    extends StateNotifier<AsyncValue<StoreAttendanceResponseModel>> {
  final AssignedClassRepository assignedClassRepository;
  StoreAttendanceController({required this.assignedClassRepository})
      : super(AsyncValue.loading());

  storeAttendance(
      {required BuildContext context, required FormData FormData}) async {
    final result = await assignedClassRepository.storeAttendenceRepo(FormData);
    log(result.toString());
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

final storeAttendanceControllerProvider = StateNotifierProvider.autoDispose<
    StoreAttendanceController, AsyncValue<StoreAttendanceResponseModel>>((ref) {
  return StoreAttendanceController(
      assignedClassRepository: ref.read(assignedClassRepositoryProvider));
});
