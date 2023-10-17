import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_exception/dio_exception.dart';
import 'package:ym_daa_toce/core/app_error/app_error.dart';
import 'package:ym_daa_toce/features/assign_class/data/data_source/assign_class_data_source.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/assign_class_model/assign_class_model.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/top_three_attendance_model.dart';

import '../models/assign_class_studenslist_model/assign_class_students_list_model.dart';
import '../models/assign_class_studenslist_model/class_section_params_model.dart';
import '../models/store_model/store_attendence_res_model.dart';

abstract class AssignedClassRepository {
  Future<Either<AppError, AssignedClassModel>> getAssignedClassRepo();
  Future<Either<AppError, AssignClassStudentModel>> getAssignedClassDetailRepo(
      ClassSectionParams classSectionModel);
  Future<Either<AppError, StoreAttendanceResponseModel>> storeAttendenceRepo(
      FormData formData);
  Future<Either<AppError, List<TopThreeAttendanceModel>>> getTopThreeAttendance(
      String classNum, String sectionNum);
}

class AssignedClassRepositoryImp implements AssignedClassRepository {
  final AssignedClassDataSource assignedClassDataSource;
  AssignedClassRepositoryImp(this.assignedClassDataSource);
  @override
  Future<Either<AppError, AssignedClassModel>> getAssignedClassRepo() async {
    try {
      final result = await assignedClassDataSource.getAssignedClassDS();
      return Right(result);
    } on DioException catch (e) {
      return Left(AppError(e.message!));
    }
  }

  @override
  Future<Either<AppError, AssignClassStudentModel>> getAssignedClassDetailRepo(
      ClassSectionParams classSectionModel) async {
    try {
      final result = await assignedClassDataSource
          .getAssignedClassDetailDS(classSectionModel);
      return Right(result);
    } on DioException catch (e) {
      return Left(AppError(e.message!));
    }
  }

  @override
  Future<Either<AppError, StoreAttendanceResponseModel>> storeAttendenceRepo(
      FormData formData) async {
    try {
      final result = await assignedClassDataSource.storeAttendance(formData);
      return Right(result);
    } on DioException catch (e) {
      return Left(AppError(e.message!));
    }
  }

  @override
  Future<Either<AppError, List<TopThreeAttendanceModel>>> getTopThreeAttendance(
      String classNum, String sectionNum) async {
    try {
      final result = await assignedClassDataSource.getTopThreeAttendance(
          classNum, sectionNum);
      return Right(result);
    } on DioException catch (e) {
      return Left(AppError(e.message!));
    }
  }
}

final assignedClassRepositoryProvider =
    Provider<AssignedClassRepository>((ref) {
  return AssignedClassRepositoryImp(ref.read(assignedClassDataSourceProvider));
});
