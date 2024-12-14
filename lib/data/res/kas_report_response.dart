import 'dart:core';

import 'package:pkk/data/res/kas_response.dart';
import 'package:pkk/helper/helper.dart';

class KasReportResponse {
  Response? response;
  KasReportData? data;

  KasReportResponse({this.response, this.data});

  KasReportResponse.fromJson(Map<String, dynamic> json) {
    response =
        json['response'] != null ? Response.fromJson(json['response']) : null;
    data = json['data'] != null ? KasReportData.fromJson(json['data']) : null;
  }
}

class Response {
  int? status;
  String? message;

  Response({this.status, this.message});

  Response.fromJson(Map<String, dynamic> json) {
    status = Helper.parseNumber<int>(json['status']);
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    data['message'] = message;
    return data;
  }
}

class KasReportData {
  List<Kas>? kasIn;
  List<Kas>? kasOut;

  KasReportData({this.kasIn, this.kasOut});

  List<Kas> _parse(List data) {
    final List<Kas> result = [];
    for (int i = 0; i < data.length; i++) {
      final Map<String, dynamic> item = data[i];
      final date = DateTime.tryParse(item['date']);
      final nominal = item['nominal'];
      if (date == null || nominal == null) continue;
      result.add(Kas(date: date, nominal: nominal));
    }
    return result;
  }

  KasReportData.fromJson(Map<String, dynamic> json) {
    if (json['in'] != null) {
      kasIn = _parse(json['in']);
    }
    if (json['out'] != null) {
      kasOut = _parse(json['out']);
    }
  }
}
