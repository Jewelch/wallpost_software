import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class SimpleAppBarWithBackButton extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String backButtonTitle;
  final VoidCallback onBackButtonPress;

  @override
  final Size preferredSize = Size.fromHeight(56);

  SimpleAppBarWithBackButton({
    this.title,
    this.backButtonTitle,
    this.onBackButtonPress,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      // Don't show the leading button
      title: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.pop(context);
              onBackButtonPress();
            },
            child: Text(
              backButtonTitle,
              style: TextStyle(color: AppColors.defaultColor, fontSize: 16),
            ),
          ),
          Expanded(
            child: Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.defaultColor),
            ),
          ),
          //This container is added to center the title
          Container(
            color: Colors.transparent,
            child: Text(backButtonTitle, style: TextStyle(color: Colors.transparent, fontSize: 16)),
          ),
          // Your widgets here
        ],
      ),
    );
  }
}
