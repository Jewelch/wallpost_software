import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class CompanyListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final Widget leadingButton;
  final Widget trailingButton;

  @override
  final Size preferredSize;

  CompanyListAppBar({
    required this.leadingButton,
    required this.trailingButton,
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
              Row(children: [
                SizedBox(width: 12),
                _addMenuButtonToLeadingWidget(leadingButton),
                SizedBox(width: 20),
              ]),
              Expanded(
                child: Center(
                    child: Text(
                  "Group Dashboard",
                  style: TextStyles.largeTitleTextStyleBold.copyWith(color: AppColors.defaultColor),
                )),
              ),
              Row(children: [
                SizedBox(width: 20),
                trailingButton,
                SizedBox(width: 12),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _addMenuButtonToLeadingWidget(Widget? widget) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 40,
            height: 40,
            child: Container(
              child: widget,
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
    );
  }
}
