// import 'package:dio/dio.dart';
// import 'package:ym_daa_toce/core/api_const/api_const.dart';
// import 'package:ym_daa_toce/core/api_exception/dio_exception.dart';
// import 'package:ym_daa_toce/core/db_clienet.dart';
// import 'package:ym_daa_toce/features/auth/data/models/login_reponse_model.dart';

// class ApiClient {
//   final DbClient _dbClient;
//   ApiClient(this._dbClient)

//    Future request(
//   {required String path,
//       String type = "get",
//       Map<String, dynamic> data = const {},}) async {
//     final String dbResult= await _dbClient.getData(key: "auth");
//     final LoginResponseModel loginResponseModel =LoginResponseModel.fromJson(dbResult);
//     final String token =loginResponseModel.token;
//     final Dio dio = Dio(BaseOptions(baseUrl: ApiConst.baseUrl, headers: {
//       "Content-Type": "application/json",
//       "Accept": "application/json",
//       "Authorization": "Bearer $token"
//     }));

//     try {
//       final result=type=="get"?await dio.get(path):await dio.post(path,data:data);
//       return result.data;
//     } on DioError catch (e) {
//       throw DioException.fromDioError(e);

//     }
//   }
// }

import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_const/api_const.dart';
import 'package:ym_daa_toce/core/api_exception/dio_exception.dart';
import 'package:ym_daa_toce/core/db_client.dart';
import 'package:ym_daa_toce/features/auth/data/models/login_model/login_reponse_model.dart';

class ApiClient {
  final DbClient _dbClient;
  ApiClient(this._dbClient);
  Future request({
    required String path,
    String type = "get",
    Map<String, dynamic> data = const {},
  }) async {
    final String dbResult = await _dbClient.getData(dbKey: "token");
    String token = "";
    if (dbResult.isNotEmpty) {
      // var loginData = LoginResponseModel.fromJson(dbResult);
      // token = loginData.token;
      final LoginResponseModel loginResponseModel =
          LoginResponseModel.fromJson(dbResult);
      token = loginResponseModel.token;
    }

    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConst.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          "Accept": 'application/json',
          "Authorization": "Bearer ${token}"
        },
      ),
    );
    try {
      print(path);
      final result = type == "get"
          ? await dio.get(path)
          : await dio.post(path, data: data);
      await _dbClient.setData(dbKey: path, value: json.encode(result.data));
      return result.data;
    } on DioError catch (e) {
      if (e.type.name == "unknown") {
        String dbData = await _dbClient.getData(dbKey: path);
        if (dbData.isEmpty) {
          throw DioException.fromDioError(e);
        }
        return json.decode(dbData);
      }
      // log(e.error.);
      // log(e.response!.statusCode.toString());
      // log(e.response!.toString());
      // log(e.error.toString());
      // log(e.message!.toString());
      // log(e.type.toString());
      throw DioException.fromDioError(e);
    }
  }

  Future requestFormData(
      {required String path, required FormData formData}) async {
    final String dbResult = await _dbClient.getData(dbKey: "token");
    String token = "";
    if (dbResult.isNotEmpty) {
      var loginData = LoginResponseModel.fromJson(dbResult);
      token = loginData.token;
      // final LoginResponseModel loginResponseModel =
      //     LoginResponseModel.fromJson(dbResult);
      // token = loginResponseModel.token;
    }

    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConst.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          "Accept": 'application/json',
          "Authorization": "Bearer ${token}"
        },
      ),
    );
    try {
      final result = await dio.post(path, data: formData);
      return result.data;
    } on DioError catch (e) {
      print(e.response);
      log(e.response!.statusCode.toString());
      log(e.response!.toString());
      log(e.error.toString());
      log(e.message!.toString());
      throw DioException.fromDioError(e);
    }
  }

  Future requestFormData2(
      {required String path, required FormData formData}) async {
    final String dbResult = await _dbClient.getData(dbKey: "token");
    String token = "";
    if (dbResult.isNotEmpty) {
      var loginData = LoginResponseModel.fromJson(dbResult);
      token = loginData.token;
      // final LoginResponseModel loginResponseModel =
      //     LoginResponseModel.fromJson(dbResult);
      // token = loginResponseModel.token;
    }

    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConst.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          "Accept": 'application/json',
          "Authorization": "Bearer ${token}"
        },
      ),
    );
    try {
      final result = await dio.put(path, data: formData);
      return result.data;
    } on DioError catch (e) {
      print(e.response);
      log(e.response!.statusCode.toString());
      log(e.response!.toString());
      log(e.error.toString());
      log(e.message!.toString());
      throw DioException.fromDioError(e);
    }
  }

  Future requestJsonData(
      {required String path, required Map<String, dynamic> jsonData}) async {
    final String dbResult = await _dbClient.getData(dbKey: "token");
    String token = "";
    if (dbResult.isNotEmpty) {
      var loginData = LoginResponseModel.fromJson(dbResult);
      token = loginData.token;
    }

    final Dio dio = Dio(
      BaseOptions(
        baseUrl: ApiConst.baseUrl,
        headers: {
          'Content-Type': 'application/json',
          "Accept": 'application/json',
          "Authorization": "Bearer ${token}"
        },
      ),
    );

    try {
      final result = await dio.put(path, data: jsonData);
      return result.data;
    } on DioError catch (e) {
      print(e.response);
      log(e.response!.statusCode.toString());
      log(e.response!.toString());
      log(e.error.toString());
      log(e.message!.toString());
      throw DioException.fromDioError(e);
    }
  }
}

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.read(dbClientProvider));
});
