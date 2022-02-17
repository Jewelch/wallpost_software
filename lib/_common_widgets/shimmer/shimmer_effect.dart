import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class ShimmerEffect extends StatelessWidget {
  final Widget child;

  const ShimmerEffect({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
        enabled: true,
        baseColor: AppColors.primaryContrastColor,
        highlightColor: Colors.white,
        child: Container(
          child: child,
        ),
      );
}
