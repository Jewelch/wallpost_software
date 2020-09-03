import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leading;
  final List<Widget> actions;
  final PreferredSizeWidget bottom;

  @override
  final Size preferredSize;

  SimpleAppBar({
    this.title,
    this.leading,
    this.actions,
    this.bottom,
  }) : preferredSize = Size.fromHeight(56 + (bottom != null ? bottom.preferredSize.height : 0.0));

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleSpacing: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      // Don't show the leading button
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.black),
      ),
      leading: leading,
      actions: actions,
      bottom: bottom,
    );
  }
}
