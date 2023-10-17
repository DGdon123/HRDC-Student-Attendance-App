import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_client/api_client.dart';
import 'package:ym_daa_toce/core/api_const/api_const.dart';
import 'package:ym_daa_toce/core/api_exception/dio_exception.dart';
import 'package:ym_daa_toce/features/report/report_model.dart';

class ReportController extends StateNotifier<AsyncValue<ReportModel>> {
  ReportController(this._apiClient) : super(AsyncValue.loading()) {
    getData();
  }

  final ApiClient _apiClient;

  getData() async {
    try {
      final result = await _apiClient.request(path: ApiConst.kReports);
      final ReportModel report = ReportModel.fromMap(result);
      state = AsyncValue.data(report);
    } on DioException catch (e) {
      state = AsyncValue.error(e.message!, StackTrace.fromString(e.message!));
    }
  }
}

final reportControllerProvider = StateNotifierProvider.autoDispose<
    ReportController, AsyncValue<ReportModel>>((ref) {
  return ReportController(ref.read(apiClientProvider));
});
