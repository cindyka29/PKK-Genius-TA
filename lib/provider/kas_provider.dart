import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pkk/data/api/activity_function.dart';
import 'package:pkk/data/api/kas_function.dart';
import 'package:pkk/data/res/activities_response.dart';
import 'package:pkk/data/res/kas_response.dart';

class KasProvider extends ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  final Map<String, String> _kasMonthMap = {};
  UnmodifiableMapView<String, String> get kasMonthMap =>
      UnmodifiableMapView(_kasMonthMap);
  UnmodifiableListView<String> get kasMonths =>
      UnmodifiableListView(_kasMonthMap.keys);

  final List<Kas> _kasList = [];
  UnmodifiableListView<Kas> get kasList => UnmodifiableListView(_kasList);

  String? _kasIdSelected;
  set kasIdSelected(String value) => _kasIdSelected = value;
  Kas _kasDetail = Kas();
  Kas get kasDetail => _kasDetail;
  final List<Activity> _activitiyList = [];
  UnmodifiableListView<Activity> get activityList =>
      UnmodifiableListView(_activitiyList);

  Future<void> getKasMonths() async {
    _isLoading = true;
    _kasMonthMap.clear();
    notifyListeners();
    final result = await KasFunction.fetchKasMonths();
    _kasMonthMap.addAll(result);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getKasList({required String monthCode}) async {
    _isLoading = true;
    _kasList.clear();
    notifyListeners();
    final result = await KasFunction.fetchKasList(monthCode: monthCode);
    _kasList.addAll(result ?? []);
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getKasDetail() async {
    assert(_kasIdSelected != null);
    _isLoading = true;
    notifyListeners();
    final result = await KasFunction.fetchKas(id: _kasIdSelected!);
    _kasDetail = result ?? Kas();
    notifyListeners();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> getActivityList() async {
    _isLoading = true;
    _activitiyList.clear();
    notifyListeners();
    final result = await ActivityFunction.fetchActivityList();
    _activitiyList.addAll(result ?? []);
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> saveKas(Kas kas) async {
    _isLoading = true;
    notifyListeners();
    final isSuccess = await KasFunction.postKas(kas);
    if (isSuccess) {
      Fluttertoast.showToast(msg: 'Data berhasil disimpan');
    } else {
      Fluttertoast.showToast(msg: 'Data gagal disimpan');
    }
    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> downloadKasMonthlyReport(String monthCode) async {
    _isLoading = true;
    notifyListeners();
    final isSuccess = await KasFunction.downloadKasMonthlyReport(monthCode);
    if (!isSuccess) {
      Fluttertoast.showToast(msg: 'Gagal download file');
    }
    _isLoading = false;
    notifyListeners();
    return isSuccess;
  }

  Future<bool> deleteKas(String idKas) async {
    try {
      final isSuccess = await KasFunction.deleteKas(idKas);
      return isSuccess;
    } catch (e, stacktrace) {
      debugPrint('Error function deleteKas Kas: $e\n$stacktrace');
    }
    return false;
  }
}
