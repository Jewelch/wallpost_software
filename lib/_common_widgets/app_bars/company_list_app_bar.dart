import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

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
                GestureDetector(onTap: onLeadingButtonPressed, child: _constraintLeadingWidgetToSize(leadingButton)),
                SizedBox(width: 20),
              ]),
              textButton1,
              Row(children: [
                SizedBox(width: 20),
                GestureDetector(onTap: onTrailingButtonPressed, child: _constraintTrailingWidgetToSize(trailingButton)),
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
        child: Center(
          child: Container(
            color: Colors.blue,
            child: SizedBox(
              width: 54,
              height: 38,
              child: Container(
                alignment: Alignment.center,
                child: widget,
              ),
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
            child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                        width: 24,
                        height: 20,
                        alignment: Alignment.center,
                        color: Colors.blue,
                        child: SizedBox(
                            width: 12,
                            height: 10,
                            child: SvgPicture.asset(
                              'assets/icons/menu_icon.svg',
                              color: Colors.white,
                            )))),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.white, width: 2),
                )))
      ],
    );
  }
}
