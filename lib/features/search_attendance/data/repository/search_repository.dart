import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_exception/dio_exception.dart';
import 'package:ym_daa_toce/core/app_error/app_error.dart';
import 'package:ym_daa_toce/features/search_attendance/data/data_source/search_response_data_source.dart';
import '../model/search_attendance_response_model.dart';

abstract class SearchAttendanceRespo {
  Future<Either<AppError, SearchResponseModel>> getSearchResultRespo(
      SearchParam searchParam);
}

class SearchAttendanceRespoImpl implements SearchAttendanceRespo {
  final SearchAttendanceDatasource searchAttendanceDatasource;
  SearchAttendanceRespoImpl({required this.searchAttendanceDatasource});
  @override
  Future<Either<AppError, SearchResponseModel>> getSearchResultRespo(
      SearchParam searchParam) async {
    try {
      final result =
          await searchAttendanceDatasource.getSearchResult(searchParam);
      return Right(result);
    } on DioException catch (e) {
      return Left(AppError(e.message!));
    }
  }
}

final searchAttendanceRepoProvider = Provider<SearchAttendanceRespo>((ref) {
  return SearchAttendanceRespoImpl(
      searchAttendanceDatasource: ref.read(searchAttendanceDSProvider));
});
