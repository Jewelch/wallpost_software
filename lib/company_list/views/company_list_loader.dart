import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class CompanyListLoader extends StatelessWidget {
  const CompanyListLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 150,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: AppColors.primaryContrastColor,
              ),
            ),
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
      ),
    );
  }

  Widget _tile(BuildContext context) {
    return Row(
      children: [
        _emptyContainer(height: 80, width: 80, cornerRadius: 20),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            children: [
              _emptyContainer(height: 18, cornerRadius: 6),
              SizedBox(height: 16),
              _emptyContainer(height: 18, cornerRadius: 6),
            ],
          ),
        )
      ],
    );
  }

  _emptyContainer({required double height, double width = double.infinity, required double cornerRadius}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: AppColors.primaryContrastColor,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
    );
  }
}
