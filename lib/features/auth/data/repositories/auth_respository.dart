import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_exception/dio_exception.dart';
import 'package:ym_daa_toce/core/app_error/app_error.dart';
import 'package:ym_daa_toce/features/auth/data/data_sources/auth_data_source.dart';
import 'package:ym_daa_toce/features/auth/data/models/change_password_model.dart/change_password_request_model.dart';
import 'package:ym_daa_toce/features/auth/data/models/change_password_model.dart/change_password_response_model.dart';
import 'package:ym_daa_toce/features/auth/data/models/login_model/login_reponse_model.dart';
import 'package:ym_daa_toce/features/auth/data/models/login_model/login_request_model.dart';

abstract class AuthRepository {
  Future<Either<AppError, LoginResponseModel>> loginRepo(
      LoginRequestModel loginRequestModel);

  Future<Either<AppError, ChangePasswordResponseModel>> changePasswordRepo(
      ChangePasswordRequestModel changePasswordRequestModel);
}

class AuthRepositoryImpl implements AuthRepository {
  final AuthDataSource authDataSource;
  AuthRepositoryImpl(this.authDataSource);
  @override
  Future<Either<AppError, LoginResponseModel>> loginRepo(
      loginRequestModel) async {
    try {
      final result = await authDataSource.loginDS(loginRequestModel);
      // log(result.token);
      return Right(result);
    } on DioException catch (e) {
      return Left(AppError(e.message!));
    }
  }

  @override
  Future<Either<AppError, ChangePasswordResponseModel>> changePasswordRepo(
      ChangePasswordRequestModel changePasswordRequestModel) async {
    try {
      final result =
          await authDataSource.changePasswordDS(changePasswordRequestModel);
      return Right(result);
    } on DioException catch (e) {
      return Left(AppError(e.message!));
    }
  }
}

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authDataSource));
});
