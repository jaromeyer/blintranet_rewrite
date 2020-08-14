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
    String displayString;
    if (_lessonType == LessonTypes.canceled) {
      displayString = "(${_titleString()})";
    } else {
      displayString = _titleString();
    }
    if (_childLesson == null) {
      return displayString;
    } else {
      return displayString + "\n\n" + _childLesson._titleString();
    }
  }

  Color _color() {
    switch (_lessonType) {
      case LessonTypes.canceled:
        return Color(0xFFFF0000);
      case LessonTypes.shifted:
      case LessonTypes.added:
      case LessonTypes.blockSubstitution:
      case LessonTypes.roomReservation:
        return Color(0xFF0000FF);
      default:
        return Colors.white;
    }
  }

  TextSpan displaySpan() {
    List<TextSpan> textSpans = [];
    if (_lessonType == LessonTypes.roomChange) {
      textSpans.add(
        TextSpan(
          text: _title + "  ",
          style: TextStyle(color: Colors.white),
          children: [
            TextSpan(
              text: _roomName,
              style: TextStyle(color: Color(0xFF0000FF)),
            ),
          ],
        ),
      );
    } else {
      textSpans.add(
        TextSpan(
          text: _titleString(),
          style: TextStyle(
              color: _color(),
              decoration: _lessonType == LessonTypes.canceled
                  ? TextDecoration.lineThrough
                  : null),
        ),
      );
    }
    if (_childLesson != null) {
      textSpans.add(
        TextSpan(
          text: "\n",
          children: [
            _childLesson.displaySpan(),
          ],
        ),
      );
    }
    return TextSpan(
      children: textSpans,
    );
  }
}
