import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:pkk/data/api/absence_function.dart';
import 'package:pkk/data/res/absence_response.dart';

class UserAbsenceProvider extends ChangeNotifier {
  final List<UserElement> _listAbsence = [];

  UnmodifiableListView<UserElement> get listAbsence =>
      UnmodifiableListView(_listAbsence);

  Future<void> getAbsences() async {
    _listAbsence.clear();
    final result = await AbsenceFunction.getAbsenceByUserId();

    if (result != null) {
      _listAbsence.addAll(result);
    }
    notifyListeners();
  }
}
