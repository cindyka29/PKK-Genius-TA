import 'package:pkk/data/res/activities_response.dart';
import 'package:pkk/data/res/response.dart';
import 'package:pkk/data/res/user_response.dart';
import 'package:pkk/helper/helper.dart';

class AbsencesResponse {
  Response? response;
  Data? data;

  AbsencesResponse({
    this.response,
    this.data,
  });

  factory AbsencesResponse.fromJson(Map<String, dynamic> json) =>
      AbsencesResponse(
        response: Response.fromJson(json["response"]),
        data: Data.fromJson(json["data"]),
      );

  factory AbsencesResponse.fromJson2(Map<String, dynamic> json) =>
      AbsencesResponse(
        response: Response.fromJson(json["response"]),
        data: Data.fromJson2(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "response": response!.toJson(),
        "data": data!.toJson(),
      };
}

class Data {
  List<UserElement>? users;
  Activity? activity;

  Data({
    this.users,
    this.activity,
  });

  factory Data.fromAbsence(Map<String, dynamic> json) => Data(
        users: List<UserElement>.from(
            json["records"].map((x) => UserElement.fromJson(x))),
      );

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        users: List<UserElement>.from(
            json["users"].map((x) => UserElement.fromJson(x))),
        activity: json["activity"] != null
            ? Activity.fromJson(json["activity"])
            : null,
      );

  factory Data.fromJson2(Map<String, dynamic> json) => Data(
        users: List<UserElement>.from(json["users"].map(
          (x) => UserElement(
            isAttended: 0,
            userId: x["id"],
            user: User.fromJson(x ?? {}),
            activityId: json["activity"]["id"],
          ),
        )),
        activity: Activity.fromJson(json["activity"]),
      );
  Map<String, dynamic> toJson() => {
        "users": List<dynamic>.from(users!.map((x) => x.toJson())),
        "activity": activity!.toJson(),
      };
}

class UserElement {
  String? absenceId;
  int? isAttended;
  String? userId;
  User? user;
  String? activityId;
  Activity? activity;

  UserElement({
    this.absenceId,
    this.isAttended,
    this.userId,
    this.user,
    this.activityId,
    this.activity,
  });

  factory UserElement.fromJson(Map<String, dynamic> json) => UserElement(
      absenceId: json["absence_id"],
      isAttended: Helper.parseNumber<int>(json["is_attended"]),
      userId: json["user_id"],
      user: User.fromJson(json["user"] ?? {}),
      activityId: json["activity_id"],
      activity: Activity.fromAbsence(json['activity'] ?? {}));

  Map<String, dynamic> toJson() => {
        "is_attended": isAttended,
        "user_id": userId,
        "activity_id": activityId,
      };
}
