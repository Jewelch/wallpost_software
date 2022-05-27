import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/dashboard/ui/left_menu_screen.dart';

import '../../../../_common_widgets/buttons/rounded_icon_button.dart';

class MyPortalAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String profileImageUrl;
  final VoidCallback onAddButtonPressed;

  @override
  final Size preferredSize;

  MyPortalAppBar({
    required this.profileImageUrl,
    required this.onAddButtonPressed,
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
              _menuButton(context),
              SizedBox(width: 10),
              Center(
                  child: Row(
                children: [
                  Text(
                    "itialuS Qatar",
                    style: TextStyles.largeTitleTextStyleBold
                        .copyWith(color: AppColors.defaultColor),
                  ),
                  SizedBox(width: 10),
                  SvgPicture.asset('assets/icons/down_arrow_icon.svg',height: 16,width: 16,color: AppColors.defaultColor)
                ],
              )),
              SizedBox(width: 10),
              _addButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuButton(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () => LeftMenuScreen.show(context),
        child: Container(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: AlignmentDirectional.bottomEnd,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: SizedBox(
                  width: 40,
                  height: 40,
                  child: Container(
                    child: FadeInImage.assetNetwork(
                      placeholder: 'assets/logo/placeholder.jpg',
                      image: profileImageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Positioned(
                bottom: -6,
                right: -12,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: Container(
                    width: 30,
                    height: 24,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.defaultColor,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: SvgPicture.asset('assets/icons/menu_icon.svg',
                        width: 10, height: 10),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _addButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedIconButton(
        iconName: 'assets/icons/plus_icon.svg',
        onPressed: onAddButtonPressed,
        iconSize: 10,
      ),
    );
  }
}
