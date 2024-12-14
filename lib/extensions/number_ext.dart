import 'package:intl/intl.dart';

extension NumExt on num {
  String toIndonesianFormat() {
    final NumberFormat formatter = NumberFormat.decimalPattern('id');
    return formatter.format(this);
  }
}
