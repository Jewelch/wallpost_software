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
        padding: EdgeInsets.all(20),
        children: [
          shimmerContainer(height: 40, padding: 0,margin: 0),
          SizedBox(height: 12),
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
      padding: EdgeInsets.symmetric(horizontal: padding),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.shimmerColor,
          borderRadius: BorderRadius.circular(8),
        ),

      ),
    );
  }

}
