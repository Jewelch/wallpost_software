import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class AttendanceReportsLoader extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        shrinkWrap: true,
        padding:  EdgeInsets.symmetric(horizontal: 12,vertical: 12),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _emptyContainer(height: 12, width: 80, cornerRadius: 12),
                  _emptyContainer(height: 12, width: 80, cornerRadius: 12),
                  _emptyContainer(height: 12, width: 80, cornerRadius: 12),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _emptyContainer(height: 8, width: 80, cornerRadius: 12),
                  _emptyContainer(height: 8, width: 80, cornerRadius: 12),
                  _emptyContainer(height: 8, width: 80, cornerRadius: 12),
                ],
              ),
            ],
          )
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
