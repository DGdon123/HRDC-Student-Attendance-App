import 'dart:convert';
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ym_daa_toce/core/api_client/api_client.dart';
import 'package:ym_daa_toce/core/api_const/api_const.dart';

import '../../../offline_attendance/data/models/offline_attendance_model.dart';

final offlineControllerProvider = StateNotifierProvider.autoDispose<
    OfflineController, AsyncValue<List<OfflineAttendanceModel>>>(
  (ref) {
    return OfflineController(ref.read(apiClientProvider));
  },
);

class OfflineController
    extends StateNotifier<AsyncValue<List<OfflineAttendanceModel>>> {
  final ApiClient apiClient;

  OfflineController(this.apiClient) : super(AsyncValue.loading()) {
    syncData();
  }

  Future<void> setData(int dayNumber, OfflineAttendanceModel data) async {
    await saveDataOffline(data, dayNumber);
    await saveDataInSharedPreferences();
    await syncData();
  }

  Future<void> syncData() async {
    List<OfflineAttendanceModel> offlineData =
        await getDataFromSharedPreferences();

    for (final attendanceModel in offlineData) {
      try {
        final apiResponse = await apiClient.requestFormData(
          path: ApiConst.kstore,
          formData: attendanceModel.toFormData(),
        );

        if (apiResponse is Map<String, dynamic>) {
          await removeDataForDay(
              int.parse(attendanceModel.attendanceDate.toString()));
        }
      } catch (e) {
        log('Error syncing data: $e');
      }
    }
  }

  Future<void> saveDataOffline(
      OfflineAttendanceModel data, int dayNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;

    prefs.setString(
        'offline_data_$dayNumber',
        json.encode({
          'data': data.toMap(),
          'timestamp': currentTimeStamp,
        }));
  }

  Future<void> removeDataForDay(int dayNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('offline_data_$dayNumber');
  }

  Future<void> saveDataInSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int currentTimeStamp = DateTime.now().millisecondsSinceEpoch;
    List<String> keysToRemove = [];

    for (final key in prefs.getKeys()) {
      if (key.startsWith('offline_data_')) {
        Map<String, dynamic> entry = json.decode(prefs.getString(key)!);
        int entryTimeStamp = entry['timestamp'];

        int timeDifference = currentTimeStamp - entryTimeStamp;
        int daysDifference = (timeDifference / (1000 * 60 * 60 * 24)).ceil();

        if (daysDifference > 7) {
          keysToRemove.add(key);
        }
      }
    }

    for (final keyToRemove in keysToRemove) {
      prefs.remove(keyToRemove);
    }
  }

  Future<List<OfflineAttendanceModel>> getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<OfflineAttendanceModel> offlineData = [];

    for (final key in prefs.getKeys()) {
      if (key.startsWith('offline_data_')) {
        Map<String, dynamic> entry = json.decode(prefs.getString(key)!);
        Map<String, dynamic> dataMap = entry['data'];
        int entryTimeStamp = entry['timestamp'];

        int timeDifference =
            DateTime.now().millisecondsSinceEpoch - entryTimeStamp;
        int daysDifference = (timeDifference / (1000 * 60 * 60 * 24)).ceil();

        if (daysDifference <= 7) {
          OfflineAttendanceModel offlineAttendanceModel =
              OfflineAttendanceModel.fromMap(dataMap);
          offlineData.add(offlineAttendanceModel);
        }
      }
    }

    return offlineData;
  }

  Future<OfflineAttendanceModel?> getCurrentDataForDay(int dayNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = 'offline_data_$dayNumber';

    if (prefs.containsKey(key)) {
      Map<String, dynamic> dataMap = json.decode(prefs.getString(key)!)['data'];
      return OfflineAttendanceModel.fromMap(dataMap);
    }

    return null;
  }
}
