import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/left_menu/left_menu_button.dart';

import '../../_common_widgets/buttons/rounded_icon_button.dart';

class CompanyListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String profileImageUrl;
  final VoidCallback onLeftMenuButtonPressed;
  final VoidCallback onSearchButtonPressed;

  @override
  final Size preferredSize;

  CompanyListAppBar({
    required this.profileImageUrl,
    required this.onLeftMenuButtonPressed,
    required this.onSearchButtonPressed,
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(width: 12),
              LeftMenuButton(profileImageUrl, onLeftMenuButtonPressed),
              SizedBox(width: 20),
              Expanded(
                child: Center(
                    child: Text(
                  "Group Summary",
                  style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.defaultColor),
                )),
              ),
              SizedBox(width: 20),
              _searchButton(),
              SizedBox(width: 12),
            ],
          ),
        ],
      ),
    );
  }

  Widget _searchButton() {
    return RoundedIconButton(
      width: 46,
      height: 40,
      iconSize: 16,
      borderRadius: 14,
      iconName: 'assets/icons/search_icon.svg',
      onPressed: onSearchButtonPressed,
    );
  }
}
