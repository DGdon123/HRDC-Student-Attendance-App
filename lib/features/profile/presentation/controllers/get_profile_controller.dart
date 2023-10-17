import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/features/profile/data/model/profile_model.dart';
import 'package:ym_daa_toce/features/profile/data/repository/profile_repository.dart';

class ProfileController extends StateNotifier<AsyncValue<ProfileModel>> {
  final ProfileRepository profileRepository;
  ProfileController(this.profileRepository) : super(AsyncValue.loading()) {
    getProfileC();
  }
  getProfileC() async {
    final result = await profileRepository.getProfileRepo();
    return result.fold(
        (l) => state =
            AsyncValue.error(l.message, StackTrace.fromString(l.message)),
        (r) => state = AsyncValue.data(r));
  }
}

final profileControllerProvider = StateNotifierProvider.autoDispose<
    ProfileController, AsyncValue<ProfileModel>>((ref) {
  return ProfileController(ref.read(profileRepositoryProvider));
});
