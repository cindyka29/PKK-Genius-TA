import 'dart:io';

import 'package:pkk/data/res/activities_response.dart';
import 'package:pkk/data/res/image.dart';
import 'package:pkk/data/res/response.dart';
import 'package:pkk/global/global_variable.dart';
import 'package:intl/intl.dart';
import 'package:pkk/helper/helper.dart';

class KasResponse {
  Response? response;
  Data? data;

  KasResponse({
    this.response,
    this.data,
  });

  factory KasResponse.fromJson(Map<String, dynamic> json) => KasResponse(
        response: Response.fromJson(json["response"]),
        data: Data.fromJson(json["data"]),
      );

  factory KasResponse.fromJsonById(Map<String, dynamic> json) => KasResponse(
        response: Response.fromJson(json["response"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response!.toJson(),
        "data": data!.toJson(),
      };
}

class Data {
  List<Kas>? records;

  Data({
    this.records,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        records: List<Kas>.from(json["records"].map((x) => Kas.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records!.map((x) => x.toJson())),
      };
}

class Kas {
  String? id;
  String? activityId;
  Activity? activity;
  String? keterangan;
  String? tujuan;
  DateTime? date;
  int? nominal;
  String? type;
  Image? image;

  File? localImage;

  String? get typeLabel {
    if (type == null) return null;
    return type == 'in' ? 'Pemasukan' : 'Pengeluaran';
  }

  Kas({
    this.id,
    this.activityId,
    this.activity,
    this.keterangan,
    this.tujuan,
    this.date,
    this.nominal,
    this.type,
    this.image,
    this.localImage,
  });

  factory Kas.fromJson(Map<String, dynamic> json) => Kas(
        id: json["id"],
        activityId: json["activity_id"],
        activity: Activity.fromJson(json["activity"] ?? {}),
        keterangan: json["keterangan"],
        tujuan: json["tujuan"],
        date: DateTime.tryParse(json["date"] ?? ''),
        nominal: Helper.parseNumber<int>(json["nominal"]),
        type: json["type"],
        image: Image.fromJson(json["image"] ?? {}),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "activity_id": activityId,
        "activity": activity!.toJson(),
        "keterangan": keterangan,
        "tujuan": tujuan,
        "date": DateFormat(formatDate).format(date!),
        "nominal": nominal,
        "type": type,
        "image": image?.toJson(),
      };
}

class KasTitleResponse {
  Response? response;
  KasTitle? data;

  KasTitleResponse({
    this.response,
    this.data,
  });

  factory KasTitleResponse.fromJson(Map<String, dynamic> json) =>
      KasTitleResponse(
        response: Response.fromJson(json["response"]),
        data: KasTitle.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response!.toJson(),
        "data": data!.toJson(),
      };
}

class DataKasTitle {
  List<KasTitle>? records;

  DataKasTitle({
    this.records,
  });

  factory DataKasTitle.fromJson(Map<String, dynamic> json) => DataKasTitle(
        records: List<KasTitle>.from(
            json["records"].map((x) => KasTitle.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records!.map((x) => x.toJson())),
      };
}

class KasTitle {
  String? text;
  String? value;

  KasTitle({
    this.text,
    this.value,
  });

  factory KasTitle.fromJson(Map<String, dynamic> json) => KasTitle(
        text: json["text"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
      };
}
