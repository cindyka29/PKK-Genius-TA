import 'response.dart';

class DocumentationsResponse {
  Response response;
  List<Datum> data;

  DocumentationsResponse({
    required this.response,
    required this.data,
  });

  factory DocumentationsResponse.fromJson(Map<String, dynamic> json) =>
      DocumentationsResponse(
        response: Response.fromJson(json["response"]),
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "response": response.toJson(),
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  String id;
  String name;
  String note;
  DateTime date;
  String? programId;
  List<Documentation> documentations;

  Datum({
    required this.id,
    required this.name,
    required this.note,
    required this.date,
    required this.programId,
    required this.documentations,
  });

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        name: json["name"],
        note: json["note"],
        date: DateTime.parse(json["date"]),
        programId: json["program_id"],
        documentations: List<Documentation>.from(
            json["documentations"].map((x) => Documentation.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "note": note,
        "date":
            "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "program_id": programId,
        "documentations":
            List<dynamic>.from(documentations.map((x) => x.toJson())),
      };
}

class Documentation {
  int id;
  String name;
  String url;

  Documentation({
    required this.id,
    required this.name,
    required this.url,
  });

  factory Documentation.fromJson(Map<String, dynamic> json) => Documentation(
        id: json["id"],
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
      };
}
