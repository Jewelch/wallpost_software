import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';

import 'restaurant_dashboard_sales_break_down_loader.dart';

class RestaurantDashboardLoader extends StatelessWidget {
  const RestaurantDashboardLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        children: [
          _appBar(context),
          SizedBox(height: 16),
          _tile(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              height: 220,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 16),
          _tile(context),
          _customChips(),
          SizedBox(height: 16),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: SalesBreakDownLoader(height: 350, cornerRadius: 14, width: double.infinity),
          )
        ],
      ),
    );
  }

  Widget _tile(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SalesBreakDownLoader(height: 40, width: 120, cornerRadius: 6),
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
          Expanded(child: SalesBreakDownLoader(height: 80, cornerRadius: 20)),
          SizedBox(width: 16),
          Expanded(child: SalesBreakDownLoader(height: 80, cornerRadius: 20)),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          SalesBreakDownLoader(height: 40, width: 40, cornerRadius: 10),
          SizedBox(width: 40),
          Expanded(child: SalesBreakDownLoader(height: 26, cornerRadius: 6)),
          SizedBox(width: 40),
          SalesBreakDownLoader(height: 40, width: 40, cornerRadius: 10),
        ],
      ),
    );
  }

  Widget _customChips() {
    return Row(
      children: [
        SizedBox(width: 24),
        SalesBreakDownLoader(height: 40, width: 120, cornerRadius: 12),
        SizedBox(width: 15),
        SalesBreakDownLoader(height: 40, width: 120, cornerRadius: 12),
        SizedBox(width: 15),
        SalesBreakDownLoader(height: 40, width: 120, cornerRadius: 12),
      ],
    );
  }

  // _emptyContainer({required double height, double width = 80, required double cornerRadius}) {
  //   return Container(
  //     height: height,
  //     width: width,
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(cornerRadius),
  //     ),
  //   );
  // }
}
