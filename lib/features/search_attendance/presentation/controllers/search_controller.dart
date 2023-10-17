import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/features/search_attendance/data/model/search_attendance_response_model.dart';
import 'package:ym_daa_toce/features/search_attendance/data/repository/search_repository.dart';

class SearchAttendanceControllerNotifier
    extends StateNotifier<AsyncValue<SearchResponseModel>> {
  final SearchAttendanceRespo attendanceRespo;
  final SearchParam searchParam;
  SearchAttendanceControllerNotifier(
      {required this.attendanceRespo, required this.searchParam})
      : super(AsyncValue.loading()) {
    searchAttendanceC();
  }
  searchAttendanceC() async {
    final result = await attendanceRespo.getSearchResultRespo(searchParam);
    return result.fold(
        (l) => state =
            AsyncValue.error(l.message, StackTrace.fromString(l.message)),
        (r) => state = AsyncValue.data(r));
  }
}

final searchAttendaceControllerProvider = StateNotifierProvider.family
    .autoDispose<SearchAttendanceControllerNotifier,
        AsyncValue<SearchResponseModel>, SearchParam>((ref, searchParam) {
  return SearchAttendanceControllerNotifier(
      attendanceRespo: ref.read(searchAttendanceRepoProvider),
      searchParam: searchParam);
});
