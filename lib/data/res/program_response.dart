import 'package:pkk/data/res/image.dart';
import 'package:pkk/data/res/response.dart';

class ProgramsResponse {
  Response? response;
  Data? data;

  ProgramsResponse({
    this.response,
    this.data,
  });

  factory ProgramsResponse.fromJson(Map<String, dynamic> json) =>
      ProgramsResponse(
        response: Response.fromJson(json["response"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response!.toJson(),
        "data": data!.toJson(),
      };
}

class Data {
  List<Program>? records;

  Data({
    this.records,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        records:
            List<Program>.from(json["records"].map((x) => Program.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records!.map((x) => x.toJson())),
      };
}

class Program {
  String? id;
  String? name;
  String? note;
  Image? image;

  Program({
    this.id,
    this.name,
    this.note,
    this.image,
  });

  factory Program.fromJson(Map<String, dynamic> json) => Program(
        id: json["id"],
        name: json["name"],
        note: json["note"],
        image: json['image'] != null
            ? Image.fromJson(
                json["image"],
              )
            : null,
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "note": note,
        "image": image!.toJson(),
      };
}
