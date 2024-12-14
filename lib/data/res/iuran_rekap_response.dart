import 'package:pkk/helper/helper.dart';

import 'response.dart';

class RekapIuran {
  Response? response;
  IuranRekapData? data;

  RekapIuran({
    this.response,
    this.data,
  });

  factory RekapIuran.fromJson(Map<String, dynamic> json) => RekapIuran(
        response: json["response"] == null
            ? null
            : Response.fromJson(json["response"]),
        data:
            json["data"] == null ? null : IuranRekapData.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response?.toJson(),
        "data": data?.toJson(),
      };
}

class IuranRekapData {
  List<IuranRekapUserElement>? users;
  IuranRekapActivity? activity;

  IuranRekapData({
    this.users,
    this.activity,
  });

  factory IuranRekapData.fromJson(Map<String, dynamic> json) => IuranRekapData(
        users: json["users"] == null
            ? []
            : List<IuranRekapUserElement>.from(
                json["users"]!.map((x) => IuranRekapUserElement.fromJson(x))),
        activity: json["activity"] == null
            ? null
            : IuranRekapActivity.fromJson(json["activity"]),
      );

  Map<String, dynamic> toJson() => {
        "users": users == null
            ? []
            : List<dynamic>.from(users!.map((x) => x.toJson())),
        "activity": activity?.toJson(),
      };
}

class IuranRekapActivity {
  String? id;
  String? name;
  String? note;
  DateTime? date;
  String? programId;
  DateTime? updatedAt;

  IuranRekapActivity({
    this.id,
    this.name,
    this.note,
    this.date,
    this.programId,
    this.updatedAt,
  });

  factory IuranRekapActivity.fromJson(Map<String, dynamic> json) =>
      IuranRekapActivity(
        id: json["id"],
        name: json["name"],
        note: json["note"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        programId: json["program_id"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "note": note,
        "date":
            "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "program_id": programId,
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class IuranRekapUserElement {
  bool? isPaid;
  int? nominal;
  String? userId;
  IuranRekapUserUser? user;
  String? activityId;
  DateTime? updatedAt;

  IuranRekapUserElement({
    this.isPaid,
    this.nominal,
    this.userId,
    this.user,
    this.activityId,
    this.updatedAt,
  });

  factory IuranRekapUserElement.fromJson(Map<String, dynamic> json) =>
      IuranRekapUserElement(
        isPaid: json["is_paid"] == 1 || json["is_paid"] == '1',
        nominal: Helper.parseNumber<int>(json["nominal"]),
        userId: json["user_id"],
        user: json["user"] == null
            ? null
            : IuranRekapUserUser.fromJson(json["user"]),
        activityId: json["activity_id"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "is_paid": (isPaid ?? false) ? 1 : 0,
        "nominal": nominal,
        "user_id": userId,
        "user": user?.toJson(),
        "activity_id": activityId,
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class IuranRekapUserUser {
  String? id;
  String? name;
  String? username;
  String? phone;
  String? role;
  String? jatabatan;
  int? isActive;
  String? image;
  DateTime? updatedAt;

  IuranRekapUserUser({
    this.id,
    this.name,
    this.username,
    this.phone,
    this.role,
    this.jatabatan,
    this.isActive,
    this.image,
    this.updatedAt,
  });

  factory IuranRekapUserUser.fromJson(Map<String, dynamic> json) =>
      IuranRekapUserUser(
        id: json["id"],
        name: json["name"],
        username: json["username"],
        phone: json["phone"],
        role: json["role"],
        jatabatan: json["jatabatan"],
        isActive: Helper.parseNumber<int>(json["is_active"]),
        image: json["image"],
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "username": username,
        "phone": phone,
        "role": role,
        "jatabatan": jatabatan,
        "is_active": isActive,
        "image": image,
        "updated_at": updatedAt?.toIso8601String(),
      };
}
