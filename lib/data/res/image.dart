import 'package:pkk/helper/helper.dart';

class Image {
  int? id;
  String? name;
  String? url;

  Image({
    this.id,
    this.name,
    this.url,
  });

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        id: Helper.parseNumber<int>(json["id"]),
        name: json["name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "url": url,
      };
}
