import 'package:flutter/material.dart';
import 'app_bar_divider.dart';

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
      bottom: showDivider ? AppBarDivider() : null,
      // Don't show the default leading button
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          Row(
            children: [
              SizedBox(width: 12),
              this.leading ?? SizedBox(width: 32),
              SizedBox(width: 8),
              Expanded(
                child: Container(
                  child: Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ),
              ),
              SizedBox(width: 8),
              this.trailing ?? SizedBox(width: 32),
              SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }
}
