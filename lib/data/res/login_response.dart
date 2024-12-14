import 'package:pkk/data/res/response.dart';
import 'package:pkk/helper/helper.dart';

class LoginResponse {
  Response? response;
  Data? data;

  LoginResponse({
    this.response,
    this.data,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) => LoginResponse(
        response: Response.fromJson(json["response"]),
        data: Data.fromJson(json["data"]),
      );

  Map<String, dynamic> toJson() => {
        "phone": response!.toJson(),
        "password": data!.toJson(),
      };
}

class Data {
  Token? token;

  Data({
    this.token,
  });

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        token: Token.fromJson(json["token"]),
      );

  Map<String, dynamic> toJson() => {
        "token": token!.toJson(),
      };
}

class Token {
  String? accessToken;
  String? tokenType;
  int? expiresIn;

  Token({
    this.accessToken,
    this.tokenType,
    this.expiresIn,
  });

  factory Token.fromJson(Map<String, dynamic> json) => Token(
        accessToken: json["access_token"],
        tokenType: json["token_type"],
        expiresIn: Helper.parseNumber<int>(json["expires_in"]),
      );

  Map<String, dynamic> toJson() => {
        "access_token": accessToken,
        "token_type": tokenType,
        "expires_in": expiresIn,
      };
}
