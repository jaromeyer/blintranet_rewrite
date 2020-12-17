import 'package:auto_size_text/auto_size_text.dart';
import 'package:blintranet/constants/custom_colors.dart';
import 'package:blintranet/constants/lesson_types.dart';
import 'package:blintranet/models/lesson.dart';
import 'package:flutter/material.dart';

class LessonSlotTile extends StatelessWidget {
  final List<Lesson> _lessons;

  LessonSlotTile(List<Lesson> lessons) : _lessons = lessons;

  Color _getColor() {
    Color color = CustomColors.lightGray;
    for (Lesson lesson in _lessons) {
      switch (lesson.lessonType) {
        case LessonTypes.canceled:
          color = CustomColors.red;
          break;
        case LessonTypes.shifted:
        case LessonTypes.added:
        case LessonTypes.blockSubstitution:
        case LessonTypes.roomReservation:
          return CustomColors.blue;
      }
    }
    return color;
  }

  Color _getTextColor() {
    return _getColor() == CustomColors.lightGray
        ? CustomColors.textBlue
        : Colors.white;
  }

  TextSpan _createSlotSpan() {
    List<TextSpan> lessonSpans = new List<TextSpan>();
    for (Lesson lesson in _lessons) {
      lessonSpans.add(_createLessonSpan(lesson));
      lessonSpans.add(TextSpan(text: "\n"));
    }
    lessonSpans.removeLast(); // remove last newline span
    return TextSpan(children: lessonSpans);
  }

  TextSpan _createLessonSpan(Lesson lesson) {
    return TextSpan(
      text: lesson.title,
      style: TextStyle(
        decoration: lesson.lessonType == LessonTypes.canceled
            ? TextDecoration.lineThrough
            : null,
        fontWeight: lesson.roomName == "" ? FontWeight.normal : null,
      ),
      children: [
        TextSpan(
            text: " " + lesson.roomName,
            style: TextStyle(fontWeight: FontWeight.normal)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(6.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 2.0),
        alignment: Alignment.center,
        color: _getColor(),
        child: AutoSizeText.rich(
          _createSlotSpan(),
          style: TextStyle(
            color: _getTextColor(),
            fontWeight: FontWeight.bold,
          ),
          minFontSize: 9.0,
          overflow: TextOverflow.fade,
          textAlign: TextAlign.center,
          wrapWords: false,
        ),
      ),
    );
  }
}
