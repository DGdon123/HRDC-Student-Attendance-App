import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api_client/api_client.dart';
import '../../../../core/api_const/api_const.dart';
import '../../../assign_class/data/models/assign_class_studenslist_model/class_section_params_model.dart';
import '../models/attendance_list_model.dart';
import '../models/edit_attendance_response_model.dart';

abstract class EditAttendanceDataSource {
  Future<EditStoreAttendanceResponseModel> editstoreAttendance(
      ClassSectionParams classSectionModel, Map<String, dynamic> formData);
  Future<AttendanceListModel> getAttendanceData(
      ClassSectionParams classSectionModel);
}

class EditAttendanceDataSourceImp implements EditAttendanceDataSource {
  final ApiClient apiClient;
  EditAttendanceDataSourceImp(this.apiClient);
  @override
  Future<EditStoreAttendanceResponseModel> editstoreAttendance(
      ClassSectionParams classSectionModel,
      Map<String, dynamic> formData) async {
    final result = await apiClient.requestJsonData(
        path:
            "${ApiConst.kUpdateAttendance}/${classSectionModel.classId}/${classSectionModel.sectionid}",
        jsonData: formData);

    return EditStoreAttendanceResponseModel.fromMap(result);
  }

  @override
  Future<AttendanceListModel> getAttendanceData(
      ClassSectionParams classSectionModel) async {
    final result = await apiClient.request(
        path:
            "${ApiConst.kattendanceList}/${classSectionModel.classId}/${classSectionModel.sectionid}");
    return AttendanceListModel.fromMap(result);
  }
}

final editDataProvider = Provider<EditAttendanceDataSource>((ref) {
  return EditAttendanceDataSourceImp(ref.read(apiClientProvider));
});
