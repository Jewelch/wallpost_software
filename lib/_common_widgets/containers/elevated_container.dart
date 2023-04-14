import 'package:flutter/material.dart';

class ElevatedContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;
  final Color? color;
  final BoxConstraints? constraints;
  final BoxBorder? border;

  ElevatedContainer({
    Key? key,
    required this.child,
    this.padding,
    this.color,
    this.constraints,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(14.0),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.03), spreadRadius: 5, blurRadius: 5),
        ],
        border: border,
      ),
      margin: EdgeInsets.only(left: 24, right: 24, top: 16),
      padding: padding ?? EdgeInsets.all(8.0),
      clipBehavior: Clip.hardEdge,
      constraints: constraints,
      child: child,
    );
  }
}
