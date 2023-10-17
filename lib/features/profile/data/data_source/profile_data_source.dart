import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_client/api_client.dart';
import 'package:ym_daa_toce/core/api_const/api_const.dart';
import 'package:ym_daa_toce/features/profile/data/model/profile_model.dart';

abstract class ProfileDataSource {
  Future<ProfileModel> getProfileDS();
}

class ProfileDataSourceImp implements ProfileDataSource {
  final ApiClient apiClient;
  ProfileDataSourceImp(this.apiClient);
  @override
  Future<ProfileModel> getProfileDS() async {
    final result = await apiClient.request(path: ApiConst.kprofile);
    return ProfileModel.fromMap(result["data"][0]);
  }
}

final profileDataSourceProvider = Provider<ProfileDataSource>((ref) {
  return ProfileDataSourceImp(ref.read(apiClientProvider));
});
