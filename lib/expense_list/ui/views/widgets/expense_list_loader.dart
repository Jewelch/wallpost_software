import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class ExpenseListLoader extends StatelessWidget {
  const ExpenseListLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
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

  shimmerContainer({double height = 120, double padding = 8}) {
    return Container(
      height: height,
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          width: 1,
          color: AppColors.textFieldBackgroundColor,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          SizedBox(
            height: 4,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _emptyContainer(),
              ),
              SizedBox(
                width: 80,
              ),
              Expanded(
                child: _emptyContainer(),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _emptyContainer(),
              ),
              SizedBox(
                width: 80,
              ),
              Expanded(
                child: _emptyContainer(),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: _emptyContainer(),
              ),
              SizedBox(
                width: 80,
              ),
              Expanded(
                child: _emptyContainer(),
              ),
            ],
          ),
          SizedBox(height: 8),
          _emptyContainer()
        ],
      ),
    );
  }

  Container _emptyContainer({double height = 16, double width = 56}) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            width: 1,
          ),
          color: Colors.white,
        ),
      );
}
