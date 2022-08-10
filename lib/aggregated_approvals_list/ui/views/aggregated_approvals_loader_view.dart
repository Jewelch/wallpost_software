import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class AggregatedApprovalsLoaderView extends StatelessWidget {
  const AggregatedApprovalsLoaderView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        children: [
          _filters(),
          _tile(),
          SizedBox(height: 8),
          _tile(),
          SizedBox(height: 8),
          _tile(),
          SizedBox(height: 8),
          _tile(),
          SizedBox(height: 8),
          _tile(),
          SizedBox(height: 8),
          _tile(),
          SizedBox(height: 8),
          _tile(),
          SizedBox(height: 8),
          _tile(),
          SizedBox(height: 8),
          _tile(),
        ],
      ),
    );
  }

  Widget _tile() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, top: 12),
      child: _emptyContainer(height: 80, width: 80, cornerRadius: 10),
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
