import 'package:flutter/material.dart';

class OnTapKeyboardDismisser extends StatelessWidget {
  final Widget child;

  OnTapKeyboardDismisser({required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: child,
    );
  }
}
