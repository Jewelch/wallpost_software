import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/shimmer/shimmer_effect.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/ui/views/loader/seles_break_down_loader.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/views/loader/item_sales_loader_container.dart';

class ItemSalesLoader extends StatelessWidget {
  const ItemSalesLoader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        children: [
          _appBar(context),
          SizedBox(height: 5),
          _tile(context),
          SizedBox(height: 5),
          _filters(context),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Container(
              height: 200,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.white,
              ),
            ),
          ),
          SizedBox(height: 20),
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
          ItemSalesContainerLoader(
            height: 40,
            width: 120,
            topRadius: 6,
            bottomRadius: 6,
          ),
        ],
      ),
    );
  }

  Widget _filters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 24.0, bottom: 12, right: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ItemSalesContainerLoader(
            height: 40,
            width: 50,
            topRadius: 6,
            bottomRadius: 6,
          ),
          ItemSalesContainerLoader(
            height: 40,
            width: 80,
            topRadius: 6,
            bottomRadius: 6,
          ),
          ItemSalesContainerLoader(
            height: 40,
            width: 80,
            topRadius: 6,
            bottomRadius: 6,
          ),
          ItemSalesContainerLoader(
            height: 40,
            width: 80,
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
              child: ItemSalesContainerLoader(
            height: 80,
            topRadius: 20,
            bottomRadius: 20,
          )),
          SizedBox(width: 16),
          Expanded(
              child: ItemSalesContainerLoader(
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
          ItemSalesContainerLoader(
            height: 40,
            width: 40,
            topRadius: 10,
            bottomRadius: 10,
          ),
          SizedBox(width: 40),
          Expanded(
              child: ItemSalesContainerLoader(
            height: 26,
            topRadius: 6,
            bottomRadius: 6,
          )),
          SizedBox(width: 40),
          ItemSalesContainerLoader(
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
          child: ItemSalesContainerLoader(
            height: 32,
            width: 120,
            topRadius: 12,
            bottomRadius: 12,
          ),
        ),
        Expanded(child: SizedBox(width: 15)),
        Expanded(
          child: ItemSalesContainerLoader(
            height: 32,
            width: 120,
            topRadius: 12,
            bottomRadius: 12,
          ),
        ),
        SizedBox(width: 24),
      ],
    );
  }
}
