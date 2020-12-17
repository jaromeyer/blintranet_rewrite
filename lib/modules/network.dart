import 'dart:convert';

import 'package:blintranet/constants/strings.dart';
import 'package:blintranet/models/exceptions.dart';
import 'package:blintranet/models/week.dart';
import 'package:blintranet/modules/date.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class NetworkManager {
  String _cookie;
  String _studentId;
  String _school;
  bool _loggedIn = false;

  Future<void> login() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = prefs.getString('name');
    final String password = prefs.getString('password');
    _school = prefs.getString('school');

    if (name == null || password == null || _school == null) {
      throw InvalidCredentialsException();
    }

    final loginResponse = await http.post(
      'https://intranet.tam.ch/',
      body: {
        'loginuser': name,
        'loginpassword': password,
        'loginschool': _school,
      },
      headers: Strings.headers(null),
    );

    // check if login was successful
    if (loginResponse.statusCode == 302) {
      _loggedIn = true;
      final String rawCookie = loginResponse.headers['set-cookie'];
      _cookie = RegExp(r'sturmsession.*?;').firstMatch(rawCookie).group(0);
      _studentId = await _getStudentId(await _getCsrfToken());
    } else if (loginResponse.statusCode == 200) {
      throw InvalidCredentialsException();
    }
  }

  Future<String> _getCsrfToken() async {
    final csrfTokenResponse = await http.get(
      'https://intranet.tam.ch/$_school',
      headers: Strings.headers(_cookie),
    );
    String csrfToken = RegExp(r".*csrfToken='(.*?)'")
        .firstMatch(csrfTokenResponse.body)
        .group(1);
    return csrfToken;
  }

  Future<String> _getStudentId(String csrfToken) async {
    final studentIdResponse = await http.post(
      'https://intranet.tam.ch/$_school/timetable/ajax-get-resources',
      body: {
        'periodId': "72",
        'csrfToken': csrfToken,
      },
      headers: Strings.headers(_cookie),
    );
    return json
        .decode(studentIdResponse.body)['data']['students'][0]['personId']
        .toString();
  }

  Future<Week> getWeek(int weekOffset) async {
    if (!_loggedIn) await login();
    DateTime startDate = Date.startDate(weekOffset);
    DateTime endDate = startDate.add(Duration(days: 4));

    final timetableResponse = await http.post(
      'https://intranet.tam.ch/$_school/timetable/ajax-get-timetable',
      body: {
        'startDate': startDate.millisecondsSinceEpoch.toString(),
        'endDate': endDate.millisecondsSinceEpoch.toString(),
        'studentId[]': _studentId,
      },
      headers: Strings.headers(_cookie),
    );

    if (timetableResponse.statusCode == 200) {
      Map<String, dynamic> decodedJson = json.decode(timetableResponse.body);
      return Week.fromJson(decodedJson);
    } else if (timetableResponse.statusCode == 302) {
      await login();
      return getWeek(weekOffset);
    }
  }
}
