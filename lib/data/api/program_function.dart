import 'package:flutter/material.dart';
import 'package:pkk/data/api/api_client.dart';
import 'package:pkk/data/res/program_response.dart';

abstract class ProgramFunction {
  static Future<List<Program>?> getProgramList() async {
    try {
      // ApiClient.initToken(bearerToken: Preferences.getToken() ?? "");
      final data = await ApiClient.useCache(
        model: 'program',
        onRequest: (model, queryParameters, options) {
          return ApiClient.getListData(model: model);
        },
      );
      // print(response.data);

      final programs = ProgramsResponse.fromJson(data);

      return programs.data?.records;
    } catch (e) {
      debugPrint('Error on Getting List: $e');
    }
    return [];
  }
}
