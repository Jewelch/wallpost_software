import 'package:flutter/material.dart';

class OnTapKeyboardDismisser extends StatelessWidget {
  final Widget child;
  final bool dismissOnTap;
  final bool dismissOnScroll;

  const OnTapKeyboardDismisser({
    Key? key,
    required this.child,
    this.dismissOnTap = true,
    this.dismissOnScroll = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onPanDown: dismissOnScroll ? (_) => FocusScope.of(context).unfocus() : null,
      onTap: dismissOnTap ? () => FocusScope.of(context).unfocus() : null,
      child: child,
    );
  }
}
