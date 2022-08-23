import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class AggregatedApprovalsLoaderView extends StatelessWidget {
  const AggregatedApprovalsLoaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        shrinkWrap: true,
        children: [
          SizedBox(height: 8),
          _filters(),
          SizedBox(height: 8),
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
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2), borderRadius: BorderRadiusDirectional.circular(8)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                _emptyContainer(height: 20, width: 20, cornerRadius: 2),
                SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _emptyContainer(height: 16, width: 180, cornerRadius: 8),
                    SizedBox(height: 8),
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

  Widget _filters() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 16, 12, 8),
      child: Row(
        children: [
          Expanded(child: _emptyContainer(height: 50, cornerRadius: 10)),
          SizedBox(width: 12),
          Expanded(child: _emptyContainer(height: 50, cornerRadius: 10)),
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
