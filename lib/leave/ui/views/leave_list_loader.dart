import 'package:flutter/cupertino.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

import '../../../_shared/constants/app_colors.dart';

class LeaveListLoader extends StatelessWidget {
  const LeaveListLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        padding: EdgeInsets.only(left: 12, right: 12, top: 20),
        children: [
          _listTile(),
          SizedBox(height: 12),
          _listTile(),
          SizedBox(height: 12),
          _listTile(),
          SizedBox(height: 12),
          _listTile(),
          SizedBox(height: 12),
          _listTile(),
          SizedBox(height: 12),
          _listTile(),
          SizedBox(height: 12),
          _listTile(),
          SizedBox(height: 12),
          _listTile(),
          SizedBox(height: 12),
          _listTile(),
          SizedBox(height: 12),
          _listTile(),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  _listTile() {
    return Container(
      height: 80,
      child: Row(
        children: [
          _emptyContainer(height: 70, width: 70, cornerRadius: 35),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _emptyContainer(height: 20, cornerRadius: 6),
                SizedBox(height: 10),
                _emptyContainer(height: 20, cornerRadius: 6),
              ],
            ),
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
        color: AppColors.primaryContrastColor,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
    );
  }
}
