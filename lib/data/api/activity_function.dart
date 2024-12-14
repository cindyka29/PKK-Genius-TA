import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pkk/data/api/api_client.dart';
import 'package:pkk/data/preferences.dart';
import 'package:pkk/data/res/activities_response.dart';
import 'package:pkk/data/res/documentations_response.dart';

abstract class ActivityFunction {
  static Future<List<Activity>?> fetchActivityList() async {
    try {
      // ApiClient.initToken(bearerToken: Preferences.getToken() ?? "");
      final response = await ApiClient.getListData(
        model: 'activity',
      );
      // print(response.data);

      if (response.statusCode == 200) {
        // debugPrint('test');
        // print(response.data);
        final result = ActivitiesResponse.fromJson(response.data);
        // print(result);
        if (result.response?.status == 200) {
          return result.datas?.records;
        }
      }
    } catch (e) {
      debugPrint('Error when fetching List Activity: $e');
    }
    return [];
  }

  static Future<Activity?> fetchActivity({required String idData}) async {
    try {
      ApiClient.initToken(bearerToken: Preferences.getToken() ?? "");
      final response = await ApiClient.getDataById(
        model: 'activity',
        idData: idData,
      );
      if (response.statusCode == 200) {
        final result = ActivitiesResponse.fromJsonById(response.data);
        if (result.response?.status == 200) {
          return result.data?.record;
        }
      }
    } catch (e) {
      debugPrint('Error when fetching Activity: $e');
    }
    return null;
  }

  static Future<bool> addActivity({required Activity activity}) async {
    try {
      final response = await ApiClient.insertDataToModel(
        model: 'activity',
        payload: activity.toJson(),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('Error when inserting Activity: $e');
    }
    return false;
  }

  static Future<bool> addDocumentation({required Activity activity}) async {
    try {
      final response = await ApiClient.insertDataToModel(
        model: 'activity/documentation',
        formData: FormData.fromMap({
          'activity_id': activity.id,
          'name': activity.name,
          'image': await MultipartFile.fromFile(
              activity.localDocumentation!.path,
              filename: activity.localDocumentation!.path.split('/').last)
        }),
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('Error when inserting Activity: $e');
    }
    return false;
  }

  static Future<List<Datum>?> getDocumentation() async {
    try {
      final response = await ApiClient.getAllDocumentations();
      if (response.statusCode == 200) {
        final result = DocumentationsResponse.fromJson(response.data);
        if (result.response.status == 200) {
          return result.data;
        }
      }
    } catch (e, stacktrace) {
      debugPrint('Error when fetching Documentations: $e\n$stacktrace');
    }
    return null;
  }
}
