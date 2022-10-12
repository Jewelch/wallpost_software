import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class EmployeeDashboardLoader extends StatelessWidget {
  const EmployeeDashboardLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        padding: EdgeInsets.only(left: 12, right: 12),
        children: [
          SizedBox(height: 20),
          _emptyContainer(height: 240, cornerRadius: 20),
          SizedBox(height: 24),
          Container(
            height: 200,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _emptyContainer(height: 120, width: 120, cornerRadius: 12),
                SizedBox(width: 16),
                _emptyContainer(height: 120, width: 120, cornerRadius: 12),
                SizedBox(width: 16),
                _emptyContainer(height: 120, width: 120, cornerRadius: 12),
                SizedBox(width: 16),
                _emptyContainer(height: 120, width: 120, cornerRadius: 12),
              ],
            ),
          ),
          SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 140,
                height: 140,
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(width: 12),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                  child: Column(
                children: [
                  _emptyContainer(height: 50, cornerRadius: 12),
                  SizedBox(height: 20),
                  _emptyContainer(height: 50, cornerRadius: 12),
                ],
              ))
            ],
          ),
          SizedBox(height: 30),
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
