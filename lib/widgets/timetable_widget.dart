import 'package:blintranet/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:blintranet/models/lesson.dart';
import 'package:blintranet/models/week.dart';
import 'package:marquee/marquee.dart';

class TimetableWidget extends StatelessWidget {
  final Week week;

  TimetableWidget({@required this.week});

  @override
  Widget build(BuildContext context) {
    List<TableRow> rows = [];

    // create title row
    List<Widget> titleRow = [Container()];
    Strings.weekDays.forEach((String weekDay) {
      titleRow.add(
        TableCell(
          child: Container(
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(4),
            color: Colors.indigoAccent,
            child: Text(
              weekDay,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
        ),
      );
    });
    rows.add(TableRow(children: titleRow));

    // create lesson rows
    week.lessonRows.forEach((String lessonTime, List<Lesson> lessons) {
      List<Widget> lessonRow = [];
      lessonRow.add(
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.fill,
          child: Container(
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(4),
            alignment: Alignment.center,
            color: Colors.indigo,
            child: Text(
              lessonTime,
              style: TextStyle(
                color: Colors.white,
                fontSize: 13,
              ),
            ),
          ),
        ),
      );

      lessons.forEach((Lesson lesson) {
        if (lesson == null) {
          // add empty spacer
          lessonRow.add(Container());
        } else {
          // add marquee instead of text if the string is longer than 50 chars
          if (lesson.displayString().length > 50) {
            lessonRow.add(
              TableCell(
                child: Container(
                  height: 100,
                  margin: EdgeInsets.all(1),
                  padding: EdgeInsets.all(4),
                  color: Colors.blue,
                  child: Marquee(
                    text: lesson.displayString(),
                    blankSpace: 30.0,
                    velocity: 30.0,
                    scrollAxis: Axis.vertical,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          } else {
            lessonRow.add(
              TableCell(
                child: Container(
                  margin: EdgeInsets.all(1),
                  padding: EdgeInsets.all(4),
                  color: Colors.blue,
                  child: Text(
                    lesson.displayString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            );
          }
        }
      });
      rows.add(TableRow(children: lessonRow));
    });

    return Table(
      columnWidths: {
        0: FlexColumnWidth(0.8),
      },
      children: rows,
    );
  }
}
