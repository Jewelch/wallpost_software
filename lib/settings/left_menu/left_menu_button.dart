import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../../_shared/constants/app_colors.dart';

class LeftMenuButton extends StatelessWidget {
  final String profileImageUrl;
  final VoidCallback onLeftMenuButtonPressed;

  LeftMenuButton(this.profileImageUrl, this.onLeftMenuButtonPressed);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onLeftMenuButtonPressed,
      child: Container(
        child: Stack(
          clipBehavior: Clip.none,
          alignment: AlignmentDirectional.bottomEnd,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                width: 40,
                height: 40,
                child: CachedNetworkImage(
                  fit: BoxFit.cover,
                  alignment: Alignment.topCenter,
                  imageUrl: profileImageUrl,
                  placeholder: (context, url) => Container(color: AppColors.defaultColorDarkContrastColor),
                  errorWidget: (context, url, error) => Container(color: AppColors.defaultColorDarkContrastColor),
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
                  child: SvgPicture.asset('assets/icons/menu_icon.svg', width: 10, height: 10),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
