import 'package:pkk/data/res/response.dart';
import 'package:pkk/helper/helper.dart';

class UsersResponse {
  Response? response;
  Data? data;

  UsersResponse({
    this.response,
    this.data,
  });

  factory UsersResponse.fromJson(Map<String, dynamic> json) => UsersResponse(
        response: Response.fromJson(json["response"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response!.toJson(),
        "data": data!.toJson(),
      };
}

class Data {
  List<User>? records;

  Data({
    this.records,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        records: List<User>.from(json["records"].map((x) => User.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "records": List<dynamic>.from(records!.map((x) => x.toJson())),
      };
}

class User {
  String? id;
  String? name;
  String? username;
  String? phone;
  String? role;
  String? jabatan;
  int? isActive;
  String? image;

  User({
    this.id,
    this.name,
    this.username,
    this.phone,
    this.role,
    this.jabatan,
    this.isActive,
    this.image,
  });

  factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        phone: json["phone"],
        role: json["role"],
        jabatan: json["jatabatan"],
        isActive: Helper.parseNumber<int>(json["is_active"]),
        image: json["image"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "phone": phone,
        "role": role,
        "jatabatan": jabatan,
        "is_active": isActive,
        "image": image,
      };
}
