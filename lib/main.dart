import 'package:blintranet/constants/custom_colors.dart';
import 'package:blintranet/screens/login_screen.dart';
import 'package:blintranet/screens/mail_screen.dart';
import 'package:blintranet/screens/timetable_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
      ),
    );
    return MaterialApp(
      routes: {
        '/': (context) => TimetableScreen(),
        '/login': (context) => LoginScreen(),
        '/mail': (context) => MailScreen(),
      },
      title: "Blintranet",
      theme: ThemeData(
        accentColor: CustomColors.red,
        primaryColor: CustomColors.blue,
        canvasColor: Colors.white,
        appBarTheme: AppBarTheme(
          brightness: Brightness.light,
          color: Colors.transparent,
          elevation: 0.0,
          iconTheme: IconThemeData(color: CustomColors.red),
        ),
        textTheme: TextTheme(
          bodyText2: TextStyle(
            color: CustomColors.textBlue,
          ),
        ),
        primaryTextTheme: TextTheme(
          headline6: TextStyle(
            color: CustomColors.textBlue,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
