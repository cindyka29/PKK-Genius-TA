import 'dart:developer';

import 'type_helper.dart';

class Helper {
  static T? parseNumber<T extends num>(dynamic value) {
    log('user element absence: $value: ${value.runtimeType} || ${value is String}');
    if (value is String) {
      try {
        if (TypeHelper<T>() >= const TypeHelper<int>()) {
          return int.parse(value) as T;
        } else if (TypeHelper<T>() >= const TypeHelper<double>()) {
          return double.parse(value) as T;
        } else if (TypeHelper<T>() >= const TypeHelper<num>()) {
          return num.parse(value) as T;
        }
      } catch (e) {
        return null;
      }
    } else if (value is T) {
      return value;
    }
    return null;
  }
}
