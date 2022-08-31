import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class LeaveApprovalListLoader extends StatelessWidget {
  const LeaveApprovalListLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        shrinkWrap: true,
        children: [
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
          SizedBox(height: 20),
          _tile(context),
        ],
      ),
    );
  }

  Widget _tile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 20),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2), borderRadius: BorderRadiusDirectional.circular(8)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(child: _emptyContainer(height: 22, cornerRadius: 8)),
                SizedBox(width: 12),
                _emptyContainer(height: 22, width: 80, cornerRadius: 8),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _emptyContainer(height: 16, width: 180, cornerRadius: 8),
                _emptyContainer(height: 16, width: 120, cornerRadius: 8),
              ],
            ),
            SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _emptyContainer(height: 16, width: 180, cornerRadius: 8),
                _emptyContainer(height: 16, width: 120, cornerRadius: 8),
              ],
            ),
          ],
        ),
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
