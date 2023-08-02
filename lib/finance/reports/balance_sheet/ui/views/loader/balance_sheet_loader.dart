import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/shimmer/shimmer_effect.dart';
import '../../../../../../restaurant_and_retail/common_widgets/restaurant_retail_loader_container.dart';
import '../../../../../../restaurant_and_retail/common_widgets/sales_break_down_loader.dart';

class BalanceSheetLoader extends StatelessWidget {
  const BalanceSheetLoader({Key? key}) : super(key: key);

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
            child: SalesBreakDownLoader(count: 3),
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
          RestaurantRetailLoaderContainer(
            height: 40,
            width: 120,
            topRadius: 6,
            bottomRadius: 6,
          ),
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
              child: RestaurantRetailLoaderContainer(
            height: 80,
            topRadius: 20,
            bottomRadius: 20,
          )),
          SizedBox(width: 16),
          Expanded(
              child: RestaurantRetailLoaderContainer(
            height: 80,
            topRadius: 20,
            bottomRadius: 20,
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
          RestaurantRetailLoaderContainer(
            height: 40,
            width: 40,
            topRadius: 10,
            bottomRadius: 10,
          ),
          SizedBox(width: 40),
          Expanded(
              child: RestaurantRetailLoaderContainer(
            height: 26,
            topRadius: 6,
            bottomRadius: 6,
          )),
          SizedBox(width: 40),
          RestaurantRetailLoaderContainer(
            height: 40,
            width: 40,
            topRadius: 10,
            bottomRadius: 10,
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
          child: RestaurantRetailLoaderContainer(
            height: 32,
            width: 120,
            topRadius: 12,
            bottomRadius: 12,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: RestaurantRetailLoaderContainer(
            height: 32,
            width: 120,
            topRadius: 12,
            bottomRadius: 12,
          ),
        ),
        SizedBox(width: 15),
        Expanded(
          child: RestaurantRetailLoaderContainer(
            height: 32,
            width: 120,
            topRadius: 12,
            bottomRadius: 12,
          ),
        ),
      ],
    );
  }
}
