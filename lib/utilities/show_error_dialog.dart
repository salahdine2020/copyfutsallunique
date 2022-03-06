import 'package:flutter/material.dart';

class ShowErrorDialog {
  static void showAlertDialog(
      {required String errorMessage, required BuildContext context}) {
    showDialog(
        context: context,
        builder: (_) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: <Widget>[
              ElevatedButton(
                child: Text('Ok'),
                onPressed: () => Navigator.pop(context),
              )
            ],
          );
        });
  }
}
