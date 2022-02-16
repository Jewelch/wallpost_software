import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

import 'app_bar_divider.dart';

class CompanyListAppBar extends StatelessWidget implements PreferredSizeWidget {
  final TextButton textButton1;
  final Widget leadingButton;
  final Widget trailingButton;
  final bool showDivider;
  final VoidCallback? onLeadingButtonPressed;
  final VoidCallback? onTrailingButtonPressed;

  @override
  final Size preferredSize;

  CompanyListAppBar(
      {required this.textButton1,
      required this.leadingButton,
      required this.trailingButton,
      this.showDivider = false,
      this.onLeadingButtonPressed,
      this.onTrailingButtonPressed})
      : preferredSize = Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleSpacing: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      bottom: showDivider ? AppBarDivider() : null,
      // Don't show the default leading button
      automaticallyImplyLeading: false,
      title: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(children: [
                SizedBox(width: 16),
                GestureDetector(
                    onTap: onLeadingButtonPressed,
                    child: _constraintLeadingWidgetToSize(leadingButton)),
                SizedBox(width: 20),
              ]),
              textButton1,
              Row(children: [
                SizedBox(width: 20),
                GestureDetector(
                    onTap: onTrailingButtonPressed,
                    child: _constraintTrailingWidgetToSize(trailingButton)),
                SizedBox(width: 16),
              ]),
            ],
          ),
        ],
      ),
    );
  }

  Widget _constraintTrailingWidgetToSize(Widget widget) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Container(
          color: Colors.blue,
          child: SizedBox(
            width: 44,
            height: 38,
            child: Container(
              alignment: Alignment.center,
              child: widget,
            ),
          ),
        ));
  }

  Widget _constraintLeadingWidgetToSize(Widget widget) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: AlignmentDirectional.bottomEnd,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: SizedBox(
            width: 47,
            height: 50,
            child: Container(
              child: widget,
            ),
          ),
        ),
        Positioned(
            bottom: -2,
            right: -10,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Container(
                    width: 30,
                    height: 24,
                    alignment: Alignment.center,
                    color: Colors.blue,
                    child: SizedBox(
                        width: 12,
                        height: 10,
                        child: SvgPicture.asset(
                      'assets/icons/menu_icon.svg',
                      color: Colors.white,
                    )))))
      ],
    );
  }
}
