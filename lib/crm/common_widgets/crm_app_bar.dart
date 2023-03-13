import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../_common_widgets/buttons/rounded_back_button.dart';
import '../../_common_widgets/text_styles/text_styles.dart';
import '../../_shared/constants/app_colors.dart';

class CrmAppBar extends StatelessWidget {
  final String companyName;

  const CrmAppBar({required this.companyName, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(width: 8),
        RoundedBackButton(
          backgroundColor: Colors.white,
          iconColor: AppColors.defaultColor,
          onPressed: () => Navigator.pop(context),
        ),
        SizedBox(width: 18),
        Expanded(
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              height: 40,
              padding: EdgeInsets.only(top: 10),
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(
                        companyName,
                        overflow: TextOverflow.fade,
                        style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.defaultColor),
                      ),
                    ),
                    SizedBox(width: 8),
                    SvgPicture.asset(
                      "assets/icons/arrow_down_icon.svg",
                      colorFilter: ColorFilter.mode(AppColors.defaultColor, BlendMode.srcIn),
                      width: 16,
                      height: 16,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        SizedBox(width: 24),
        SizedBox(width: 12),
      ],
    );
  }
}
