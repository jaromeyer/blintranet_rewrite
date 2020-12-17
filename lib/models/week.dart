import 'dart:collection';

import 'package:intl/intl.dart';

import 'day.dart';

class Week {
  final List<Day> days = [
    new Day(),
    new Day(),
    new Day(),
    new Day(),
    new Day()
  ];

  final Set<String> lessonTimes = new SplayTreeSet<String>();

  Week.fromJson(Map<String, dynamic> json) {
    // iterate over lessons
    for (Map<String, dynamic> jsonLesson in json['data']) {
      // add lesson time
      String time = jsonLesson['lessonStart'].substring(0, 5);
      lessonTimes.add(time);
      int weekday =
          DateFormat("yyyy-MM-dd").parse(jsonLesson['lessonDate']).weekday;
      days[weekday - 1].add(jsonLesson);
    }
  }
}
