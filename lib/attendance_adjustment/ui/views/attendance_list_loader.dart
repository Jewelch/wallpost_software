import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class AttendanceListLoader extends StatelessWidget {
  const AttendanceListLoader({Key? key}) : super(key: key);

  final Color primaryContrastColor = Colors.yellow;

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        shrinkWrap: true,
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(20,20,20,8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _emptyContainer(height: 40,width: 130, cornerRadius: 8),
                SizedBox(width: 20,),
                _emptyContainer(height: 40,width: 130, cornerRadius: 8)
              ],
            ),
          ),
          _tile(context),
          SizedBox(height: 8),
          _tile(context),
          SizedBox(height: 8),
          _tile(context),
          SizedBox(height: 8),
          _tile(context),
          SizedBox(height: 8),
          _tile(context),
          SizedBox(height: 8),
          _tile(context),
          SizedBox(height: 8),
          _tile(context),
          SizedBox(height: 8),
          _tile(context),
          SizedBox(height: 8),
          _tile(context),
          SizedBox(height: 8),
          _tile(context),
          SizedBox(height: 8),
          _tile(context),
          SizedBox(height: 8),
          _tile(context),
          SizedBox(height: 8),
          _tile(context),
        ],
      ),
    );
  }

   Widget _tile(BuildContext context) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Container(
           padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey, width: 2,),
                  borderRadius: BorderRadiusDirectional.circular(8,)),

        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Column(
                    children: [
                      _emptyContainer(height: 16, width: 20, cornerRadius: 4),
                      SizedBox(height: 8,),
                      _emptyContainer(height: 16, width: 20, cornerRadius: 4),
                    ],
                  ),
                  SizedBox(width: 12,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _emptyContainer(height: 16, width: 180, cornerRadius: 8),
                      SizedBox(height: 8,),
                      _emptyContainer(height: 16, width: 80, cornerRadius: 8),

                    ],
                  ),
                ],
              ),
              _emptyContainer(height: 20, width: 20, cornerRadius: 2),
            ],
          ),
        ),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
    );
  }
}
