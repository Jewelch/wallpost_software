import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class ExpenseListLoader extends StatelessWidget {
  const ExpenseListLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        padding: EdgeInsets.symmetric(horizontal: 12),
        children: [
          shimmerContainer(),
          shimmerContainer(),
          shimmerContainer(),
          shimmerContainer(),
          shimmerContainer(),
          shimmerContainer(),
          shimmerContainer(),
          shimmerContainer(),
          shimmerContainer(),
        ],
      ),
    );
  }

  shimmerContainer({double height = 120, double padding = 8, double margin = 8}) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(vertical: margin),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.shimmerColor,
          borderRadius: BorderRadius.circular(8),
        ),
      ),
    );
  }
}
