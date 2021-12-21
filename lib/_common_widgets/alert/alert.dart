// @dart=2.9

import 'package:flutter/material.dart';

class Alert {

  static BuildContext _context;

  static void setContext(BuildContext context){
    _context = context;
  }

  static void showSimpleAlert(
    {
    String title,
    String message,
    String buttonTitle,
    VoidCallback onPressed,
  }) {
    showDialog(
      context: _context,
      barrierDismissible: true,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          new TextButton(
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
    {
    String title,
    String message,
    String buttonOneTitle,
    String buttonTwoTitle,
    VoidCallback buttonOneOnPressed,
    VoidCallback buttonTwoOnPressed,
  }) {
    showDialog(
      context: _context,
      barrierDismissible: true,
      builder: (context) => new AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
        title: new Text(title),
        content: new Text(message),
        actions: <Widget>[
          new TextButton(
            child: new Text(buttonOneTitle),
            onPressed: () {
              Navigator.of(context).pop();
              if (buttonOneOnPressed != null) buttonOneOnPressed();
            },
          ),
          new TextButton(
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
