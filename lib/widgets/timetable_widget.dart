import 'package:blintranet/constants/strings.dart';
import 'package:blintranet/models/day.dart';
import 'package:blintranet/models/week.dart';
import 'package:blintranet/widgets/lesson_slot_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimetableWidget extends StatelessWidget {
  final Week _week;

  TimetableWidget(Week week) : _week = week;

  // calculate cell height
  double _cellHeight(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    EdgeInsets padding = MediaQuery.of(context).padding;
    double safeHeight =
        height - padding.top - padding.bottom - kToolbarHeight - 42;
    return (safeHeight / _week.lessonTimes.length);
  }

  // create the first row with weekday labels
  TableRow _createWeekdayLabelRow() {
    List<TableCell> weekdayLabels = [TableCell(child: Container())];
    for (String weekDay in Strings.weekDays) {
      weekdayLabels.add(
        TableCell(
          child: Text(weekDay, textAlign: TextAlign.center),
        ),
      );
    }
    return TableRow(children: weekdayLabels);
  }

  TableRow _createSlotRow(String lessonTime, double cellHeight) {
    List<TableCell> slots = new List<TableCell>();

    // add lessontime label
    slots.add(
      TableCell(
        child: Container(
          padding: EdgeInsets.only(top: 2.0, left: 2.0),
          child: Text(lessonTime, textAlign: TextAlign.center),
        ),
      ),
    );

    // add slots
    for (Day day in _week.days) {
      if (day.lessonSlots.containsKey(lessonTime)) {
        slots.add(
          TableCell(
            child: Container(
              height: cellHeight,
              padding: EdgeInsets.all(2.0),
              child: LessonSlotTile(day.lessonSlots[lessonTime]),
            ),
          ),
        );
      } else {
        // add empty spacer
        slots.add(TableCell(child: Container()));
      }
    }
    return TableRow(children: slots);
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );

    List<TableRow> rows = [_createWeekdayLabelRow()];
    double cellHeight = _cellHeight(context);
    // create lesson rows
    for (String lessonTime in _week.lessonTimes) {
      rows.add(_createSlotRow(lessonTime, cellHeight));
    }

    return Table(
      columnWidths: {0: FixedColumnWidth(50)},
      children: rows,
    );
  }
}
