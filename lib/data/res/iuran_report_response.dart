import 'package:pkk/helper/helper.dart';

class IuranReportResponse {
  final Response response;
  final IuranReportData data;

  IuranReportResponse({
    required this.response,
    required this.data,
  });

  IuranReportResponse copyWith({
    Response? response,
    IuranReportData? data,
  }) =>
      IuranReportResponse(
        response: response ?? this.response,
        data: data ?? this.data,
      );

  factory IuranReportResponse.fromJson(Map<String, dynamic> json) =>
      IuranReportResponse(
        response: Response.fromJson(json["response"]),
        data: IuranReportData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response.toJson(),
        "data": data.toJson(),
      };
}

class IuranReportData {
  final List<Iuran> dataIn;
  final List<Iuran> out;

  IuranReportData({
    required this.dataIn,
    required this.out,
  });

  IuranReportData copyWith({
    List<Iuran>? dataIn,
    List<Iuran>? out,
  }) =>
      IuranReportData(
        dataIn: dataIn ?? this.dataIn,
        out: out ?? this.out,
      );

  factory IuranReportData.fromJson(Map<String, dynamic> json) =>
      IuranReportData(
        dataIn: List<Iuran>.from(json["in"].map((x) => Iuran.fromJson(x))),
        out: List<Iuran>.from(json["out"].map((x) => Iuran.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "in": List<dynamic>.from(dataIn.map((x) => x.toJson())),
        "out": List<dynamic>.from(out.map((x) => x.toJson())),
      };
}

class Iuran {
  final int nominal;
  final DateTime date;

  Iuran({
    required this.nominal,
    required this.date,
  });

  Iuran copyWith({
    int? nominal,
    DateTime? date,
  }) =>
      Iuran(
        nominal: nominal ?? this.nominal,
        date: date ?? this.date,
      );

  factory Iuran.fromJson(Map<String, dynamic> json) => Iuran(
        nominal: Helper.parseNumber<int>(json["nominal"]) ?? 0,
        date: DateTime.parse(json["date"]),
      );

  Map<String, dynamic> toJson() => {
        "nominal": nominal,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
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
