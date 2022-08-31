import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class ExpenseRequestLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 30),
          _tile(context),
          SizedBox(height: 20),
          _tile(context),
          SizedBox(height: 20),
          _tile(context),
          SizedBox(height: 20),
          _tile(context),
          SizedBox(height: 20),
          _tile(context),
          SizedBox(height: 20),
          _tile(context),
          SizedBox(height: 20),
          _tile(context),
          SizedBox(height: 20),
          _tile(context),
          SizedBox(height: 20),
          _tile(context),
          SizedBox(height: 20),
          _tile(context),
          SizedBox(height: 20),
          _tile(context),
          SizedBox(height: 20),
          _tile(context),
          SizedBox(height: 20),
          _tile(context),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _emptyContainer(height: 20, width: MediaQuery.of(context).size.width / 2, cornerRadius: 8),
          SizedBox(height: 6),
          _emptyContainer(height: 50, cornerRadius: 12)
        ],
      ),
    );
  }

  _emptyContainer({required double height, double width = double.infinity, required double cornerRadius}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
    );
  }
}
