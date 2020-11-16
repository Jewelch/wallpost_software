import 'package:flutter/material.dart';

class ErrorListTile extends StatelessWidget {
  final String message;

  ErrorListTile(this.message);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text(message),
    );
  }
}
