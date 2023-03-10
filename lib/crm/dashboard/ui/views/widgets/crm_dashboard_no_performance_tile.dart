import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

class CrmDashboardNoPerformanceTile extends StatelessWidget {
  final String _title;

  CrmDashboardNoPerformanceTile(this._title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Text(
        _title,
        style: TextStyles.subTitleTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }
}
