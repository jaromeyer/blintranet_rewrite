import 'dart:io';

import 'package:blintranet/models/exceptions.dart';
import 'package:blintranet/models/week.dart';
import 'package:blintranet/modules/date.dart';
import 'package:blintranet/modules/network.dart';
import 'package:blintranet/widgets/timetable_widget.dart';
import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  PageController _pageController;
  PageView _pageView;
  NetworkManager _networkManager;
  bool _loggedIn = false;
  String _title = "Blintranet";

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 100);
    _buildPageView();
    _networkManager = NetworkManager();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _buildPageView() {
    _pageView = PageView.builder(
      controller: _pageController,
      onPageChanged: (int index) {
        int weekOffset = index - 100;
        setState(() {
          _title = Date.title(weekOffset);
        });
      },
      itemBuilder: (context, index) {
        int weekOffset = index - 100;
        return FutureBuilder(
          future: _buildTable(weekOffset),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data;
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        );
      },
    );
  }

  Future<Widget> _buildTable(int weekOffset) async {
    try {
      // login
      if (!_loggedIn) {
        await _networkManager.login();
        _loggedIn = true;
      }
      Week week = await _networkManager.getWeek(weekOffset);
      return TimetableWidget(week: week);
    } on InvalidCredentialsException {
      // open login screen
      Navigator.pushReplacementNamed(context, '/login');
    } on InvalidSessionException {
      // handle invalid session
      setState(() {
        _buildPageView();
        _loggedIn = false;
      });
    } on IOException {
      // handle no internet
      showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text("No Internet Connection"),
            content:
                Text("Make sure your device is connected to the internet."),
            actions: <Widget>[
              FlatButton(
                child: Text("Retry"),
                onPressed: () {
                  setState(() {
                    _buildPageView();
                    _loggedIn = false;
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text(_title),
        actions: [
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () {
              Navigator.pushNamed(context, '/mail');
            },
          ),
          IconButton(
            icon: Icon(Icons.home),
            onPressed: () {
              _pageController.animateToPage(
                100,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOut,
              );
            },
          ),
        ],
      ),
      body: _pageView,
    );
  }
}
