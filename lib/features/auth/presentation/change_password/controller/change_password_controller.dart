import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/features/auth/data/models/change_password_model.dart/change_password_request_model.dart';
import 'package:ym_daa_toce/features/auth/data/models/change_password_model.dart/change_password_response_model.dart';
import 'package:ym_daa_toce/features/auth/data/repositories/auth_respository.dart';
import 'package:ym_daa_toce/features/dashboard/presentation/views/dashboard.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';
import 'package:ym_daa_toce/utils/custom_snack_bar/custom_snack_bar.dart';

class ChangePasswordController
    extends StateNotifier<AsyncValue<ChangePasswordResponseModel>> {
  final AuthRepository authRepository;
  ChangePasswordController({required this.authRepository})
      : super(AsyncValue.loading());

  changePassword(
      {required BuildContext context,
      required ChangePasswordRequestModel changePasswordRequestModel}) async {
    final result =
        await authRepository.changePasswordRepo(changePasswordRequestModel);
    return result.fold((l) {
      showCustomSnackBar(l.message, context);
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

final changePasswordControllerProvider = StateNotifierProvider.autoDispose<
    ChangePasswordController, AsyncValue<ChangePasswordResponseModel>>((ref) {
  return ChangePasswordController(
      authRepository: ref.read(authRepositoryProvider));
});
