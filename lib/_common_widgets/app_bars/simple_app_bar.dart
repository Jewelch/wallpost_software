import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leadingButton;
  final Widget? trailingButton;
  final VoidCallback? onDownArrowButtonPressed;
  final VoidCallback? onLeadingButtonPressed;
  final VoidCallback? onTrailingButtonPressed;

  @override
  final Size preferredSize;

  SimpleAppBar({
    required this.title,
    this.leadingButton,
    this.trailingButton,
    this.onDownArrowButtonPressed,
    this.onLeadingButtonPressed,
    this.onTrailingButtonPressed,
  }) : preferredSize = Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleSpacing: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Stack(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (leadingButton != null)
                Row(children: [
                  SizedBox(width: 16),
                  GestureDetector(onTap: onLeadingButtonPressed, child: _constraintWidgetToSize(leadingButton!)),
                  SizedBox(width: 20),
                ]),
              Expanded(child: _makeCenterTitleView(),),
              if (trailingButton != null)
                Row(children: [
                  SizedBox(width: 20),
                  GestureDetector(onTap: onTrailingButtonPressed, child: _constraintWidgetToSize(trailingButton!)),
                  SizedBox(width: 16),
                ]),
            ],
          ),
        ],
      ),
    );
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

  Widget _makeCenterTitleView() {
    return ClipRRect(
      child: Container(
        height: 32,
        width: double.infinity,
        child: Row(
          children: [
            Container(
              child: Center(
                child: Text(title, style: TextStyle(color: AppColors.lightBlue, fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
            SizedBox(width: 8.0,),
            InkWell(
              child: Center(
                child: SvgPicture.asset(
                  'assets/icons/down_arrow_icon.svg',
                  color: AppColors.lightBlue,
                  width: 16,
                  height: 16,
                ),
              ),
              onTap: () {
                if (onDownArrowButtonPressed != null) onDownArrowButtonPressed!();
              },
            ),
          ],
        ),
      ),
    );
  }
}
