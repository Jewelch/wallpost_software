import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/loader/seles_break_down_loader.dart';

import 'restaurant_dashboard_container_loader.dart';

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
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 120,
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
            child: SalesBreakDownLoader(),
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
          RestaurantContainerLoader(height: 40, width: 120, cornerRadius: 6),
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
          Expanded(child: RestaurantContainerLoader(height: 80, cornerRadius: 20)),
          SizedBox(width: 16),
          Expanded(child: RestaurantContainerLoader(height: 80, cornerRadius: 20)),
        ],
      ),
    );
  }

  Widget _appBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Row(
        children: [
          RestaurantContainerLoader(height: 40, width: 40, cornerRadius: 10),
          SizedBox(width: 40),
          Expanded(child: RestaurantContainerLoader(height: 26, cornerRadius: 6)),
          SizedBox(width: 40),
          RestaurantContainerLoader(height: 40, width: 40, cornerRadius: 10),
        ],
      ),
    );
  }

  Widget _customChips() {
    return Row(
      children: [
        SizedBox(width: 24),
        Expanded(
          child: RestaurantContainerLoader(height: 40, width: 120, cornerRadius: 12),
        ),
        SizedBox(width: 15),
        Expanded(
          child: RestaurantContainerLoader(height: 40, width: 120, cornerRadius: 12),
        ),
        SizedBox(width: 15),
        Expanded(
          child: RestaurantContainerLoader(height: 40, width: 120, cornerRadius: 12),
        ),
      ],
    );
  }
}
