import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pkk/data/api/member_function.dart';
import 'package:pkk/data/api/user_function.dart';
import 'package:pkk/data/res/user_response.dart';

class AnggotaProvider extends ChangeNotifier {
  final List<User> _listUsers = [];

  UnmodifiableListView<User> get listUsers => UnmodifiableListView(_listUsers);

  Future<void> getUsersList() async {
    final listUser = await MemberFunction.getUserList();

    if (listUser != null) {
      _listUsers.clear();
      _listUsers.addAll(listUser);
    }

    notifyListeners();
  }

  Future<bool> deleteUser(String userId) async {
    final isSuccess = await UserFunction.deleteUser(userId);
    if (isSuccess) {
      await getUsersList();
    }
    return isSuccess;
  }

  Future<bool> changeUserStatus(String userId, {bool isActive = true}) async {
    final isSuccess =
        await UserFunction.changeUserStatus(userId, isActive: isActive);
    if (isSuccess) {
      await getUsersList();
    }
    return isSuccess;
  }

  Future<bool> resetPassword(String userId) async {
    final isSuccess = await UserFunction.resetPassword(userId);
    if (isSuccess) {
      await getUsersList();
    }
    return isSuccess;
  }
}
