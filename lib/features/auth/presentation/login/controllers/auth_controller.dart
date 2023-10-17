import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ym_daa_toce/const/app_fonts.dart';
import 'package:ym_daa_toce/core/db_client.dart';
import 'package:ym_daa_toce/features/auth/data/models/login_model/login_reponse_model.dart';
import 'package:ym_daa_toce/features/auth/data/models/login_model/login_request_model.dart';
import 'package:ym_daa_toce/features/auth/data/repositories/auth_respository.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/controllers/auth_state.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/models/fingerprint_login_model.dart';
import 'package:ym_daa_toce/features/auth/presentation/login/presentation/views/login_screen.dart';
import 'package:ym_daa_toce/features/dashboard/presentation/views/dashboard.dart';
import 'package:ym_daa_toce/utils/bottom_bar/bottom_bar.dart';
import 'package:ym_daa_toce/utils/custom_navigation/app_nav.dart';

class AuthController extends StateNotifier<AuthState> {
  final AuthRepository authRepository;
  final DbClient dbClient;
  AuthController({required this.authRepository, required this.dbClient})
      : super(AuthState.loading()) {
    checkLogin();
  }
  String? email;
  String? password;
  String? token;
  FingerPrintLoginModel? login2;
  checkLogin() async {
    final String dbResult = await dbClient.getData(dbKey: "token");

    return dbResult.isEmpty
        ? state = const AuthState.loggedOut()
        : state = AuthState.loggedIn(LoginResponseModel.fromJson(dbResult));
  }

  login(LoginRequestModel? loginRequestModel, BuildContext context,
      {bool isLocal = false}) async {
    var localData = "";
    if (isLocal) {
      localData = await dbClient.getData(dbKey: "login");

      if (localData.isEmpty) {
        throw Exception("Please login with your email and password");
      }
    }

    LoginRequestModel input =
        isLocal ? LoginRequestModel.fromJson(localData) : loginRequestModel!;

    final result = await authRepository.loginRepo(input);
    return result.fold((l) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: const Duration(milliseconds: 1500),
        content: Text(l.message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        // margin: EdgeInsets.only(
        //     bottom: MediaQuery.of(context).viewInsets.bottom == 0
        //         ? MediaQuery.of(context).size.height - 120
        //         : MediaQuery.of(context).size.height -
        //             MediaQuery.of(context).viewInsets.bottom -
        //             100,
        //     right: 20,
        //     left: 20),
      ));
    }, (r) async {
      await dbClient.setData(dbKey: "token", value: r.toJson());
      await dbClient.setData(dbKey: "login", value: input.toJson());
      state = AuthState.loggedIn(r);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          duration: const Duration(milliseconds: 1500),
          content: Text(
            "Welcome to HRDC",
            style: const TextStyle(fontFamily: AppFont.kProductsanfont),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor: Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ));
        Navigator.of(context).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => BottomBar(
                  initialIndex: 0), // Example: set the initial index to 1
            ),
            (route) => false);
      }
    });
  }

  logout(BuildContext context) async {
    Navigator.of(context).pushAndRemoveUntil(
        CupertinoPageRoute(
          builder: (context) =>
              LoginScreen(), // Example: set the initial index to 1
        ),
        (route) => false);
  }
}

final authControllerProvider =
    StateNotifierProvider.autoDispose<AuthController, AuthState>((ref) {
  return AuthController(
      authRepository: ref.read(authRepositoryProvider),
      dbClient: ref.read(dbClientProvider));
});
