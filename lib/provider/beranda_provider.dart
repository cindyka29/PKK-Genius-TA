import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pkk/data/api/activity_function.dart';
import 'package:pkk/data/api/auth_function.dart';
import 'package:pkk/data/api/iuran_function.dart';
import 'package:pkk/data/api/kas_function.dart';
import 'package:pkk/data/api/program_function.dart';
import 'package:pkk/data/res/activities_response.dart';
import 'package:pkk/data/res/documentations_response.dart';
import 'package:pkk/data/res/iuran_report_response.dart';
import 'package:pkk/data/res/kas_report_response.dart';
import 'package:pkk/data/res/kas_response.dart';
import 'package:pkk/data/res/program_response.dart';

class BerandaProvider extends ChangeNotifier {
  // Program? _program;
  // Activity? _activity;
  // Kas? _kas;

  final List<Program> _listProgram = [];
  final List<Activity> _listActivity = [];
  final List<Datum> _listActivityDocs = [];
  final List<Kas> _listKas = [];
  KasReportData _kasReportData = KasReportData();
  IuranReportData _iuranReportData = IuranReportData(dataIn: [], out: []);

  KasReportData get kasReportData => _kasReportData;
  UnmodifiableListView<Program> get listProgram =>
      UnmodifiableListView(_listProgram);
  UnmodifiableListView<Activity> get listActivity =>
      UnmodifiableListView(_listActivity);
  UnmodifiableListView<Datum> get listActivityDocs =>
      UnmodifiableListView(_listActivityDocs);
  UnmodifiableListView<Kas> get listKas => UnmodifiableListView(_listKas);
  IuranReportData get iuranReportData => _iuranReportData;

  Future<void> fetchProgram({bool isNotify = true}) async {
    final listProgram = await ProgramFunction.getProgramList();

    if (listProgram != null) {
      _listProgram.clear();
      _listProgram.addAll(listProgram);
    }
    if (isNotify) notifyListeners();
  }

  Future<void> fetchActivity({bool isNotify = true}) async {
    final listActivity = await ActivityFunction.fetchActivityList();

    if (listActivity != null) {
      _listActivity.clear();
      _listActivity.addAll(listActivity);
      await fetchActivityDocs();
    }

    _listActivity.sort((a, b) {
      if (a.date != null && b.date != null) {
        return a.date!.compareTo(b.date!);
      }
      return 0;
    });
    if (isNotify) notifyListeners();
  }

  Future<void> fetchActivityDocs() async {
    final listDocumentations = await ActivityFunction.getDocumentation();

    if (listDocumentations != null) {
      _listActivityDocs.clear();
      _listActivityDocs.addAll(listDocumentations);
    }

    notifyListeners();
  }

  Future<bool> saveActivity(Activity activity) async {
    final isSuccess = await ActivityFunction.addActivity(activity: activity);
    if (isSuccess) {
      Fluttertoast.showToast(msg: 'Aktivitas berhasil ditambahkan');
    } else {
      Fluttertoast.showToast(msg: 'Aktivitas gagal ditambahkan');
    }
    return isSuccess;
  }

  Future<void> fetchKasReport({bool isNotify = true}) async {
    final result = await KasFunction.fetchKasReport();
    if (result != null) {
      _kasReportData = result;
      if (isNotify) notifyListeners();
    }
  }

  Future<void> fetchIuranReport({bool isNotify = true}) async {
    final result = await IuranFunction.getIuranReport();
    _iuranReportData = result;
    if (isNotify) notifyListeners();
  }

  Future<void> getAllBerandaData() async {
    await Future.wait([
      fetchProgram(isNotify: false),
      fetchActivity(isNotify: false),
      fetchKasReport(isNotify: false),
      fetchIuranReport(isNotify: false),
    ]);
    notifyListeners();
  }

  Future<bool> addDocumentation(Activity activity) async {
    final isSuccess =
        await ActivityFunction.addDocumentation(activity: activity);
    if (isSuccess) {
      Fluttertoast.showToast(msg: 'Dokumen berhasil ditambahkan');
    } else {
      Fluttertoast.showToast(msg: 'Dokumen gagal ditambahkan');
    }
    notifyListeners();
    return isSuccess;
  }

  Future<bool> logout() async {
    return await AuthFunction.logout();
  }
}
