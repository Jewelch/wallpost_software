import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

class PurchaseBillDetailLoader extends StatelessWidget {
  const PurchaseBillDetailLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: ListView(
          children: [
            SizedBox(height: 20),
            _emptyContainer(height: 40),
            SizedBox(height: 20),
            _tile(),
            SizedBox(height: 20),
            _tile(),
            SizedBox(height: 20),
            _tile(),
            SizedBox(height: 20),
            _tile(),
            SizedBox(height: 20),
            _tile(),
            SizedBox(height: 20),
            _tile(),
            SizedBox(height: 20),
            _tile(),
            SizedBox(height: 20),
            _tile(),
            SizedBox(height: 20),
            _tile(),
            SizedBox(height: 20),
            _tile(),
          ],
        ),
      ),
    );
  }

  Widget _tile() {
    return Row(
      children: [
        _emptyContainer(height: 26, width: 100),
        SizedBox(width: 20),
        _emptyContainer(height: 26, width: 200),
      ],
    );
  }

  Container _emptyContainer({double height = 16, double width = 10}) => Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 1),
          color: Colors.white,
        ),
      );
}
