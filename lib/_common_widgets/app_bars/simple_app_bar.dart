import 'package:flutter/material.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leading;
  final Widget trailing;
  final bool showDivider;

  @override
  final Size preferredSize;

  SimpleAppBar({
    this.title,
    this.leading,
    this.trailing,
    this.showDivider = false,
  }) : preferredSize = Size.fromHeight(56);

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
      title: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 12),
              if (leading != null) this.leading,
              if (leading != null) SizedBox(width: 8),
              Expanded(
                child: Container(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
              if (trailing != null) SizedBox(width: 8),
              if (trailing != null) this.trailing,
              SizedBox(width: 12),
            ],
          ),
          if (showDivider) SizedBox(height: 8),
          if (showDivider) Divider(height: 1),
        ],
      ),
    );
  }
}
