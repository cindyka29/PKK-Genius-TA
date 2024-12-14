import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pkk/data/api/absence_function.dart';
import 'package:pkk/data/res/absence_response.dart';
import 'package:pkk/data/res/activities_response.dart';

class KegiatanAbsensiProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Activity _activity = Activity();
  Activity get activity => _activity;

  final List<UserElement> _userElementList = [];
  UnmodifiableListView<UserElement> get userElementList =>
      UnmodifiableListView(_userElementList);

  Future<void> getUserAbsenceList(String activityId) async {
    _isLoading = true;
    _userElementList.clear();
    _activity = Activity();
    notifyListeners();
    final response = await AbsenceFunction.getUserAbsenceList(activityId);
    _activity = response?.activity ?? _activity;
    _userElementList.addAll(response?.users ?? []);
    _isLoading = false;
    notifyListeners();
  }

  Future<bool>  updateUserAbsenceStatus(
      {String? id,
      required int userIndex,
      required bool isAttended}) async {
    _isLoading = true;
    notifyListeners();
    final isSuccess = await AbsenceFunction.putUserAbsenceStatus(
        id: id,
        userId: userElementList[userIndex].user!.id!,
        activityId: userElementList[userIndex].activityId!,
        isAttended: isAttended);
    if (isSuccess) {
      _userElementList[userIndex].isAttended = isAttended ? 1 : 0;
      Fluttertoast.showToast(msg: 'Berhasil ubah status');
    } else {
      Fluttertoast.showToast(msg: 'Gagal ubah status');
    }
    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }
}
