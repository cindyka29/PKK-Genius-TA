import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:pkk/data/api/api_client.dart';
import 'package:pkk/data/preferences.dart';
import 'package:pkk/data/res/login_response.dart';
import 'package:pkk/data/res/user_response.dart';
import 'package:pkk/data/res/validate_response.dart';

abstract class AuthFunction {
  static Future<bool> login(
      {Map<String, dynamic>? payload, FormData? formData}) async {
    try {
      final result = await ApiClient.action(
          action: 'login', payload: payload, formData: formData);
      // debugPrint(result.data.toString());
      if (result.statusCode == 200) {
        final dataLogin = LoginResponse.fromJson(result.data);
        // debugPrint(dataLogin.data.toString());
        if (dataLogin.response?.status == 200) {
          await Preferences.init();
          await Preferences.setSession(
              token: dataLogin.data?.token?.accessToken ?? '');
          ApiClient.initToken(bearerToken: Preferences.getToken() ?? '');
          final userLogin = await ApiClient.action(action: 'validate-token');
          if (userLogin.statusCode == 200) {
            debugPrint(userLogin.data.toString());
            final user = ValidateResponse.fromJson(userLogin.data);
            await Preferences.setUser(user: user.data?.user ?? User());

            return true;
          }
        }
      }
    } catch (e, stacktrace) {
      debugPrint('Error when doing Login: $e\n$stacktrace');
      return false;
    }
    return false;
  }

  static Future<bool> logout() async {
    try {
      final result = await ApiClient.dio.delete('${ApiClient.apiUrl}/logout');
      if (result.statusCode != 200) return false;
      await Future.wait(
          [Preferences.clear(), ApiClient.cacheManager.emptyCache()]);
      ApiClient.initToken(bearerToken: '');
      return true;
    } catch (e) {
      debugPrint('Error when doing Login: $e');
      return false;
    }
  }
}
