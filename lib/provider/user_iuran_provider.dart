import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pkk/data/api/iuran_function.dart';
import 'package:pkk/data/res/iuran_response.dart';


class UserIuranProvider extends ChangeNotifier {
  final List<UserElement> _listIuran = [];

  UnmodifiableListView<UserElement> get listIuran =>
      UnmodifiableListView(_listIuran);

  Future<void> getIuran() async {
    _listIuran.clear();
    final result = await IuranFunction.getIuranByUserId();

    if (result != null) {
      _listIuran.addAll(result);
    }
    notifyListeners();
  }
}
