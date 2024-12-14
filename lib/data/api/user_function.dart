import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pkk/data/api/api_client.dart';
import 'package:pkk/data/preferences.dart';

abstract class UserFunction {
  static Future<bool> addUser({FormData? formData}) async {
    try {
      ApiClient.initToken(bearerToken: Preferences.getToken() ?? "");
      final result = await ApiClient.insertDataToModel(
        model: 'user',
        formData: formData,
        options: Options(
          headers: {
            'accept': 'application/json',
          },
        ),
      );
      if (result.statusCode == 200) {
        return true;
      }
    } catch (e) {
      debugPrint('Error when inserting User: $e');
    }
    return false;
  }

  static Future<bool> changeUserStatus(String userId,
      {bool isActive = true}) async {
    try {
      final result = await ApiClient.dio.post(
        '${ApiClient.apiUrl}/user/status/$userId',
        queryParameters: {
          'is_active': isActive ? 1 : 0,
        },
      );
      return result.statusCode == 200;
    } catch (e) {
      debugPrint('Error when reset password User: $e');
      return false;
    }
  }

  static Future<bool> deleteUser(String userId) async {
    try {
      final result =
          await ApiClient.deleteDataById(model: 'user', idData: userId);
      return result.statusCode == 200;
    } catch (e) {
      debugPrint('Error when reset password User: $e');
      return false;
    }
  }

  static Future<bool> resetPassword(String userId) async {
    try {
      final result = await ApiClient.insertDataToModel(
          model: 'user/reset-password/$userId');
      return result.statusCode == 200;
    } catch (e) {
      debugPrint('Error when reset password User: $e');
      return false;
    }
  }

  static Future<bool> changePassword({
    // required String oldPassword,
    required String newPassword,
  }) async {
    try {
      final user = Preferences.getUser();
      if (user == null) throw Exception('User data not found');
      final result = await ApiClient.insertDataToModel(
        model: 'user/change-password/${user.id}',
        payload: {'password': newPassword},
      );
      return result.statusCode == 200;
    } catch (e) {
      debugPrint('Error when change password User: $e');
      return false;
    }
  }
}
