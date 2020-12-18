import 'dart:io';

import 'package:blintranet/constants/custom_colors.dart';
import 'package:blintranet/models/exceptions.dart';
import 'package:blintranet/models/week.dart';
import 'package:blintranet/modules/date.dart';
import 'package:blintranet/modules/dialog.dart';
import 'package:blintranet/modules/network.dart';
import 'package:blintranet/widgets/timetable_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TimetableScreen extends StatefulWidget {
  @override
  _TimetableScreenState createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  PageController _pageController;
  NetworkManager _networkManager;
  PageView _pageView;
  String _title = "Blintranet";

  @override
  void initState() {
    super.initState();
    _pageController = new PageController(initialPage: 100);
    _pageView = _buildPageView();
    _networkManager = new NetworkManager();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  PageView _buildPageView() {
    return PageView.builder(
      controller: _pageController,
      onPageChanged: (int index) {
        int weekOffset = index - 100;
        setState(() => _title = Date.title(weekOffset));
      },
      itemBuilder: (context, index) {
        int weekOffset = index - 100;
        return FutureBuilder(
          future: _buildTable(weekOffset),
          builder: (context, snapshot) {
            return AnimatedSwitcher(
              duration: Duration(milliseconds: 500),
              child: snapshot.hasData
                  ? snapshot.data
                  : Center(child: CircularProgressIndicator()),
            );
          },
        );
      },
    );
  }

  Future<Widget> _buildTable(int weekOffset) async {
    try {
      Week week = await _networkManager.getWeek(weekOffset);
      return TimetableWidget(week);
    } on InvalidCredentialsException {
      Navigator.pushReplacementNamed(context, '/login');
    } on InvalidWeekException {
      // show error message and navigate back to valid week after user confirmation
      await DialogHelper.showErrorDialog(
          context,
          "Da gits nüt meh zgseh🚫",
          "Stundeplän fürs nöchschte Semester sind leider nonig verfüegbar",
          "Ok");
      _navigateToWeekOffset(weekOffset - 1);
    } on IOException {
      // show error message and retry after user confirmation
      await DialogHelper.showNoInternetDialog(context);
      Navigator.popUntil(context, ModalRoute.withName('/'));
      return _buildTable(weekOffset);
    } catch (e) {
      // show error and retry after user interaction
      await DialogHelper.showErrorDialog(context,
          "Woops... Kei ahnig was grad passiert isch🙈", e.toString(), "Retry");
      Navigator.popUntil(context, ModalRoute.withName('/'));
      return _buildTable(weekOffset);
    }
  }

  void _navigateToWeekOffset(int weekOffset) {
    _pageController.animateToPage(
      100 + weekOffset,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: Text(_title),
        actions: [
          TextButton(
            child: Text(
              "Mail",
              style: TextStyle(color: CustomColors.red),
            ),
            onPressed: () => Navigator.pushNamed(context, '/mail'),
          ),
        ],
      ),
      body: _pageView,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToWeekOffset(0),
        child: Icon(
          Icons.home_rounded,
          color: Colors.white,
        ),
      ),
    );
  }
}
