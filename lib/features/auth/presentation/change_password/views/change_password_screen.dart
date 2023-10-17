import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/commons/custom_form.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_dimension.dart';
import 'package:ym_daa_toce/features/auth/data/models/change_password_model.dart/change_password_request_model.dart';
import 'package:ym_daa_toce/features/auth/presentation/change_password/controller/change_password_controller.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/controllers/auth_helper_controller.dart';
import 'package:ym_daa_toce/utils/form_validation/form_validation_extension.dart';
import 'package:ym_daa_toce/utils/keyboard_dismiss/keyboard_dimiss_extension.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';
import 'package:easy_localization/easy_localization.dart';

class ChangePasswordScreen extends ConsumerStatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends ConsumerState<ChangePasswordScreen> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPassworController;
  late TextEditingController newPasswordConfirmController;
  late bool isPasswordsvisible;
  late bool isConfirmPasswordvisible;
  late bool isOldPasswordvisible;
  @override
  void initState() {
    isOldPasswordvisible = true;
    isPasswordsvisible = true;
    isConfirmPasswordvisible = true;
    oldPasswordController = TextEditingController();
    newPassworController = TextEditingController();
    newPasswordConfirmController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    oldPasswordController = TextEditingController();
    newPassworController = TextEditingController();
    newPasswordConfirmController = TextEditingController();
    super.dispose();
  }

  toogleNewPassword() {
    setState(() {});
    isPasswordsvisible = !isPasswordsvisible;
  }

  toogleOldPassword() {
    setState(() {});
    isOldPasswordvisible = !isOldPasswordvisible;
  }

  toogleConfirmPasswordVisibility() {
    setState(() {});
    isConfirmPasswordvisible = !isConfirmPasswordvisible;
  }

  final formKey = GlobalKey<FormState>();

  changePassword() async {
    if (formKey.currentState!.validate()) {
      ChangePasswordRequestModel changePasswordRequestModel =
          ChangePasswordRequestModel(
              currentPassword: oldPasswordController.text.trim(),
              newPassword: newPassworController.text.trim(),
              confirmNewPassword: newPasswordConfirmController.text.trim());
      ref.read(changePasswordLoading.notifier).update((state) => true);
      await ref.read(changePasswordControllerProvider.notifier).changePassword(
          context: context,
          changePasswordRequestModel: changePasswordRequestModel);
      ref.read(changePasswordLoading.notifier).update((state) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: context.dismissKeyboard,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Change Password".tr()),
        ),
        body: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: context.widthPct(0.02),
              vertical: context.heightPct(0.010)),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                CustomAppForm(readOnly: false,
                    textEditingController: oldPasswordController,
                    obscureText: isOldPasswordvisible,
                    sufixWidget: IconButton(
                        onPressed: toogleOldPassword,
                        icon: Icon(
                          isOldPasswordvisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 16,
                        )),
                    lable: "Please enter the old password".tr(),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) => value!.oldPasswordValid(value)),
                CustomAppForm(readOnly: false,
                    textEditingController: newPassworController,
                    obscureText: isPasswordsvisible,
                    sufixWidget: IconButton(
                        onPressed: toogleNewPassword,
                        icon: Icon(
                          isPasswordsvisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 16,
                        )),
                    lable: "Please enter the new password".tr(),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) => value!.isPasswordValid(value)),
                CustomAppForm(readOnly: false,
                    textEditingController: newPasswordConfirmController,
                    obscureText: isConfirmPasswordvisible,
                    sufixWidget: IconButton(
                        onPressed: toogleConfirmPasswordVisibility,
                        icon: Icon(
                          isConfirmPasswordvisible
                              ? Icons.visibility_off
                              : Icons.visibility,
                          size: 16,
                        )),
                    lable: "Confirm Password".tr(),
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    validator: (value) => value!.confirmPasswordValidation(
                        value, newPassworController.text)),
                SizedBox(
                  height: AppDimensions.paddingSMALL,
                ),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: ContinuousRectangleBorder(
                          side: const BorderSide(
                              width: 0.8,
                              color: AppColorConst.kappprimaryColorBlue),
                          borderRadius: BorderRadius.circular(8)),
                      backgroundColor: AppColorConst.kappprimaryColorBlue,
                      elevation: 0,
                      fixedSize: Size(context.widthPct(1), 45),
                    ),
                    onPressed: () => changePassword(),
                    child: ref.watch(changePasswordLoading)
                        ? CircularProgressIndicator.adaptive(
                            valueColor: const AlwaysStoppedAnimation<Color>(
                              Colors.white, //<-- SEE HERE
                            ),
                            backgroundColor: AppColorConst.kappprimaryColorBlue,
                          )
                        : Text(
                            "Update".tr(),
                            style:
                                TextStyle(color: AppColorConst.kappWhiteColor),
                          ))
                // CustomAppButton(
                //   label: AppConst.kUpdate,
                //   onPressed: () => changePassword(),
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
