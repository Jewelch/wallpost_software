import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import '../../_common_widgets/app_bars/app_bar_divider.dart';

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
      leading: IconButton(
        onPressed: onLeadingButtonPressed,
        icon: Icon(Icons.arrow_back,color: AppColors.defaultColor,),
      ),
      title:
          textButton1,
    );
  }

  Widget _constraintLeadingWidgetToSize(Widget widget) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Center(
          child: Container(
            color: AppColors.defaultColor,
            child: SizedBox(
              width: 44,
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
