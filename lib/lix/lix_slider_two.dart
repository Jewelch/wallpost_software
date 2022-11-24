import 'package:flutter/material.dart';

import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../_shared/constants/app_colors.dart';

class LixDetailsSliderTwo extends StatelessWidget {
  const LixDetailsSliderTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(
          'assets/logo/binance.png',
          height: 300,
          fit: BoxFit.contain,
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.only(left: 16, right: 16),
          child: Text(
            "LIXX tokens are Binance\ncompliant utility tokens.",
            style: TextStyles.extraLargeTitleTextStyleBold.copyWith(color: AppColors.textColorBlueGray),
            textAlign: TextAlign.center,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          padding: EdgeInsets.only(left: 30, right: 30),
          child: Text(
            "LIXX rewards are a crypto token that\ncan be redeemed or traded, do not\nexpire, and have an increasing value",
            style: TextStyles.titleTextStyle.copyWith(color: AppColors.textColorBlueGrayLight),
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }
}
