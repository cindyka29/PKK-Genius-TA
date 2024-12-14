import 'dart:io';

import 'package:pkk/data/res/image.dart';
import 'package:pkk/data/res/program_response.dart';
import 'package:pkk/data/res/response.dart';
import 'package:pkk/global/global_variable.dart';
import 'package:intl/intl.dart';

class ActivitiesResponse {
  Response? response;
  Datas? datas;
  Data? data;

  ActivitiesResponse({
    this.response,
    this.datas,
    this.data,
  });

  factory ActivitiesResponse.fromJson(Map<String, dynamic> json) =>
      ActivitiesResponse(
        response: Response.fromJson(json["response"]),
        datas: Datas.fromJson(json["data"]),
      );

  factory ActivitiesResponse.fromJsonById(Map<String, dynamic> json) =>
      ActivitiesResponse(
        response: Response.fromJson(json["response"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response!.toJson(),
        "data": datas!.toJson(),
      };
}

class Datas {
  List<Activity>? records;

  Datas({
    this.records,
  });

  factory Datas.fromJson(Map<String, dynamic> json) => Datas(
        records: List<Activity>.from(
            json["records"].map((x) => Activity.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records!.map((x) => x.toJson())),
      };
}

class Data {
  Activity? record;

  Data({
    this.record,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        record: Activity.fromJson(json['record']),
      );

  Map<String, dynamic> toJson() => {
        "record": record!.toJson(),
      };
}

class Activity {
  String? id;
  String? name;
  String? note;
  DateTime? date;
  String? programId;
  Program? program;
  List<Image>? documentations;

  File? localDocumentation;

  Activity({
    this.id,
    this.name,
    this.note,
    this.date,
    this.programId,
    this.program,
    this.documentations,
    this.localDocumentation,
  });

  factory Activity.fromJson(Map<String, dynamic> json) => Activity(
        id: json["id"],
        name: json["name"],
        note: json["note"],
        date: DateTime.tryParse(json['date'] ?? ''),
        programId: json["program_id"],
        program:
            json["program"] != null ? Program.fromJson(json["program"]) : null,
        documentations: json["documentations"] != null
            ? List<Image>.from(
                json["documentations"].map((x) => Image.fromJson(x)))
            : null,
      );

  factory Activity.fromAbsence(Map<String, dynamic> json) => Activity(
        id: json["id"],
        name: json["name"],
        note: json["note"],
        date: DateTime.tryParse(json['date'] ?? ''),
        programId: json["program_id"],
      );

  Map<String, dynamic> toJson() => {
        "name": name!,
        "note": note!,
        "date": DateFormat(formatDate).format(date!),
        "program_id": programId!,
      };
}
