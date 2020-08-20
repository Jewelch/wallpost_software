import 'package:flutter/material.dart';

class OnTapKeyboardDismisser extends StatelessWidget {
  final Widget child;

  OnTapKeyboardDismisser({this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: child,
    );
  }
}
