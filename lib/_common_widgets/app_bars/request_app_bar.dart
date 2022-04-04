import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import 'app_bar_divider.dart';

class RequestsAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;


  @override
  final Size preferredSize;

  RequestsAppBar({
    required this.title,
  }) : preferredSize = Size.fromHeight(56);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      title: Text(
        title,
        style: TextStyle(color: AppColors.darkBlue, fontWeight: FontWeight.bold),
      ),
      centerTitle: false,
      leading: Center(
        child: Container(
          width: 36,
          height: 28,
          constraints: BoxConstraints(maxHeight: 28, maxWidth: 36),
          decoration:
          BoxDecoration(color: AppColors.lightBlue, borderRadius: BorderRadius.circular(12)),
          alignment: Alignment.center,
          child: Icon(
            Icons.arrow_back_ios_outlined,
            color: AppColors.primaryContrastColor,
            size: 12,
          ),
        ),
      ),
      bottom: AppBarDivider(),
    );
  }


}
