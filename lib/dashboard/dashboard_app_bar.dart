import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/left_menu/left_menu_button.dart';

import '../../_common_widgets/buttons/rounded_icon_button.dart';

class DashboardAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String companyName;
  final String profileImageUrl;
  final VoidCallback onLeftMenuButtonPress;
  final VoidCallback onAddButtonPress;
  final VoidCallback onTitlePress;

  @override
  final Size preferredSize;

  DashboardAppBar({
    required this.companyName,
    required this.profileImageUrl,
    required this.onLeftMenuButtonPress,
    required this.onAddButtonPress,
    required this.onTitlePress,
  }) : preferredSize = Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleSpacing: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      backgroundColor: Colors.white,
      elevation: 0.0,
      // Don't show the default leading button
      automaticallyImplyLeading: false,
      title: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 12),
              LeftMenuButton(profileImageUrl, onLeftMenuButtonPress),
              SizedBox(width: 24),
              Expanded(
                child: GestureDetector(
                  onTap: onTitlePress,
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
                            color: AppColors.defaultColor,
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
              _addButton(),
              SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addButton() {
    return RoundedIconButton(
      width: 46,
      height: 40,
      iconSize: 16,
      borderRadius: 14,
      iconName: 'assets/icons/plus_icon.svg',
      onPressed: onAddButtonPress,
    );
  }
}
