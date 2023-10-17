import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_client/api_client.dart';
import 'package:ym_daa_toce/core/api_const/api_const.dart';

import '../model/search_attendance_response_model.dart';

abstract class SearchAttendanceDatasource {
  Future<SearchResponseModel> getSearchResult(SearchParam searchParam);
}

class SearchAttendanceDatasourceImpl implements SearchAttendanceDatasource {
  final ApiClient apiClient;
  SearchAttendanceDatasourceImpl({required this.apiClient});
  @override
  Future<SearchResponseModel> getSearchResult(
    SearchParam searchParam,
  ) async {
    // log(searchParam.searechClass.toString());
    final result = await apiClient.request(
        path:
            "${ApiConst.ksearchAttendanceEndPoint}${searchParam.searechClass}/${searchParam.section}/${searchParam.searchData}");
    return SearchResponseModel.fromJson(result);
  }
}

final searchAttendanceDSProvider = Provider<SearchAttendanceDatasource>((ref) {
  return SearchAttendanceDatasourceImpl(apiClient: ref.read(apiClientProvider));
});
