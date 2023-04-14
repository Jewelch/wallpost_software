import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

import '../../_shared/constants/app_colors.dart';

class CompanyNameAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String companyName;

  @override
  final Size preferredSize;

  CompanyNameAppBar(this.companyName) : preferredSize = Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      left: false,
      right: false,
      child: Container(
        color: Colors.white,
        child: Column(
          children: [
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                RoundedBackButton(
                  backgroundColor: Colors.white,
                  iconColor: AppColors.defaultColor,
                  onPressed: () => Navigator.pop(context),
                ),
                SizedBox(width: 24),
                Expanded(
                  child: GestureDetector(
                    onTap: Navigator.of(context).pop,
                    child: Container(
                      color: Colors.white,
                      height: 40,
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              child: Flexible(
                                child: Text(
                                  companyName,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: TextStyles.largeTitleTextStyleBold
                                      .copyWith(color: AppColors.defaultColor, fontWeight: FontWeight.w500),
                                ),
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
                SizedBox(width: 36),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
