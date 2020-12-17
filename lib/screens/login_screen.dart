import 'package:blintranet/constants/custom_colors.dart';
import 'package:blintranet/constants/strings.dart';
import 'package:blintranet/models/exceptions.dart';
import 'package:blintranet/modules/network.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _school;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _saveCredentials() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', _nameController.text);
    prefs.setString('password', _passwordController.text);
    prefs.setString('school', _school);

    NetworkManager networkManager = new NetworkManager();
    try {
      networkManager.login();
      Navigator.pushReplacementNamed(context, '/');
    } on InvalidCredentialsException {
      print("invalid credentials");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
              child: DropdownButtonFormField(
                hint: Text("Schuel uswähle"),
                decoration: InputDecoration(
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
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _nameController,
                autocorrect: false,
                textInputAction: TextInputAction.next,
                onFieldSubmitted: (_) => FocusScope.of(context).nextFocus(),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(),
                  labelText: 'Name',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                onFieldSubmitted: (_) => _saveCredentials(),
                decoration: InputDecoration(
                  suffixIcon: Icon(Icons.lock_outline),
                  border: OutlineInputBorder(),
                  labelText: 'Passwort',
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
              child: FlatButton(
                padding: EdgeInsets.all(16),
                color: CustomColors.red,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Login',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                onPressed: () => _saveCredentials(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
