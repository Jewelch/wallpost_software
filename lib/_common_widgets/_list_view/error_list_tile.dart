import 'package:flutter/material.dart';

class ErrorListTile extends StatelessWidget {
  final String message;

  ErrorListTile(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
