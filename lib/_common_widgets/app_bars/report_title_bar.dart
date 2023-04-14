import 'package:flutter/material.dart';

import '../text_styles/text_styles.dart';

class ReportTitleBar extends StatelessWidget {
  final String title;
  final String subtitle;

  const ReportTitleBar({required this.title, required this.subtitle, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 52,
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Finance/Reports",
                style: TextStyles.labelTextStyleBold.copyWith(fontWeight: FontWeight.w500),
              ),
              Text(
                "Inventory Stock",
                style: TextStyles.extraLargeTitleTextStyleBold.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
