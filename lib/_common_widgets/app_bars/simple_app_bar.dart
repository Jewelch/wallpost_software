import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

class SimpleAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Widget? leadingButton;
  final Widget? trailingButton;

  @override
  final Size preferredSize;

  SimpleAppBar({
    required this.title,
    this.leadingButton,
    this.trailingButton,
  }) : preferredSize = Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: true,
      titleSpacing: 0,
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(width: 12),
          if (leadingButton != null) leadingButton!,
          if (leadingButton != null) SizedBox(width: 8),
          Expanded(child: Text(title, style: TextStyles.screenTitleTextStyle)),
          if (trailingButton != null) SizedBox(width: 8),
          if (trailingButton != null) trailingButton!,
          SizedBox(width: 12),
        ],
      ),
    );
  }
}
