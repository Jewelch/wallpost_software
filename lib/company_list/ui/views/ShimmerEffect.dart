import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ListShimmerEffect extends StatelessWidget {
  final Widget widget;
  final double width;
  final double height;

  const ListShimmerEffect(
      {Key? key, required this.widget, required this.width, required this.height})
      : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Shimmer.fromColors(
        baseColor: Colors.grey,
        highlightColor: Colors.white,
        child: Container(
          width: width,
          height: height,
          child: widget,
        ),
      );
}