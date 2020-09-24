import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class WPAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget leading;
  final Widget trailing;
  final bool showCompanySwitchButton;
  final int companySwitchBadgeCount;

  @override
  final Size preferredSize;

  WPAppBar({
    this.title,
    this.leading,
    this.trailing,
    this.showCompanySwitchButton = false,
    this.companySwitchBadgeCount = 0,
  }) : preferredSize = Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleSpacing: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      // Don't show the leading button
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          this.leading ?? SizedBox(width: 12),
          Expanded(child: _makeCenterTitleView()),
          this.trailing ?? SizedBox(width: 12),
        ],
      ),
    );
  }

  Widget _makeCenterTitleView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Container(
        height: 36,
        width: double.infinity,
        color: AppColors.defaultColor,
        child: Row(
          children: [
            SizedBox(width: 8),
            Expanded(
              child: Container(
                child: Center(
                  child: Text(title, style: TextStyle(color: Colors.white, fontSize: 16)),
                ),
              ),
            ),
            if (showCompanySwitchButton) _makeCompanySwitchButton(),
          ],
        ),
      ),
    );
  }

  Widget _makeCompanySwitchButton() {
    return Container(
      height: 36,
      width: 40,
      color: AppColors.defaultColorDark,
      child: Stack(
        children: [
          Positioned.fill(
            child: FlatButton(
              padding: EdgeInsets.only(right: companySwitchBadgeCount == 0 ? 0 : 6),
              child: SvgPicture.asset(
                'assets/icons/switch_company_icon.svg',
                color: Colors.white,
                width: 20,
                height: 20,
              ),
              onPressed: () {},
            ),
          ),
          if (companySwitchBadgeCount > 0)
            Positioned(
              left: 16,
              top: 4,
              child: _makeBadge(),
            ),
        ],
      ),
    );
  }

  Widget _makeBadge() {
    return Container(
      width: 16,
      height: 16,
      decoration: BoxDecoration(
        color: AppColors.badgeColor,
        borderRadius: BorderRadius.circular(100),
      ),
      child: Center(
        child: Text(
          '${companySwitchBadgeCount < 99 ? companySwitchBadgeCount : '99+'}',
          style: TextStyle(color: Colors.white, fontSize: companySwitchBadgeCount < 99 ? 10 : 8),
        ),
      ),
    );
  }
}
