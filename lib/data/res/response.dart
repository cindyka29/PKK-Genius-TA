import 'package:pkk/helper/helper.dart';

class Response {
  int? status;
  String? message;

  Response({
    this.status,
    this.message,
  });

  factory Response.fromJson(Map<String, dynamic> json) => Response(
        status: Helper.parseNumber<int>(json["status"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "message": message,
      };
}
