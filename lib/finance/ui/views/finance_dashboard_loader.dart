import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/loader/seles_break_down_loader.dart';

class FinanceDashboardLoader extends StatelessWidget {
  const FinanceDashboardLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        children: [
          _appBar(context),
          SizedBox(height: 16),
          _tile(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 160,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
          _tile(context),
          _customChips(),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SalesBreakDownLoader(),
          )
        ],
      ),
    );
  }

  Widget _tile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _emptyContainer(height: 40, width: 120, cornerRadius: 6),
        ],
      ),
    );
  }

  Widget cards(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
              child: _emptyContainer(
            height: 80,
            cornerRadius: 20,
          )),
          SizedBox(width: 16),
          Expanded(
              child: _emptyContainer(
            height: 80,
            cornerRadius: 20,
          )),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          _emptyContainer(
            height: 40,
            width: 40,
            cornerRadius: 10,
          ),
          SizedBox(width: 40),
          Expanded(
              child: _emptyContainer(
            height: 26,
            cornerRadius: 6,
          )),
          SizedBox(width: 40),
          _emptyContainer(
            height: 40,
            width: 40,
            cornerRadius: 10,
          ),
        ],
      ),
    );
  }

  Widget _customChips() {
    return Row(
      children: [
        SizedBox(width: 24),
        Expanded(
          child: _emptyContainer(
            height: 32,
            width: 120,
            cornerRadius: 12,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _emptyContainer(
            height: 32,
            width: 120,
            cornerRadius: 12,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: _emptyContainer(
            height: 32,
            width: 120,
            cornerRadius: 12,
          ),
        ),
      ],
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
