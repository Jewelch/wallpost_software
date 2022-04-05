import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import 'app_bar_divider.dart';

class AppBarWithBackButton extends StatelessWidget implements PreferredSizeWidget {
  final TextButton textButton1;
  final Widget leadingButton;
  final bool showDivider;
  final VoidCallback? onLeadingButtonPressed;

  @override
  final Size preferredSize;

  AppBarWithBackButton(
      {required this.textButton1,
      required this.leadingButton,
      this.showDivider = false,
      this.onLeadingButtonPressed,
      })
      : preferredSize = Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleSpacing: 0,
      backgroundColor: Colors.white,
      elevation: 0.0,
      bottom: showDivider ? AppBarDivider() : null,
      // Don't show the default leading button
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(children: [
            SizedBox(width: 20),
            GestureDetector(
                onTap: onLeadingButtonPressed,
                child: _constraintLeadingWidgetToSize(leadingButton)),
            SizedBox(width: 40),
          ]),
          textButton1,
        ],
      ), systemOverlayStyle: SystemUiOverlayStyle.dark,
    );
  }

  Widget _constraintLeadingWidgetToSize(Widget widget) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Container(
            color: Color(0xff0096e3),
            child: SizedBox(
              width: 42,
              height: 36,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(12),
                child: widget,
              ),
            ),
          ),
        ));
  }
}
