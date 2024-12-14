import 'package:flutter/material.dart';
import 'package:pkk/data/api/api_client.dart';
import 'package:pkk/data/api/monthly_iuran_response.dart';
import 'package:pkk/data/preferences.dart';
import 'package:pkk/data/res/iuran_rekap_response.dart';
import 'package:pkk/data/res/iuran_report_response.dart';
import 'package:pkk/data/res/iuran_response.dart';
import 'package:pkk/extensions/datetime_ext.dart';

abstract class IuranFunction {
  static Future<Data?> getUserIuranList(String activityId) async {
    try {
      final userIuranData = await ApiClient.useCache(
        model: 'iuran/$activityId/activity',
        onRequest: (model, queryParameters, options) {
          return ApiClient.getListData(model: model, options: options);
        },
      ).then((data) {
        return IuranResponse.fromJson(data).data;
      });
      final userList = [
        ...userIuranData?.users?.where((e) => e.userId != null) ??
            <UserElement>[],
      ];
      return Data(
        activity: userIuranData?.activity,
        users: userList,
      );
    } catch (e, stacktrace) {
      debugPrint('Error when fetching List absen: $e\n$stacktrace');
    }
    return null;
  }

  static Future<String?> postUserIuranStatus(
      {required String userId,
      required String activityId,
      required int nominal,
      required bool isPaid}) async {
    try {
      final response = await ApiClient.insertDataToModel(
        model: 'iuran',
        payload: {
          "user_id": userId,
          "activity_id": activityId,
          "is_paid": isPaid,
          "nominal": nominal,
        },
      );
      if (response.statusCode! < 200 || response.statusCode! >= 300) {
        return null;
      }
      return response.data['data']['record']['id_iuran'];
    } catch (e, stacktrace) {
      debugPrint('Error when updating user absence status: $e\n$stacktrace');
      return null;
    }
  }

  static Future<bool> putUserIuranStatus(
      {required String iuranId,
      required String userId,
      required String activityId,
      required int nominal,
      required bool isPaid}) async {
    try {
      final response = await ApiClient.updateDataById(
        model: 'iuran',
        idData: iuranId,
        payload: {
          "user_id": userId,
          "activity_id": activityId,
          "is_paid": isPaid,
          "nominal": nominal,
        },
      );
      if (response.statusCode == null) return false;
      return response.statusCode! >= 200 || response.statusCode! < 300;
    } catch (e, stacktrace) {
      debugPrint('Error when updating user absence status: $e\n$stacktrace');
      return false;
    }
  }

  static Future<bool> deleteUserIuranStatus({required String iuranId}) async {
    try {
      final response = await ApiClient.deleteDataById(
        model: 'iuran',
        idData: iuranId,
      );
      if (response.statusCode == null) return false;
      return response.statusCode! >= 200 || response.statusCode! < 300;
    } catch (e, stacktrace) {
      debugPrint('Error when updating user absence status: $e\n$stacktrace');
      return false;
    }
  }

  static Future<List<UserElement>?> getIuranByUserId() async {
    try {
      final response = await ApiClient.getListDataByUserID(
          model: 'iuran', userID: Preferences.getUser()!.id!);
      if (response.statusCode == 200) {
        debugPrint(response.data.toString());
        // final listdataAbsenrespon = AbsencesResponse.fromJson(response.data);
        final listAbsen = Data.fromIuran(response.data["data"]);
        return listAbsen.users;
      }
    } catch (e, stacktrace) {
      debugPrint('Error when getting user absence by user id: $e\n$stacktrace');
    }
    return [];
  }

  static Future<IuranReportData> getIuranReport(
      {DateTime? startDate, DateTime? endDate}) async {
    try {
      final response = await ApiClient.getListData(
        model: 'iuran/report',
        queryParameters: {
          if (startDate != null) 'date_start': startDate.toYMD(),
          if (endDate != null) 'date_end': endDate.toYMD()
        },
      );
      if (response.statusCode != 200) {
        throw Exception('Status code: ${response.statusCode}');
      }
      debugPrint(response.data.toString());
      final iuranReportRes = IuranReportResponse.fromJson(response.data);
      return iuranReportRes.data;
    } catch (e, stacktrace) {
      debugPrint('Error when getting iuran report: $e\n$stacktrace');
      return IuranReportData(dataIn: [], out: []);
    }
  }

  static Future<List<MonthlyIuranRecord>> getMonthlyIurans() async {
    try {
      final response = await ApiClient.getListData(
        model: 'iuran/month',
      );
      if (response.statusCode != 200) {
        throw Exception('Status code: ${response.statusCode}');
      }
      debugPrint(response.data.toString());
      final iurans = MonthlyIuransResponse.fromJson(response.data["data"]);
      return iurans.data.records;
    } catch (e, stacktrace) {
      debugPrint('Error when getting iuran report: $e\n$stacktrace');
      return [];
    }
  }

  static Future<bool> downloadIuranMonthlyReport(DateTime date) async {
    try {
      final response = await ApiClient.download(
        model: 'iuran/month/xls',
        fileName: 'iuran_${date.toYM()}.xls',
        queryParameters: {'month': date.toYM()},
      );
      return response.statusCode == 200;
    } catch (e, stacktrace) {
      debugPrint('Error when downloading Iuran: $e\n$stacktrace');
    }
    return false;
  }

  static Future<List<IuranRekapUserElement>?> getRekapIuran(
      String activityID) async {
    try {
      final response =
          await ApiClient.getiuranRekapDataByActivityID(activityID: activityID);
      if (response.statusCode == 200) {
        final listRekap = RekapIuran.fromJson(response.data);
        return listRekap.data?.users;
      }
    } catch (e, stacktrace) {
      debugPrint('Error when getting Rekap Iuran: $e\n$stacktrace');
    }

    return [];
  }
}
