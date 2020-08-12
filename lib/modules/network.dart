import 'dart:convert';
import 'dart:io';

import 'package:blintranet/constants/headers.dart';
import 'package:blintranet/models/exceptions.dart';
import 'package:blintranet/models/week.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkManager {
  String _cookie;

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = prefs.getString('name');
    final String password = prefs.getString('password');
    final String school = prefs.getString('school');

    if (name == null || password == null || school == null) {
      throw InvalidCredentialsException();
    }

    final loginResponse = await http.post(
      'https://intranet.tam.ch/',
      body: {
        'loginuser': name,
        'loginpassword': password,
        'loginschool': school
      },
      headers: Headers.loginHeaders,
    );

    // check if login was successful
    if (loginResponse.statusCode == 302) {
      final String rawCookie = loginResponse.headers['set-cookie'];
      _cookie = RegExp(r'sturmsession.*?;').firstMatch(rawCookie).group(0);
    } else if (loginResponse.statusCode == 200) {
      throw InvalidCredentialsException();
    }
  }

  Future<Week> getWeek(int weekOffset) async {
    final DateTime dateToday =
        DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day)
            .add(Duration(days: 7 * weekOffset));
    DateTime startDate;
    if (dateToday.weekday < 6) {
      startDate = dateToday.subtract(Duration(days: dateToday.weekday - 1));
    } else {
      startDate = dateToday.add(Duration(days: 8 - dateToday.weekday));
    }
    DateTime endDate = startDate.add(Duration(days: 4));

    final timetableResponse = await http.post(
      'https://intranet.tam.ch/kfr/timetable/ajax-get-timetable',
      body: {
        'startDate': startDate.millisecondsSinceEpoch.toString(),
        'endDate': endDate.millisecondsSinceEpoch.toString(),
        'studentId[]': '4008876'
      },
      headers: Headers.timetableHeaders(_cookie),
    );

    if (timetableResponse.statusCode == 200) {
      return Week.fromJson(json.decode(timetableResponse.body));
    } else if (timetableResponse.statusCode == 302) {
      throw InvalidSessionException();
    }
  }
}
