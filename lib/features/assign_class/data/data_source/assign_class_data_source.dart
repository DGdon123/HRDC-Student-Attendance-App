import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:ym_daa_toce/core/api_client/api_client.dart';
import 'package:ym_daa_toce/core/api_const/api_const.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/assign_class_model/assign_class_model.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/assign_class_studenslist_model/assign_class_students_list_model.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/attendance_reason/attendance_resons_model.dart';
import 'package:ym_daa_toce/features/assign_class/data/models/top_three_attendance_model.dart';

import '../models/assign_class_studenslist_model/class_section_params_model.dart';
import '../models/store_model/store_attendence_res_model.dart';

abstract class AssignedClassDataSource {
  Future<AssignedClassModel> getAssignedClassDS();
  Future<AssignClassStudentModel> getAssignedClassDetailDS(
      ClassSectionParams classSectionModel);

  Future<StoreAttendanceResponseModel> storeAttendance(FormData formData);

  Future<List<AttendanceReasonModel>> getAttendanceStatusList(int id);

  Future<List<TopThreeAttendanceModel>> getTopThreeAttendance(
      String classNum, String sectionNum);
}

class AssignedClassDataSourceImp implements AssignedClassDataSource {
  final ApiClient apiClient;
  AssignedClassDataSourceImp(this.apiClient);
  @override
  Future<AssignedClassModel> getAssignedClassDS() async {
    final result = await apiClient.request(path: ApiConst.kassignedclass);
    return AssignedClassModel.fromMap(result["data"][0]);
  }

  @override
  Future<AssignClassStudentModel> getAssignedClassDetailDS(
      ClassSectionParams classSectionModel) async {
    final result = await apiClient.request(
        path:
            "${ApiConst.kstudent}/${classSectionModel.classId}/${classSectionModel.sectionid}");
    return AssignClassStudentModel.fromMap(result);
  }

  @override
  Future<StoreAttendanceResponseModel> storeAttendance(
      FormData formData) async {
    final result = await apiClient.requestFormData(
        path: ApiConst.kstore, formData: formData);

    return StoreAttendanceResponseModel.fromMap(result);
  }

  @override
  Future<List<AttendanceReasonModel>> getAttendanceStatusList(int id) async {
    final result = await apiClient.request(
        path: ApiConst.kAttendanceReason + id.toString());
    return List.from(result['data'])
        .map((e) => AttendanceReasonModel.fromMap(e))
        .toList();
  }

  @override
  Future<List<TopThreeAttendanceModel>> getTopThreeAttendance(
      String classNum, String sectionNum) async {
    final result = await apiClient.request(
        path: ApiConst.kTopThreeAttendance + classNum + "/" + sectionNum);
    return List.from(result['data'])
        .map((e) => TopThreeAttendanceModel.fromMap(e))
        .toList();
  }
}

final assignedClassDataSourceProvider =
    Provider<AssignedClassDataSource>((ref) {
  return AssignedClassDataSourceImp(ref.read(apiClientProvider));
});
