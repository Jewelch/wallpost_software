import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

class ErrorListTile extends StatelessWidget {
  final String message;
  final VoidCallback onTap;

  ErrorListTile(this.message, {required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              padding: EdgeInsets.all(12).copyWith(bottom: 0),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: TextStyles.subTitleTextStyle,
              ),
              onPressed: () {
                if (onTap != null) onTap();
              },
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
