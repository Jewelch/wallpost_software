import 'package:flutter/material.dart';

import '../../../../_shared/constants/app_colors.dart';

class ActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final Widget? icon;
  final VoidCallback onPressed;
  final Color disabledBackgroundColor;
  final bool disabled;
  final bool showLoader;

  ActionButton({
    required this.title,
    required this.color,
    this.icon,
    required this.onPressed,
    this.disabledBackgroundColor = AppColors.disabledButtonColor,
    this.disabled = false,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      child: MaterialButton(
        minWidth: 50,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: disabled ? AppColors.disabledButtonColor : color),
          borderRadius: BorderRadius.circular(14),
        ),
        padding: EdgeInsets.only(left: 8, right: 8),
        onPressed: (disabled || showLoader) ? null : onPressed,
        color: color,
        disabledColor: showLoader ? color : disabledBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: showLoader ? _buildLoader() : _buildTitle(),
        ),
      ),
    );
  }

  List<Widget> _buildTitle() {
    return [
      if (icon != null) icon!,
      if (icon != null && title.isNotEmpty) SizedBox(width: 8),
      Text(
        title,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontSize: 16,
          color: disabled ? AppColors.disabledButtonColor : Colors.white,
          fontWeight: FontWeight.w400,
        ),
      ),
    ];
  }

  List<Widget> _buildLoader() {
    return [
      SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
        ),
      )
    ];
  }
}
