import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pkk/data/api/iuran_function.dart';
import 'package:pkk/data/res/activities_response.dart';
import 'package:pkk/data/res/iuran_response.dart';

class KegiatanIuranProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Activity _activity = Activity();
  Activity get activity => _activity;

  final List<UserElement> _userElementList = [];
  UnmodifiableListView<UserElement> get userElementList =>
      UnmodifiableListView(_userElementList);

  Future<void> getUserIuranList(String activityId) async {
    _isLoading = true;
    _userElementList.clear();
    _activity = Activity();
    notifyListeners();
    final response = await IuranFunction.getUserIuranList(activityId);
    _activity = response?.activity ?? _activity;
    _userElementList.addAll(response?.users ?? []);
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> updateUserIuranStatus({
    required int userIndex,
    required bool isPaid,
  }) async {
    final iuranId = userElementList[userIndex].idIuran;
    _isLoading = true;
    notifyListeners();

    bool isSuccess = false;
    if (isPaid) {
      if (iuranId != null) {
        isSuccess = await IuranFunction.putUserIuranStatus(
          iuranId: iuranId,
          userId: userElementList[userIndex].userId!,
          activityId: userElementList[userIndex].activityId!,
          isPaid: isPaid,
          nominal: userElementList[userIndex].nominal ?? 0,
        );
      } else {
        isSuccess = await IuranFunction.postUserIuranStatus(
          userId: userElementList[userIndex].userId!,
          activityId: userElementList[userIndex].activityId!,
          isPaid: isPaid,
          nominal: userElementList[userIndex].nominal ?? 0,
        ).then((iuranId) => iuranId != null);
      }
    } else {
      isSuccess = await IuranFunction.deleteUserIuranStatus(
        iuranId: iuranId!,
      );
    }
    if (isSuccess) {
      await getUserIuranList(activity.id!);
      Fluttertoast.showToast(msg: 'Berhasil ubah status');
    } else {
      Fluttertoast.showToast(msg: 'Gagal ubah status');
      _isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }

  Future<bool> updateUserIuranNominal({
    required int userIndex,
    required int nominal,
  }) async {
    final iuranId = userElementList[userIndex].idIuran;
    if (iuranId == null) return false;
    if (userElementList[userIndex].isPaid == 0) return false;
    _isLoading = true;
    notifyListeners();

    final isSuccess = await IuranFunction.putUserIuranStatus(
      iuranId: iuranId,
      userId: userElementList[userIndex].userId!,
      activityId: userElementList[userIndex].activityId!,
      isPaid: userElementList[userIndex].isPaid == 1,
      nominal: nominal,
    );
    if (isSuccess) {
      await getUserIuranList(activity.id!);
      Fluttertoast.showToast(msg: 'Berhasil ubah status');
    } else {
      Fluttertoast.showToast(msg: 'Gagal ubah status');
      _isLoading = false;
      notifyListeners();
    }
    return isSuccess;
  }
}
