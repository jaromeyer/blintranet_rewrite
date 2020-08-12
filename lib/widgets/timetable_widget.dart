import 'package:blintranet/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:blintranet/models/lesson.dart';
import 'package:blintranet/models/week.dart';
import 'package:marquee/marquee.dart';
import 'package:auto_size_text/auto_size_text.dart';

class TimetableWidget extends StatelessWidget {
  final Week week;

  TimetableWidget({@required this.week});

  @override
  Widget build(BuildContext context) {
    List<TableRow> rows = [];

    // create title row
    List<TableCell> titleRow = [TableCell(child: Container())];
    Strings.weekDays.forEach((String weekDay) {
      titleRow.add(
        TableCell(
          child: Container(
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(3),
            color: Colors.indigoAccent,
            child: Text(
              weekDay,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
      );
    });
    rows.add(TableRow(children: titleRow));

    // calculate cell height
    double height = MediaQuery.of(context).size.height;
    EdgeInsets padding = MediaQuery.of(context).padding;
    double safeHeight =
        height - padding.top - padding.bottom - kToolbarHeight - 48;
    double cellHeight = (safeHeight / week.lessonRows.length) - 2;

    // create lesson rows
    week.lessonRows.forEach((String lessonTime, List<Lesson> lessons) {
      List<TableCell> lessonRow = [];
      lessonRow.add(
        TableCell(
          verticalAlignment: TableCellVerticalAlignment.fill,
          child: Container(
            margin: EdgeInsets.all(1),
            padding: EdgeInsets.all(3),
            alignment: Alignment.center,
            color: Colors.indigo,
            child: AutoSizeText(
              lessonTime,
              style: TextStyle(
                color: Colors.white,
              ),
              maxLines: 1,
            ),
          ),
        ),
      );

      lessons.forEach((Lesson lesson) {
        if (lesson == null) {
          // add empty spacer
          lessonRow.add(TableCell(child: Container()));
        } else {
          lessonRow.add(
            TableCell(
              child: Container(
                height: cellHeight,
                margin: EdgeInsets.all(1),
                padding: EdgeInsets.all(3),
                alignment: Alignment.center,
                color: Colors.blue,
                child: AutoSizeText(
                  lesson.displayString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                  ),
                  maxLines: 2,
                  overflowReplacement: Marquee(
                    text: lesson.displayString(),
                    blankSpace: 30.0,
                    velocity: 20.0,
                    scrollAxis: Axis.vertical,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          );
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
