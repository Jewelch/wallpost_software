import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class StockExpirationFilterContainer extends StatelessWidget {
  final Widget child;
  const StockExpirationFilterContainer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      height: 36,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.textColorBlueGray)
      ),
      child: child,
    );
  }
}
