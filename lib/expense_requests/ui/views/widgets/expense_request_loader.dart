import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';
import '../../../../_shared/constants/app_colors.dart';

class ExpenseRequestLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
        child: ListView(
      padding: EdgeInsets.all(16),
      children: [
        ...shimmerInputWithHeader(),
        ...shimmerInputWithHeader(),
        ...shimmerInputWithHeader(),
        ...shimmerInputWithHeader(),
        ...shimmerInputWithHeader(),
        ...shimmerInputWithHeader(),
        ...shimmerInputWithHeader(),
        ...shimmerInputWithHeader(),
      ],
    ));
  }
}

List<Widget> shimmerInputWithHeader() {
  return [
    Row(
      children: [
        Container(
          decoration: BoxDecoration(
              color: AppColors.primaryContrastColor, borderRadius: BorderRadius.circular(10)),
          height: 28,
          width: 160,
          constraints: BoxConstraints(maxWidth: 160, maxHeight: 28, minWidth: 8),
          child: SizedBox(),
        ),
      ],
    ),
    SizedBox(
      height: 8,
    ),
    Container(
      height: 80,
      constraints: BoxConstraints(maxWidth: 64, maxHeight: 40, minWidth: 8),
      decoration: BoxDecoration(color: AppColors.lightGrey, borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    ),
    SizedBox(
      height: 16,
    ),
  ];
}
