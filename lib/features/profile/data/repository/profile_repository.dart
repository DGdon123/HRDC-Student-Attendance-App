import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_exception/dio_exception.dart';
import 'package:ym_daa_toce/core/app_error/app_error.dart';
import 'package:ym_daa_toce/features/profile/data/data_source/profile_data_source.dart';
import 'package:ym_daa_toce/features/profile/data/model/profile_model.dart';

abstract class ProfileRepository {
  Future<Either<AppError, ProfileModel>> getProfileRepo();
}

class ProfileRepositoryImp implements ProfileRepository {
  final ProfileDataSource profileDataSource;
  ProfileRepositoryImp(this.profileDataSource);
  @override
  Future<Either<AppError, ProfileModel>> getProfileRepo() async {
    try {
      final result = await profileDataSource.getProfileDS();
      return Right(result);
    } on DioException catch (e) {
      return Left(AppError(e.message!));
    }
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImp(ref.read(profileDataSourceProvider));
});
