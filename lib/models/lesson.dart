import 'package:blintranet/constants/lesson_types.dart';
import 'package:flutter/material.dart';

class Lesson {
  final int _lessonType;
  final String _title;
  final String _roomName;
  Lesson _childLesson;

  Lesson.fromJson(Map<String, dynamic> json)
      : _lessonType = json['timetableEntryTypeId'],
        _title = json['title'],
        _roomName = json['roomName'];

  void addChildLesson(Lesson childLesson) {
    _childLesson = childLesson;
  }

  String _titleString() {
    return _title + "  " + _roomName;
  }

  String displayString() {
    if (_childLesson == null) {
      return _titleString();
    } else {
      return _titleString() + "\n" + _childLesson._titleString();
    }
  }

  Color _color() {
    switch (_lessonType) {
      case LessonTypes.canceled:
        return Colors.red;
      case LessonTypes.shifted:
      case LessonTypes.added:
      case LessonTypes.blockSubstitution:
      case LessonTypes.roomReservation:
      case LessonTypes.roomChange: // not sure
        return Color(0xFF0000FF);
      default:
        return Colors.white;
    }
  }

  TextSpan displaySpan() {
    return TextSpan(
      children: [
        TextSpan(
          text: _titleString(),
          style: TextStyle(
              color: _color(),
              decoration: _lessonType == LessonTypes.canceled
                  ? TextDecoration.lineThrough
                  : null),
        ),
        if (_childLesson != null) TextSpan(text: "\n"),
        if (_childLesson != null) _childLesson.displaySpan(),
      ],
    );
  }
}
