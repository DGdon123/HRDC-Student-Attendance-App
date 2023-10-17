import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/features/edit_attendance/data/models/edit_attendance_response_model.dart';

import '../../../../core/api_exception/dio_exception.dart';
import '../../../../core/app_error/app_error.dart';
import '../../../assign_class/data/models/assign_class_studenslist_model/class_section_params_model.dart';
import '../data_source/edit_attendance_data_source.dart';
import '../models/attendance_list_model.dart';

abstract class EditAttendanceRepo {
  Future<Either<AppError, EditStoreAttendanceResponseModel>> editrepo(
      ClassSectionParams classSectionModel, Map<String, dynamic> formData);
  Future<Either<AppError, AttendanceListModel>> getAttendanceListRepo(
      ClassSectionParams classSectionModel);
}

class EditAttendanceRepoImp implements EditAttendanceRepo {
  final EditAttendanceDataSource editassignedClassDataSource;
  EditAttendanceRepoImp(this.editassignedClassDataSource);
  @override
  Future<Either<AppError, EditStoreAttendanceResponseModel>> editrepo(
      ClassSectionParams classSectionModel,
      Map<String, dynamic> formData) async {
    try {
      final result = await editassignedClassDataSource.editstoreAttendance(
          classSectionModel, formData);
      return Right(result);
    } on DioException catch (e) {
      return Left(AppError(e.message!));
    }
  }

  @override
  Future<Either<AppError, AttendanceListModel>> getAttendanceListRepo(
      ClassSectionParams classSectionModel) async {
    try {
      final result = await editassignedClassDataSource
          .getAttendanceData(classSectionModel);
      return Right(result);
    } on DioException catch (e) {
      return Left(AppError(e.message!));
    }
  }
}

final editrepoProvider = Provider<EditAttendanceRepo>((ref) {
  return EditAttendanceRepoImp(ref.read(editDataProvider));
});
