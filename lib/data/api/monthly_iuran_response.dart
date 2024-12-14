import 'package:pkk/helper/helper.dart';

class MonthlyIuransResponse {
  final Response response;
  final MonthlyIuransData data;

  MonthlyIuransResponse({
    required this.response,
    required this.data,
  });

  MonthlyIuransResponse copyWith({
    Response? response,
    MonthlyIuransData? data,
  }) =>
      MonthlyIuransResponse(
        response: response ?? this.response,
        data: data ?? this.data,
      );

  factory MonthlyIuransResponse.fromJson(Map<String, dynamic> json) =>
      MonthlyIuransResponse(
        response: Response.fromJson(json["response"]),
        data: MonthlyIuransData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response.toJson(),
        "data": data.toJson(),
      };
}

class MonthlyIuransData {
  final List<MonthlyIuranRecord> records;

  MonthlyIuransData({
    required this.records,
  });

  MonthlyIuransData copyWith({
    List<MonthlyIuranRecord>? records,
  }) =>
      MonthlyIuransData(
        records: records ?? this.records,
      );

  factory MonthlyIuransData.fromJson(Map<String, dynamic> json) =>
      MonthlyIuransData(
        records: List<MonthlyIuranRecord>.from(
            json["records"].map((x) => MonthlyIuranRecord.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records.map((x) => x.toJson())),
      };
}

class MonthlyIuranRecord {
  final String text;
  final String value;

  MonthlyIuranRecord({
    required this.text,
    required this.value,
  });

  MonthlyIuranRecord copyWith({
    String? text,
    String? value,
  }) =>
      MonthlyIuranRecord(
        text: text ?? this.text,
        value: value ?? this.value,
      );

  factory MonthlyIuranRecord.fromJson(Map<String, dynamic> json) =>
      MonthlyIuranRecord(
        text: json["text"],
        value: json["value"],
      );

  Map<String, dynamic> toJson() => {
        "text": text,
        "value": value,
      };
}

class Response {
  final int status;
  final String message;

  Response({
    required this.status,
    required this.message,
  });

  Response copyWith({
    int? status,
    String? message,
  }) =>
      Response(
        status: status ?? this.status,
        message: message ?? this.message,
      );

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: Helper.parseNumber<int>(json["status"]) ?? 500,
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
