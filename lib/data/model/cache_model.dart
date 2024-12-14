class CacheModel {
  final DateTime dateUpdated;
  final dynamic data;

  CacheModel({required this.dateUpdated, required this.data});

  Map<String, dynamic> toJson() {
    return {
      'dateUpdated': dateUpdated.toIso8601String(),
      'data': data,
    };
  }

  static CacheModel fromJson(Map<String, dynamic> json) {
    return CacheModel(
      dateUpdated: DateTime.parse(json['dateUpdated']),
      data: json['data'],
    );
  }
}
