import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class ApprovalsAggregatedListLoader extends StatelessWidget {
  const ApprovalsAggregatedListLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        children: [
          _appBar(context),
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
      padding: const EdgeInsets.all(16.0),
      child: _emptyContainer(height: 80, width: 80, cornerRadius: 20),
    );
  }

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _emptyContainer(height: 40, width: 40, cornerRadius: 10),
          SizedBox(width: 40),
          Expanded(child: _emptyContainer(height: 26, cornerRadius: 6)),
          SizedBox(width: 40),
          _emptyContainer(height: 40, width: 40, cornerRadius: 10),
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
