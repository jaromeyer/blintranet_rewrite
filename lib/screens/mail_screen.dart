import 'dart:io';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MailScreen extends StatelessWidget {
  WebViewController _webViewController;

  void _login(_) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String name = prefs.getString('name');
    String password = prefs.getString('password');
    String school = prefs.getString('school');

    String js =
        "document.querySelector('#login-form > fieldset > div.login-school > section:nth-child(4) > input').value = '$name.$school';"
        "document.querySelector('#login-form > fieldset > div.login-school > section:nth-child(5) > input').value = '$password';"
        "document.querySelector('#login-form').submit.click()";

    _webViewController.evaluateJavascript(js);
  }

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) WebView.platform = new SurfaceAndroidWebView();
    return Scaffold(
      appBar: AppBar(
        title: Text("Mail"),
      ),
      body: WebView(
        initialUrl: 'https://tcs.tam.ch/sso',
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) {
          _webViewController = webViewController;
        },
        onPageFinished: _login,
      ),
    );
  }
}
