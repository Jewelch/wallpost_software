import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class RoundedRectangleActionButton extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? icon;
  final Color textColor;
  final Color disabledTextColor;
  final Color backgroundColor;
  final Color disabledBackgroundColor;
  final Color? borderColor;
  final VoidCallback onPressed;
  final bool disabled;
  final bool showLoader;
  final bool isIconLeftAligned;
  final double height;
  final double borderRadiusCircular;
  final MainAxisAlignment alignment;

  RoundedRectangleActionButton({
    this.title = "",
    this.subtitle = "",
    this.icon,
    this.textColor = Colors.white,
    this.disabledTextColor = Colors.white60,
    this.backgroundColor = AppColors.defaultColor,
    this.disabledBackgroundColor = AppColors.disabledButtonColor,
    this.borderColor,
    required this.onPressed,
    this.disabled = false,
    this.showLoader = false,
    this.isIconLeftAligned = true,
    this.height = 50,
    this.borderRadiusCircular=8,
    this.alignment = MainAxisAlignment.center,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: MaterialButton(
        minWidth: height,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(
          side: BorderSide(color: borderColor ?? (disabled ? disabledBackgroundColor : backgroundColor)),
          borderRadius: BorderRadius.circular(borderRadiusCircular),
        ),
        padding: EdgeInsets.only(left: 8, right: 8),
        onPressed: (disabled || showLoader) ? null : onPressed,
        color: backgroundColor,
        disabledColor: showLoader ? backgroundColor : disabledBackgroundColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: showLoader ? _buildLoader() : _buildIconAndTitle(),
        ),
      ),
    );
  }

  List<Widget> _buildIconAndTitle() {
    return [
      if (icon != null) icon!,
      if (icon != null && title.isNotEmpty) SizedBox(width: 8),
      if (title.isNotEmpty)
        isIconLeftAligned?
        Flexible(
          child: Row(
            mainAxisAlignment: alignment,
            children: [
              Text(
                title,
                textAlign: TextAlign.center,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 16,
                  color: disabled ? disabledTextColor : textColor,
                  fontWeight: FontWeight.w400,
                ),
              ),
              if (subtitle.isNotEmpty) SizedBox(height: 6),
              if (subtitle.isNotEmpty)
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color.fromRGBO(130, 130, 130, 1.0),
                  ),
                ),
            ],
          ),
        ):  Row(
          mainAxisAlignment: alignment,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              style: TextStyle(
                fontSize: 16,
                color: disabled ? disabledTextColor : textColor,
                fontWeight: FontWeight.w400,
              ),
            ),
            if (subtitle.isNotEmpty) SizedBox(height: 6),
            if (subtitle.isNotEmpty)
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  color: Color.fromRGBO(130, 130, 130, 1.0),
                ),
              ),
          ],
        )

    ];
  }

  List<Widget> _buildLoader() {
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
