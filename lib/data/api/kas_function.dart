import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pkk/data/res/kas_report_response.dart';
import 'package:pkk/data/res/kas_response.dart';
import 'package:pkk/extensions/datetime_ext.dart';

import 'api_client.dart';

abstract class KasFunction {
  static Future<Map<String, String>> fetchKasMonths({int? year}) async {
    try {
      final response = await ApiClient.getListData(
          model: 'kas/month',
          queryParameters: {if (year != null) 'year': year});

      if (response.statusCode == 200) {
        final result = response.data['data']['records'] as List?;
        if (result == null) return {};
        final resMap = <String, String>{};
        for (var element in result) {
          resMap[element['text']] = element['value'];
        }
        return resMap;
      }
    } catch (e, stacktrace) {
      debugPrint('Error when fetching List Kas: $e\n$stacktrace');
    }
    return {};
  }

  static Future<List<Kas>?> fetchKasList(
      {String? id, String? monthCode}) async {
    try {
      final response = await ApiClient.getListData(
        model: 'kas',
        queryParameters: {if (monthCode != null) 'month': monthCode},
      );

      if (response.statusCode == 200) {
        final result = KasResponse.fromJson(response.data);
        if (result.response?.status == 200) {
          return result.data?.records;
        }
      }
    } catch (e, stacktrace) {
      debugPrint('Error when fetching List Kas: $e\n$stacktrace');
    }
    return [];
  }

  static Future<Kas?> fetchKas({required String id}) async {
    try {
      final response = await ApiClient.getDataById(model: 'kas', idData: id);
      return Kas.fromJson(response.data['data']['record']);
    } catch (e, stacktrace) {
      debugPrint('Error when fetching Kas: $e\n$stacktrace');
    }
    return null;
  }

  static Future<KasReportData?> fetchKasReport(
      {DateTime? startDate, DateTime? endDate}) async {
    try {
      final response =
          await ApiClient.getListData(model: 'kas/report', queryParameters: {
        if (startDate != null) 'date_start': startDate.toYMD(),
        if (endDate != null) 'date_end': endDate.toYMD()
      });

      if (response.statusCode == 200) {
        final result = KasReportResponse.fromJson(response.data);
        log('RESULT. ${result.data?.kasIn?.length}');
        return result.data;
      }
    } catch (e, stacktrace) {
      debugPrint('Error when fetching Kas Report: $e\n$stacktrace');
    }
    return null;
  }

  static Future<bool> deleteKas(String id) async {
    try {
      final response = await ApiClient.deleteDataById(
        model: 'kas',
        idData: id,
      );
      return response.statusCode == 200;
    } catch (e, stacktrace) {
      debugPrint('Error when deleting Kas: $e\n$stacktrace');
    }
    return false;
  }

  static Future<bool> postKas(Kas kas) async {
    try {
      final response = await ApiClient.insertDataToModel(
          model: 'kas',
          formData: FormData.fromMap({
            'activity_id': kas.activityId,
            'keterangan': kas.keterangan,
            'tujuan': kas.tujuan,
            'date': kas.date?.toYMD(),
            'nominal': kas.nominal,
            'type': kas.type,
            'image': await MultipartFile.fromFile(kas.localImage!.path,
                filename: kas.localImage!.path.split('/').last)
          }),
          options: Options(
            headers: {'accept': 'application/json', 'X-CSRF-TOKEN': ''},
          ));
      return response.statusCode == 200;
    } catch (e, stacktrace) {
      debugPrint('Error when saving Kas: $e\n$stacktrace');
    }
    return false;
  }

  static Future<bool> downloadKasMonthlyReport(String monthCode) async {
    try {
      final response = await ApiClient.download(
        model: 'kas/month/xls',
        fileName: 'kas_$monthCode.xls',
        queryParameters: {'month': monthCode},
      );
      return response.statusCode == 200;
    } catch (e, stacktrace) {
      debugPrint('Error when downloading Kas: $e\n$stacktrace');
    }
    return false;
  }
}
