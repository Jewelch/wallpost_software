import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

import 'app_bar_divider.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leading;
  final double leadingSpace;
  final Widget trailing;
  final double trailingSpace;
  final bool showDivider;

  @override
  final Size preferredSize;

  SimpleAppBar({
    this.title,
    this.leading,
    this.leadingSpace = 12,
    this.trailing,
    this.trailingSpace = 12,
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
      title: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyles.titleTextStyle.copyWith(fontSize: 18.0),
      ),
      leading: _constraintWidgetToSize(leading),
      actions: trailing != null ? [_constraintWidgetToSize(trailing)] : [],
    );
  }

  Widget _constraintWidgetToSize(Widget widget) {
    return Container(
      padding: EdgeInsets.only(right: trailingSpace),
      child: Center(
        child: SizedBox(
          width: 32,
          height: 32,
          child: widget,
        ),
      ),
    );
  }
}
