import 'package:flutter/material.dart';

import '../../../../_shared/constants/app_colors.dart';

class ModuleBoxViewHolder extends StatelessWidget {
  final Widget content;
  final Color backgroundColor;

  ModuleBoxViewHolder({
    required this.content,
    this.backgroundColor = AppColors.screenBackgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: content,
    );
  }
}
