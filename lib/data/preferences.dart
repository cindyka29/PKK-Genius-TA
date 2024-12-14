import 'dart:convert';

import 'package:pkk/data/res/user_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class Preferences {
  static SharedPreferences? _preferences;
  static const _userKey = "user";
  static const _tokenKey = 'token';

  static Future init() async {
    _preferences ??= await SharedPreferences.getInstance();
  }

  static Future clear() async {
    return await _preferences?.clear();
  }

  static Future<bool?> clearSession() async {
    return await _preferences?.remove(
      _tokenKey,
    );
  }

  static Future setSession({required String token}) async {
    return await _preferences?.setString(
      _tokenKey,
      token,
    );
  }

  static Future setUser({required User user}) async {
    await _preferences?.remove(_userKey);

    return await _preferences?.setString(
      _userKey,
      json.encode(user.toJson()),
    );
  }

  static String? getToken() {
    return _preferences?.getString(_tokenKey);
  }

  static User? getUser() {
    final result = _preferences?.getString(_userKey);

    if (result != null) {
      return User.fromJson(json.decode(result));
    }
    return null;
  }
}
