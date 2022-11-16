import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class SalesBreakDownLoader extends StatelessWidget {
  SalesBreakDownLoader({
    super.key,
    this.cornerRadius,
    this.height,
    this.width,
    this.padding,
  });

  final double? height;
  final double? width;
  final double? cornerRadius;
  final double? padding;

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
            borderRadius: BorderRadius.circular(cornerRadius ?? 0),
          ),
        ),
      ),
    );
  }
}
