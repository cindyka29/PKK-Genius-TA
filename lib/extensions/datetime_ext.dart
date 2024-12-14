import 'package:intl/intl.dart';

extension DatetimeExt on DateTime {
  String get monthName => DateFormat('MMMM').format(this);
  String toDMmmmYyyy() => DateFormat('d MMMM yyyy').format(this);
  String toYMD() => DateFormat('yyyy-MM-dd').format(this);
  String toYM() => DateFormat('yyyy-MM').format(this);
}
