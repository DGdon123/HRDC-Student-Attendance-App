import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/api_client/api_client.dart';
import '../../../../../core/api_const/api_const.dart';
import '../models/offline_attendance_model.dart';

abstract class OfflineAttendanceDataSource {
  Future<OfflineAttendanceModel> offstoreAttendance(FormData formData);
}

class OfflineImp implements OfflineAttendanceDataSource {
  final ApiClient apiClient;
  OfflineImp(this.apiClient);
  @override
  Future<OfflineAttendanceModel> offstoreAttendance(FormData formData) async {
    final result = await apiClient.requestFormData(
        path: ApiConst.kstore, formData: formData);

    return OfflineAttendanceModel.fromMap(result);
  }
}

final offassignedClassDataSourceProvider =
    Provider<OfflineAttendanceDataSource>((ref) {
  return OfflineImp(ref.read(apiClientProvider));
});
