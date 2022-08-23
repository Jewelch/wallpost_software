import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class CapsuleActionButton extends StatelessWidget {
  final String title;
  final Color color;
  final VoidCallback onPressed;
  final bool disabled;
  final bool showLoader;

  CapsuleActionButton({
    required this.title,
    required this.color,
    required this.onPressed,
    this.disabled = false,
    this.showLoader = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 44,
      child: MaterialButton(
        minWidth: 50,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: disabled ? AppColors.disabledButtonColor : color),
          borderRadius: BorderRadius.circular(22.0),
        ),
        padding: EdgeInsets.only(left: 8, right: 8),
        onPressed: (disabled || showLoader) ? null : onPressed,
        color: Colors.transparent,
        disabledColor: Colors.transparent,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: showLoader ? _buildLoader() : _buildTitle(),
        ),
      ),
    );
  }

  List<Widget> _buildTitle() {
    return [
      Text(
        title,
        textAlign: TextAlign.center,
        overflow: TextOverflow.ellipsis,
        maxLines: 1,
        style: TextStyle(
          fontSize: 16,
          color: disabled ? AppColors.disabledButtonColor : color,
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
          valueColor: AlwaysStoppedAnimation<Color>(color.withOpacity(0.7)),
        ),
      )
    ];
  }
}
