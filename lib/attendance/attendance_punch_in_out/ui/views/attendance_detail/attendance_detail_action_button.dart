import 'package:flutter/material.dart';

import '../../../../../_common_widgets/text_styles/text_styles.dart';

class AttendanceDetailActionButton extends StatelessWidget {
  final String title;
  final String subTitle;
  final Color buttonColor;
  final VoidCallback onPressed;
  final bool showLoader;

  AttendanceDetailActionButton({
    required this.title,
    required this.subTitle,
    required this.buttonColor,
    required this.onPressed,
    required this.showLoader,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        width: 160,
        height: 160,
        padding: EdgeInsets.all(3),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(100), color: Colors.white),
        child: showLoader ? _loader() : _button());
  }

  Widget _loader() {
    return CircularProgressIndicator(
      strokeWidth: 2,
      backgroundColor: Colors.transparent,
      valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
    );
  }

  Widget _button() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: MaterialButton(
          elevation: 0,
          highlightElevation: 0,
          color: buttonColor,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.access_time, size: 32, color: Colors.white),
              SizedBox(height: 12),
              Text(title, style: TextStyles.titleTextStyle.copyWith(color: Colors.white)),
              Text(subTitle, style: TextStyles.titleTextStyle.copyWith(color: Colors.white)),
              SizedBox(height: 10),
            ],
          ),
          onPressed: onPressed),
    );
  }
}
