import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ym_daa_toce/commons/custom_button.dart';
import 'package:ym_daa_toce/commons/custom_form.dart';
import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_images_const.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/presentation/views/login_screen.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';
import 'package:ym_daa_toce/utils/form_validation/form_validation_extension.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';

class CreateNewPasswordScreen extends StatefulWidget {
  const CreateNewPasswordScreen({super.key});

  @override
  State<CreateNewPasswordScreen> createState() =>
      _CreateNewPasswordScreenState();
}

class _CreateNewPasswordScreenState extends State<CreateNewPasswordScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;

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
                  child: Image.asset(AppImagesConst.klockerImage),
                ),
                SizedBox(
                  height: context.heightPct(0.07),
                ),
                const HeaderText(
                  title: "Create New Password",
                ),
                SizedBox(
                  height: context.heightPct(0.02),
                ),
                CustomAppForm(readOnly: false,
                  textEditingController: emailController,
                  lable: "OTP Code",
                  validator: (input) => input!.isValidEmail(input),
                ),
                CustomAppForm(readOnly: false,
                  textEditingController: emailController,
                  isPrefixIconrequired: true,
                  prefixIcon: CupertinoIcons.lock,
                  lable: AppConst.kpassword,
                  validator: (input) => input!.isValidEmail(input),
                ),
                CustomAppForm(readOnly: false,
                  textEditingController: emailController,
                  isPrefixIconrequired: true,
                  prefixIcon: CupertinoIcons.lock,
                  lable: AppConst.kcofirmPassword,
                  validator: (input) => input!.isValidEmail(input),
                ),
                SizedBox(
                  height: context.heightPct(0.02),
                ),
                CustomAppButton(
                  label: "Create",
                  onPressed: () {},
                  // onPressed: () => normalNav(context, const Dashboard()),
                ),
                SizedBox(
                  height: context.heightPct(0.1),
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
