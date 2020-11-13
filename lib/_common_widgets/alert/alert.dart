import 'package:flutter/material.dart';

class Alert {
  static void showSimpleAlert(
    BuildContext context, {
    String title,
    String message,
    String buttonTitle,
    VoidCallback onPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          new FlatButton(
            child: new Text(buttonTitle),
            onPressed: () {
              Navigator.of(context).pop();
              if (onPressed != null) onPressed();
            },
          ),
        ],
      ),
    );
  }

  static void showSimpleAlertWithButtons(
    BuildContext context, {
    String title,
    String message,
    String buttonOneTitle,
    String buttonTwoTitle,
    VoidCallback buttonOneOnPressed,
    VoidCallback buttonTwoOnPressed,
  }) {
    showDialog(
      context: context,
      barrierDismissible: true,
      child: new AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          new FlatButton(
            child: new Text(buttonOneTitle),
            onPressed: () {
              Navigator.of(context).pop();
              if (buttonOneOnPressed != null) buttonOneOnPressed();
            },
          ),
          new FlatButton(
            child: new Text(buttonTwoTitle),
            onPressed: () {
              Navigator.of(context).pop();
              if (buttonTwoOnPressed != null) buttonTwoOnPressed();
            },
          ),
        ],
      ),
    );
  }
}
