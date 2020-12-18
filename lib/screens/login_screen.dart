import 'dart:io';

import 'package:blintranet/constants/custom_colors.dart';
import 'package:blintranet/constants/strings.dart';
import 'package:blintranet/models/exceptions.dart';
import 'package:blintranet/modules/dialog.dart';
import 'package:blintranet/modules/network.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum Status { idle, loading, invalidCredentials }

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _school;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  Status _status = Status.idle;

  Future<void> _login() async {
    FocusScope.of(context).unfocus();
    setState(() => _status = Status.loading);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameController.text);
    prefs.setString('password', _passwordController.text);
    prefs.setString('school', _school);

    NetworkManager networkManager = new NetworkManager();
    try {
      await networkManager.login();
      Navigator.pushReplacementNamed(context, '/');
    } on IOException {
      await DialogHelper.showNoInternetDialog(context);
      _login();
    } on InvalidCredentialsException {
      _passwordController.clear();
      FocusScope.of(context).requestFocus();
      setState(() => _status = Status.invalidCredentials);
    }
  }

  Widget _buildBottomWidget() {
    switch (_status) {
      case Status.idle:
        return FlatButton(
          padding: EdgeInsets.all(14),
          color: CustomColors.red,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
          child: Text(
            'Login',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
          onPressed: _login,
        );
      case Status.loading:
        return LinearProgressIndicator();
      case Status.invalidCredentials:
        return Text(
          "Irgendöpis stimmt leider nöd ganz",
          textAlign: TextAlign.center,
          style: TextStyle(color: CustomColors.red),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: DropdownButtonFormField(
              hint: Text("Schuel uswähle"),
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(10.0),
                border: OutlineInputBorder(),
              ),
              isExpanded: true,
              items: Strings.schoolNames.entries.map((MapEntry entry) {
                return DropdownMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList(),
              onChanged: (String school) {
                setState(() {
                  _school = school;
                });
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _nameController,
              autocorrect: false,
              textInputAction: TextInputAction.next,
              onChanged: (_) {
                setState(() => _status = Status.idle);
              },
              //onEditingComplete: () => FocusScope.of(context).nextFocus(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10.0),
                suffixIcon: Icon(Icons.person),
                labelText: 'Name',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextFormField(
              controller: _passwordController,
              obscureText: true,
              onChanged: (_) {
                setState(() => _status = Status.idle);
              },
              onEditingComplete: () => _login(),
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(10.0),
                suffixIcon: Icon(Icons.lock_outline),
                labelText: 'Passwort',
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: _buildBottomWidget(),
          ),
        ],
      ),
    );
  }
}
