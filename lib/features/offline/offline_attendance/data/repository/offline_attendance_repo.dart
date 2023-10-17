import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_exception/dio_exception.dart';
import 'package:ym_daa_toce/core/app_error/app_error.dart';

import '../data_sources/offline_data_sources.dart';
import '../models/offline_attendance_model.dart';

abstract class OfflineAttendanceRepo {
  Future<Either<AppError, OfflineAttendanceModel>> offstoreAttendenceRepo(
      FormData formData);
}

class OfflineAttendanceRepoImp implements OfflineAttendanceRepo {
  final OfflineAttendanceDataSource offassignedClassDataSource;
  OfflineAttendanceRepoImp(this.offassignedClassDataSource);
  @override
  Future<Either<AppError, OfflineAttendanceModel>> offstoreAttendenceRepo(
      FormData formData) async {
    try {
      final result =
          await offassignedClassDataSource.offstoreAttendance(formData);
      return Right(result);
    } on DioException catch (e) {
      return Left(AppError(e.message!));
    }
  }
}

final offassignedClassRepositoryProvider =
    Provider<OfflineAttendanceRepo>((ref) {
  return OfflineAttendanceRepoImp(ref.read(offassignedClassDataSourceProvider));
});
