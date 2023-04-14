import 'package:flutter/material.dart';

import '../../_shared/constants/app_colors.dart';
import '../text_styles/text_styles.dart';

class PerformanceContainer extends StatelessWidget {
  final String title;
  final String? titleSuperScript;
  final String subtitle;
  final Color titleColor;
  final Color subtitleColor;
  final Color backgroundColor;
  final bool showLargeTitle;

  PerformanceContainer({
    required this.title,
    required this.subtitle,
    required this.showLargeTitle,
    this.titleSuperScript,
    this.titleColor = AppColors.textColorBlack,
    this.subtitleColor = AppColors.textColorBlueGray,
    this.backgroundColor = AppColors.screenBackgroundColor2,
  });

  @override
  Widget build(BuildContext context) {
    final titleStyle = showLargeTitle
        ? TextStyles.headerCardMainValueTextStyle.copyWith(color: titleColor)
        : TextStyles.headerCardSubValueTextStyle.copyWith(color: titleColor);

    final labelStyle = TextStyles.headerCardMainLabelTextStyle.copyWith(
      fontSize: 12.0,
      color: subtitleColor,
      fontWeight: FontWeight.w500,
    );

    return Container(
      height: showLargeTitle ? 90 : 72,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 4),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: titleStyle),
              if (titleSuperScript != null) SizedBox(width: 4),
              if (titleSuperScript != null)
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(titleSuperScript!, style: TextStyles.labelTextStyle.copyWith(color: titleColor)),
                ),
            ],
          ),
          SizedBox(height: 4),
          Text(subtitle, style: labelStyle),
          SizedBox(height: 4),
        ],
      ),
    );
  }
}
