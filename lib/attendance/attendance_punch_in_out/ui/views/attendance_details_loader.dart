import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class AttendanceDetailsLoader extends StatelessWidget {

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
              Stack(
                alignment: Alignment.center,
                clipBehavior: Clip.none,
                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      _emptyContainer(height: 400, cornerRadius: 12),
                      Container(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          height: 70,
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _emptyContainer(height: 12, width: 80, cornerRadius: 12),
                                  _emptyContainer(height: 12, width: 80, cornerRadius: 12),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  _emptyContainer(height: 8, width: 80, cornerRadius: 12),
                                  _emptyContainer(height: 8, width: 80, cornerRadius: 12),
                                ],
                              ),
                            ],
                          )),
                    ],
                  ),
                  Positioned(
                    bottom: 0,
                    child: _emptyContainer(height: 160, width: 160, cornerRadius: 100),
                  ),
                ],
              ),
              SizedBox(height: 16,),
              Center(
                child:  _emptyContainer(height: 32, width: 120, cornerRadius: 12),
              )
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
