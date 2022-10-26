import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_item.dart';

// ignore: must_be_immutable
class SalesBreakDownCard extends StatelessWidget {
  final List<SalesBreakDownItem> _salesBreakDowns;
  double maxSale = double.minPositive;
  double minSale = double.maxFinite;

  SalesBreakDownCard(this._salesBreakDowns) {
    initialMaxAndMinSales();
  }

  void initialMaxAndMinSales() {
    for (var sales in _salesBreakDowns) {
      if (sales.totalSales > maxSale) {
        maxSale = sales.totalSales;
      } else if (sales.totalSales < minSale) {
        minSale = sales.totalSales;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.builder(
        padding: EdgeInsets.zero,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 7.0,
          mainAxisSpacing: 2.0,
          childAspectRatio: 1.8,
        ),
        itemCount: _salesBreakDowns.length,
        itemBuilder: ((context, index) => _getSalesBreakDownItemCard(_salesBreakDowns[index])),
      ),
    );
  }

  Card _getSalesBreakDownItemCard(SalesBreakDownItem salesBreakDownItem) {
    return Card(
      elevation: 2,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                salesBreakDownItem.totalSales.toString(),
                style: TextStyle(
                    color: getSalesBreakDownItemColor(salesBreakDownItem), fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 4,),
              Text(
                salesBreakDownItem.type,
                style: TextStyle(color: AppColors.textColorGray, fontSize: 16),
              ),
            ]),
      ),
    );
  }

  Color getSalesBreakDownItemColor(SalesBreakDownItem salesBreakDownItem) {
    if (salesBreakDownItem.totalSales == maxSale) return AppColors.green;
    if (salesBreakDownItem.totalSales == minSale) return AppColors.red;
    return AppColors.yellow;
  }
}
