import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pkk/data/api/iuran_function.dart';
import 'package:pkk/data/res/iuran_rekap_response.dart';

class RekapProvider extends ChangeNotifier {

  final List<IuranRekapUserElement> _listRekapIuran = [];
  UnmodifiableListView<IuranRekapUserElement> get listRekapIuran => UnmodifiableListView(
    _listRekapIuran
  );

  Future<void> getlistRekapIuran({required String activityId}) async {
    final list = await IuranFunction.getRekapIuran(activityId);
    if (list != null) {
      _listRekapIuran.clear();
      _listRekapIuran.addAll(list);
    }
    notifyListeners();
  }
}
