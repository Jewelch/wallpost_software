import 'package:flutter/material.dart';

import '../../../../_common_widgets/shimmer/shimmer_effect.dart';

class ModuleLoader extends StatelessWidget {
  const ModuleLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Row(
              children: [
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _emptyContainer(height: 24, cornerRadius: 8),
                      SizedBox(height: 6),
                      _emptyContainer(height: 12, width: 100, cornerRadius: 8),
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _emptyContainer(height: 24, cornerRadius: 8),
                      SizedBox(height: 6),
                      _emptyContainer(height: 12, width: 100, cornerRadius: 8),
                    ],
                  ),
                ),
                SizedBox(width: 12),
              ],
            ),
            SizedBox(height: 30),
            Row(
              children: [
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _emptyContainer(height: 24, cornerRadius: 8),
                      SizedBox(height: 6),
                      _emptyContainer(height: 12, width: 100, cornerRadius: 8),
                    ],
                  ),
                ),
                SizedBox(width: 30),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _emptyContainer(height: 24, cornerRadius: 8),
                      SizedBox(height: 6),
                      _emptyContainer(height: 12, width: 100, cornerRadius: 8),
                    ],
                  ),
                ),
                SizedBox(width: 12),
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
