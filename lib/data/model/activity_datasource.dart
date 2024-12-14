import 'package:flutter/material.dart';
import 'package:pkk/data/res/activities_response.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class ActivityDatasource extends CalendarDataSource<Activity> {
  ActivityDatasource(List<Activity> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].date;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].date;
  }

  @override
  String getSubject(int index) {
    return appointments![index].name;
  }

  @override
  Color getColor(int index) {
    return Colors.orange;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }
}
