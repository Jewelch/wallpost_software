import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import 'app_bar_divider.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<CircularIconButton>? leadingButtons;
  final List<CircularIconButton>? trailingButtons;
  final bool showDivider;

  @override
  final Size preferredSize;

  SimpleAppBar({
    this.title,
    this.leadingButtons = const [],
    this.trailingButtons = const [],
    this.showDivider = false,
  }) : preferredSize = Size.fromHeight(56);

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
              if (leadingButtons != null)
                Row(children: [
                  ...[SizedBox(width: 12)],
                  ..._resizeButtons(leadingButtons!),
                ]),
              if (trailingButtons != null) Row(children: _resizeButtons(trailingButtons!)),
            ],
          ),
          if (title != null)
            Positioned.fill(
              child: Center(
                child: Text(
                  title!,
                  textAlign: TextAlign.center,
                  style: TextStyles.titleTextStyle.copyWith(fontSize: 18.0, color: AppColors.darkBlue, fontWeight: FontWeight.bold),
                ),
              ),
            )
        ],
      ),
    );
  }

  List<Widget> _resizeButtons(List<Widget> buttons) {
    List<Widget> resizedButtons = [];
    for (Widget button in buttons) {
      resizedButtons.add(_constraintWidgetToSize(button));
      resizedButtons.add(SizedBox(width: 8));
    }
    return resizedButtons;
  }

  Widget _constraintWidgetToSize(Widget widget) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Container(
            color: AppColors.lightBlue,
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
}
