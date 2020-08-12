import 'dart:collection';

import 'package:blintranet/models/lesson.dart';
import 'package:intl/intl.dart';

class Week {
  final Map<String, List<Lesson>> lessonRows = SplayTreeMap();

  Week.fromJson(Map<String, dynamic> json) {
    for (Map<String, dynamic> jsonLesson in json['data']) {
      String time = jsonLesson['lessonStart'].substring(0, 5);

      if (!lessonRows.containsKey(time)) {
        lessonRows[time] = List(5);
      }

      DateTime lessonDate =
          DateFormat("yyyy-MM-dd").parse(jsonLesson['lessonDate']);
      Lesson newLesson = Lesson.fromJson(jsonLesson);
      // add lesson
      if (lessonRows[time][lessonDate.weekday - 1] == null) {
        lessonRows[time][lessonDate.weekday - 1] = newLesson;
      } else {
        lessonRows[time][lessonDate.weekday - 1].addChildLesson(newLesson);
      }
    }
  }
}
