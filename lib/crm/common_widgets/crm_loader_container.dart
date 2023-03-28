import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class CrmLoaderContainer extends StatelessWidget {
  CrmLoaderContainer({
    super.key,
    this.topRadius,
    this.bottomRadius,
    this.height,
    this.width,
    this.padding,
    this.onBottom = false,
  });

  final double? height;
  final double? width;
  final double? topRadius;
  final double? bottomRadius;
  final double? padding;
  final bool onBottom;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: padding ?? 0.0),
        child: Container(
          height: height,
          width: width,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(topRadius ?? 0),
              topRight: Radius.circular(topRadius ?? 0),
              bottomLeft: Radius.circular(bottomRadius ?? 0),
              bottomRight: Radius.circular(bottomRadius ?? 0),
            ),
          ),
        ),
      ),
    );
  }
}
