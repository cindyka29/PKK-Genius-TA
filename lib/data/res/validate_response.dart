import 'package:pkk/data/res/response.dart';
import 'package:pkk/data/res/user_response.dart';

class ValidateResponse {
    Response? response;
    Data? data;

    ValidateResponse({
        this.response,
        this.data,
    });

    factory ValidateResponse.fromJson(Map<String, dynamic> json) => ValidateResponse(
        response: Response.fromJson(json["response"]),
        data: Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "response": response!.toJson(),
        "data": data!.toJson(),
    };
}

class Data {
    User? user;

    Data({
        this.user,
    });

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "user": user!.toJson(),
    };
}