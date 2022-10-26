import 'dart:core';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class BreakActionButton extends StatelessWidget {
  final String title;
  final Color buttonColor;
  final Color textColor;
  final Color disabledBackgroundColor;
  final VoidCallback onButtonPressed;
  final bool disabled;
  final bool showLoader;

  BreakActionButton({
    required this.title,
    required this.buttonColor,
    required this.textColor,
    required this.onButtonPressed,
    this.disabledBackgroundColor = AppColors.disabledButtonColor,
    this.disabled = false,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: MaterialButton(
        minWidth: 120,
        elevation: 0,
        highlightElevation: 0,
        
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: EdgeInsets.only(left: 8, right: 8),
        onPressed: (disabled || showLoader) ? null : onButtonPressed,
        color: buttonColor,
        disabledColor: showLoader ? buttonColor : disabledBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: showLoader ? _buildBreakLoader() : _buildIconAndTitle(title, textColor),
        ),
      ),
    );
  }

  List<Widget> _buildIconAndTitle(String title, Color textColor) {
    return [
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.coffee_outlined, color: textColor, size: 18),
          SizedBox(width: 8),
          Text(title, style: TextStyles.titleTextStyle.copyWith(color: textColor)),
        ],
      )
    ];
  }

  List<Widget> _buildBreakLoader() {
    return [
      SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
        ),
      )
    ];
  }
}
