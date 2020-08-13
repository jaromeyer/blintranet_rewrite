import 'package:intl/intl.dart';

class Date {
  static DateTime startDate(int weekOffset) {
    final DateTime dateToday =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .add(Duration(days: 7 * weekOffset));
    DateTime startDate;
    if (dateToday.weekday < 6) {
      startDate = dateToday.subtract(Duration(days: dateToday.weekday - 1));
    } else {
      startDate = dateToday.add(Duration(days: 8 - dateToday.weekday));
    }
    return startDate;
  }

  static String title(int weekOffset) {
    String startDateString =
        DateFormat("dd.MM.yyyy").format(startDate(weekOffset));

    if (weekOffset > 0) {
      return "$startDateString (+${weekOffset.toString()} wuche)";
    } else if (weekOffset < 0) {
      return "$startDateString (${weekOffset.toString()} wuche)";
    } else {
      return startDateString;
    }
  }
}
