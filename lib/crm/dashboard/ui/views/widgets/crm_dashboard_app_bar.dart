import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';

import '../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../_shared/constants/app_colors.dart';

class CrmDashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _companyName;

  CrmDashboardAppBar(this._companyName);

  @override
  Size get preferredSize => Size.fromHeight(56.0);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.screenBackgroundColor,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24),
          ),
        ),
        child: Column(
          children: [
            SizedBox(height: 8),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(width: 12),
                GestureDetector(
                  onTap: Navigator.of(context).pop,
                  child: Container(
                    color: Colors.white,
                    width: 40,
                    height: 40,
                    child: Center(
                      child: SizedBox(
                        width: 16,
                        height: 16,
                        child: SvgPicture.asset(
                          "assets/icons/arrow_back_icon.svg",
                          colorFilter: ColorFilter.mode(AppColors.defaultColor, BlendMode.srcIn),
                          width: 16,
                          height: 16,
                        ),
                      ),
                    ),
                  ),
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
                                  _companyName,
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
