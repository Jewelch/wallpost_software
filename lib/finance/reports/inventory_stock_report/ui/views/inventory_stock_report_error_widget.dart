import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../../../_common_widgets/text_styles/text_styles.dart';

class InventoryStockReportErrorWidget extends StatelessWidget {
  final String errorMessage;
  final VoidCallback onRetryButtonPressed;

  const InventoryStockReportErrorWidget({
    required this.errorMessage,
    required this.onRetryButtonPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onRetryButtonPressed(),
      child: Container(
        color: AppColors.screenBackgroundColor2,
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: Text(
            errorMessage,
            style: TextStyles.titleTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
