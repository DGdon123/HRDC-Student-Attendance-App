import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_client/api_client.dart';
import 'package:ym_daa_toce/core/api_const/api_const.dart';
import 'package:ym_daa_toce/features/auth/data/models/change_password_model.dart/change_password_request_model.dart';
import 'package:ym_daa_toce/features/auth/data/models/change_password_model.dart/change_password_response_model.dart';
import 'package:ym_daa_toce/features/auth/data/models/login_model/login_reponse_model.dart';
import 'package:ym_daa_toce/features/auth/data/models/login_model/login_request_model.dart';
import 'dart:developer';

abstract class AuthDataSource {
  Future<LoginResponseModel> loginDS(LoginRequestModel loginRequestModel);
  Future<ChangePasswordResponseModel> changePasswordDS(
      ChangePasswordRequestModel changePasswordRequestModel);
}

class AuthDataSourceImpl implements AuthDataSource {
  final ApiClient apiClient;
  AuthDataSourceImpl(this.apiClient);
  @override
  Future<LoginResponseModel> loginDS(
      LoginRequestModel loginRequestModel) async {
    final result = await apiClient.request(
        type: "post",
        path: ApiConst.kauthLoigin,
        data: loginRequestModel.toMap());
    log(LoginResponseModel.fromMap(result["data"]).toString());
    return LoginResponseModel.fromMap(result["data"]);
  }

  @override
  Future<ChangePasswordResponseModel> changePasswordDS(
      ChangePasswordRequestModel changePasswordRequestModel) async {
    final result = await apiClient.request(
        path: ApiConst.kauthChangePassword,
        type: "post",
        data: changePasswordRequestModel.toMap());
    return ChangePasswordResponseModel.fromMap(result);
  }
}

final authDataSource = Provider<AuthDataSource>((ref) {
  return AuthDataSourceImpl(ref.read(apiClientProvider));
});
