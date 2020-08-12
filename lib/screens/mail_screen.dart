import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MailScreen extends StatelessWidget {
  final _webView = FlutterWebviewPlugin();

  void _init() async {
    // get credentials
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String name = prefs.getString('name');
    final String password = prefs.getString('password');
    final String school = prefs.getString('school');

    _webView.onStateChanged.listen((WebViewStateChanged viewState) {
      // inject credentials when loading is done
      if (viewState.type == WebViewState.finishLoad) {
        final String jsString =
            "document.querySelector(\"#login-form > fieldset > div.login-school > section:nth-child(4) > input\").value = \"" +
                name +
                "." +
                school +
                "\";document.querySelector(\"#login-form > fieldset > div.login-school > section:nth-child(5) > input\").value = \"" +
                password +
                "\";document.querySelector(\"#login-form\").submit.click()";
        _webView.evalJavascript(jsString);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _init();

    return WebviewScaffold(
      url: "https://tcs.tam.ch/sso",
      appBar: AppBar(
        title: Text("Mail"),
      ),
    );
  }
}
