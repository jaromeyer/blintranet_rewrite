import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DialogHelper {
  static Future<void> showErrorDialog(
      BuildContext context, String title, String message, String button) async {
    await showDialog(
      context: context,
      builder: (_) {
        return CupertinoAlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            CupertinoDialogAction(
              isDefaultAction: true,
              child: Text(button),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> showNoInternetDialog(BuildContext context) async {
    await DialogHelper.showErrorDialog(
        context, "Kei Internet📶", "Meh musi glaubs nöd sege", "Retry");
  }
}
