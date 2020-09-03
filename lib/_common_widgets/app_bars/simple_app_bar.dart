import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leading;
  final bool addBackButton;
  final VoidCallback onBackButtonPress;
  final List<Widget> actions;
  final PreferredSizeWidget bottom;

  @override
  final Size preferredSize;

  SimpleAppBar({
    this.title,
    this.leading,
    this.addBackButton,
    this.onBackButtonPress,
    this.actions,
    this.bottom,
  }) : preferredSize = Size.fromHeight(56 + (bottom != null ? bottom.preferredSize.height : 0.0));

  @override
  Widget build(BuildContext context) {
    Widget leadingWidget;
    if (addBackButton) {
      leadingWidget = Container(
        padding: EdgeInsets.all(10),
        child: FlatButton(
          color: AppColors.defaultColor,
          padding: EdgeInsets.all(0),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
          child: SvgPicture.asset(
            'assets/icons/back.svg',
            width: 18,
            height: 18,
          ),
          onPressed: onBackButtonPress,
        ),
      );
    } else {
      leadingWidget = leading;
    }

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
      leading: leadingWidget,
      actions: actions,
      bottom: bottom,
    );
  }
}
