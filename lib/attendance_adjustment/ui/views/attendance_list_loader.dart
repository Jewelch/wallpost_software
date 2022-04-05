import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

import '../../../_shared/constants/app_colors.dart';

class AttendanceListLoader extends StatelessWidget {
  const AttendanceListLoader({Key? key}) : super(key: key);


  final Color primaryContrastColor = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
        ),
      ),
    );
  }

  Widget _tile(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _emptyContainer(height: 12, width: 112, cornerRadius: 20),
            _emptyContainer(height: 12, width: 88, cornerRadius: 20),
          ],
        ),
        SizedBox(height: 12,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Column(
                  children: [
                    _emptyContainer(height: 12, width: 80, cornerRadius: 20),
                    SizedBox(height: 4,),
                    _emptyContainer(height: 12, width: 80, cornerRadius: 20),
                  ],
                ),
                SizedBox(width: 28,),
                Column(
                  children: [
                    _emptyContainer(height: 12, width: 80, cornerRadius: 20),
                    SizedBox(height: 4,),
                    _emptyContainer(height: 12, width: 80, cornerRadius: 20),
                  ],
                ),
              ],
            ),
            _emptyContainer(height: 12, width: 88, cornerRadius: 20),
          ],
        ),
        Divider(),
      ],
    );
  }

  _emptyContainer(
      {required double height,
      double width = double.infinity,
      required double cornerRadius}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: primaryContrastColor,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
    );
  }
}
