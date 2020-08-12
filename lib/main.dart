import 'package:blintranet/screens/login_screen.dart';
import 'package:blintranet/screens/mail_screen.dart';
import 'package:blintranet/screens/timetable_screen.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => TimetableScreen(),
        '/login': (context) => LoginScreen(),
        '/mail': (context) => MailScreen(),
      },
      title: "Blintranet",
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        accentColor: Colors.blueAccent,
      ),
    );
  }
}
