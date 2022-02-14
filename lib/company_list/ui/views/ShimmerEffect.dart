
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmerEffect extends StatelessWidget {
  final double width;
  final double height;
  final ShapeBorder shapeBorder;

  const ListShimmerEffect.rectangular(
      {this.width = double.infinity, required this.height})
      : this.shapeBorder = const RoundedRectangleBorder();

  const ListShimmerEffect.circular(
      {this.width = double.infinity,
        required this.height,
        this.shapeBorder = const CircleBorder()});

  @override
  Widget build(BuildContext context) => Shimmer.fromColors(
    enabled: false,
    baseColor: Colors.grey,
    highlightColor: Colors.white,

    child: Container(
      width: width,
      height: height,
      decoration: ShapeDecoration(
        color: Colors.grey,
        shape: shapeBorder,
      ),
    ),
  );
}