import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pkk/data/api/api_client.dart';
import 'package:pkk/data/res/user_response.dart';

abstract class MemberFunction {
  static Future<List<User>?> getUserList() async {
    try {
      final response = await ApiClient.getListData(model: 'user');

      if (response.statusCode == 200) {
        final userList = UsersResponse.fromJson(response.data);

        if (userList.response?.status == 200) {
          return userList.data?.records;
        }
      }
    } catch (e) {
      debugPrint('Error when fetching User List: $e');
    }
    return [];
  }

  static Future<bool> addUser({required User user}) async {
    FormData formData = FormData.fromMap(user.toJson());
    try {
      final response = await ApiClient.insertDataToModel(
        model: 'user',
        formData: formData,
      );

      if (response.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('Error when inserting User: $e');
    }
    return false;
  }
}
