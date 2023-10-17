import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ym_daa_toce/commons/custom_button.dart';
import 'package:ym_daa_toce/commons/custom_form.dart';
import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_images_const.dart';
import 'package:ym_daa_toce/features/auth/presentation/forgot_password/viesws/create_new_password_screen.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/presentation/views/login_screen.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';
import 'package:ym_daa_toce/utils/form_validation/form_validation_extension.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

import '../../login/models/fingerprint_login_model.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  FingerPrintLoginModel? login2;
  @override
  void initState() {
    emailController = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    emailController.clear();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF9F9FC),
      // appBar: AppBar(
      //   elevation: 0,
      //   title: const Text("Forgot Password"),
      //   backgroundColor: Colors.white,
      // ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: context.heightPct(0.1),
                ),
                AspectRatio(
                  aspectRatio: 3,
                  child: Image.asset(AppImagesConst.kmailBoxImage),
                ),
                SizedBox(
                  height: context.heightPct(0.07),
                ),
                HeaderText(
                  title: AppConst.kforgotPasswordUserMessage,
                ),
                SizedBox(
                  height: context.heightPct(0.02),
                ),
                CustomAppForm(readOnly: false,
                  textEditingController: emailController,
                  isPrefixIconrequired: true,
                  prefixIcon: CupertinoIcons.envelope,
                  lable: AppConst.kemail,
                  validator: (input) => input!.isValidEmail(input),
                ),
                SizedBox(
                  height: context.heightPct(0.02),
                ),
                CustomAppButton(
                    label: AppConst.ksend,
                    onPressed: () async {
                      normalNav(context, const CreateNewPasswordScreen());
                    }),
                SizedBox(
                  height: context.heightPct(0.3),
                ),
                TextButton(
                    onPressed: () => normalNav(
                        context,
                        const LoginScreen(
                        
                        )),
                    child: const Text(
                      "Back to Login Screen",
                      style: TextStyle(
                          color: CupertinoColors.systemGrey,
                          fontWeight: FontWeight.w600),
                    ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
