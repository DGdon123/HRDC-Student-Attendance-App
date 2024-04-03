// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:developer';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quickalert/quickalert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:ym_daa_toce/commons/custom_button.dart';
import 'package:ym_daa_toce/commons/custom_form.dart';
import 'package:ym_daa_toce/const/app_colors_const.dart';
import 'package:ym_daa_toce/const/app_const.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/const/app_images_const.dart';
import 'package:ym_daa_toce/core/local_auth/local_auth_api.dart';
import 'package:ym_daa_toce/features/auth/data/models/login_model/login_request_model.dart';
import 'package:ym_daa_toce/features/auth/presentation/forgot_password/viesws/forgot_password_screen.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/controllers/auth_controller.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/controllers/auth_helper_controller.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';
import 'package:ym_daa_toce/utils/form_validation/form_validation_extension.dart';
import 'package:ym_daa_toce/utils/keyboard_dismiss/keyboard_dimiss_extension.dart';
import 'package:ym_daa_toce/utils/mediaquery_extention.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:logger/logger.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  late TextEditingController emailController;
  late TextEditingController passwordController;
  final GlobalKey<FormState> loginSignKey = GlobalKey<FormState>();

  @override
  void initState() {
    emailController = TextEditingController();
    passwordController = TextEditingController();

    super.initState();
  }

  var logger = Logger(
    printer: PrettyPrinter(),
  );
  String? email;
  String? password;
  String? token;
  bool free = false;
  @override
  void dispose() {
    emailController.clear();
    passwordController.clear();

    super.dispose();
  }

  void Function()? toogleObcure() {
    ref
        .read(loginscreenPasswordObscureProvider.notifier)
        .update((state) => !state);
    return null;
  }

  void Function()? toogleUserProfessional() {
    ref.read(isUserProvider.notifier).update((state) => !state);
    return null;
  }

  fingerprintLogin() async {
    email = await SessionManager().get('email1');
    password = await SessionManager().get('password1');
    token = await SessionManager().get('device_token');

    // Check if any of the values is null or empty
    if (email == null ||
        password == null ||
        token == null ||
        email!.isEmpty ||
        password!.isEmpty ||
        token!.isEmpty) {
      QuickAlert.show(
        context: context,
        type: QuickAlertType.error,
        title: 'Error...',
        confirmBtnColor: AppColorConst.kappprimaryColorBlue,
        text: 'You must first log in with your email and password',
      );
      return;
    }

    LoginRequestModel loginRequestModel = LoginRequestModel(
      email: email.toString(),
      password: password.toString(),
      device_token: token.toString(),
    );

    ref.read(loginloadingProvider.notifier).update((state) => true);

    await ref
        .read(authControllerProvider.notifier)
        .login(loginRequestModel, context);

    ref.read(loginloadingProvider.notifier).update((state) => false);
  }

  appLogin() async {
    final deviceToken = await FirebaseMessaging.instance.getToken();
    LoginRequestModel loginRequestModel = LoginRequestModel(
        email: emailController.text,
        password: passwordController.text,
        device_token: deviceToken!);
    var sessionManager = SessionManager();
    await sessionManager.set("email1", emailController.text);
    await sessionManager.set("password1", passwordController.text);
    await sessionManager.set("device_token", deviceToken);

    if (loginSignKey.currentState!.validate()) {
      ref.read(loginloadingProvider.notifier).update((state) => true);
      await ref
          .read(authControllerProvider.notifier)
          .login(loginRequestModel, context);
    }

    ref.read(loginloadingProvider.notifier).update((state) => false);
    setState(() {
      free = true;
    });
    // normalNav(context, const AssignClassScreen());
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
        statusBarColor: AppColorConst.kappprimaryColorBlue));
    // final isuser = ref.watch(isUserProvider);
    final passwordObcure = ref.watch(loginscreenPasswordObscureProvider);
    return GestureDetector(
      onTap: context.dismissKeyboard,
      child: Scaffold(
        backgroundColor: const Color(0xffF9F9FC),
        body: Form(
          key: loginSignKey,
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: 18, vertical: context.heightPct(0.138)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // const AspectRatio(aspectRatio: 2, child: Placeholder()),
                  AspectRatio(
                    aspectRatio: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(AppImagesConst.appLogo),
                    ),
                  ),

                  CustomAppForm(
                    readOnly: false,
                    textEditingController: emailController,
                    isPrefixIconrequired: true,
                    prefixIcon: CupertinoIcons.envelope,
                    lable: AppConst.kemail,
                    validator: (input) => input!.isValidEmail(input),
                  ),
                  CustomAppForm(
                    readOnly: false,
                    obscureText: passwordObcure,
                    textEditingController: passwordController,
                    isPrefixIconrequired: true,
                    prefixIcon: CupertinoIcons.lock,
                    lable: AppConst.kpassword,
                    sufixWidget: IconButton(
                        onPressed: toogleObcure,
                        icon: Icon(passwordObcure
                            ? CupertinoIcons.eye_slash
                            : CupertinoIcons.eye)),
                    textInputAction: TextInputAction.done,
                    validator: (input) => input!.isPasswordValid(input),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 10.0, bottom: 20),
                      child: InkWell(
                        onTap: () =>
                            normalNav(context, const ForgotPasswordScreen()),
                        child: Text(
                          AppConst.kforgotPassword,
                          style: const TextStyle(
                              fontSize: 12,
                              fontFamily: AppFont.kProductsanfont,
                              color: CupertinoColors.darkBackgroundGray),
                        ),
                      ),
                    ),
                  ),

                  // ref.watch(loginloadingProvider)
                  //     ? CircularProgressIndicator.adaptive()
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
                      onPressed: () => appLogin(),
                      child: ref.watch(loginloadingProvider)
                          ? CircularProgressIndicator.adaptive(
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                Colors.white, //<-- SEE HERE
                              ),
                              backgroundColor:
                                  AppColorConst.kappprimaryColorBlue,
                            )
                          : Text(
                              AppConst.kLogin,
                              style: TextStyle(
                                  color: AppColorConst.kappWhiteColor),
                            ))
                  //  CustomAppButton(
                  //     label: AppConst.kLogin, onPressed: () => appLogin()),

                  ,
                  if (free = true)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: CustomAppButton(
                          isLable: false,
                          bottonBgColor: Colors.white,
                          label: "User biometric",
                          lableColor: AppColorConst.kappprimaryColorBlue,
                          onPressed: () async {
                            final isAuthenticated =
                                await LocalAuthApi.authenticate();

                            if (isAuthenticated) {
                              fingerprintLogin();
                            }
                          }),
                    ),
                  SizedBox(
                    height: context.heightPct(0.12),
                  ),
                  // RichTextWidget(
                  //   firstText: AppConst.kdontHaveAccount,
                  //   secondText: AppConst.kcreateAccount,
                  //   onTap: () => normalNav(context, const SignUpScreen()),
                  // )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class UsertypeCard extends StatelessWidget {
  const UsertypeCard(
      {super.key,
      required this.onTap,
      required this.lable,
      required this.isMember});
  final Function()? onTap;
  final String lable;
  final bool isMember;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        width: 100,
        height: 40,
        decoration: BoxDecoration(
            color: isMember
                ? AppColorConst.kappsecondaryColorYellow
                : const Color(0xffF1F1F1),
            borderRadius: BorderRadius.circular(4)),
        child: Text(
          lable,
          style: TextStyle(
              fontFamily: AppFont.kProductsanfont,
              color: isMember ? Colors.white : Colors.grey),
        ),
      ),
    );
  }
}

class HeaderText extends StatelessWidget {
  const HeaderText({super.key, required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontSize: 14,
          fontWeight: FontWeight.normal,
          color: const Color(0xff0D1F3A)),
    );
  }
}
