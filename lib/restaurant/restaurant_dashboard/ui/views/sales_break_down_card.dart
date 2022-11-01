import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/extensions/string_extensions.dart';
import 'package:wallpost/restaurant/restaurant_dashboard/entities/sales_break_down_item.dart';

// ignore: must_be_immutable
class SalesBreakDownCard extends StatelessWidget {
  final List<SalesBreakDownItem> _salesBreakDowns;
  double _maxSale = double.minPositive;
  double _minSale = double.maxFinite;

  SalesBreakDownCard(
    this._salesBreakDowns, {
    super.key,
  }) {
    _initialMaxAndMinSales();
  }

  void _initialMaxAndMinSales() {
    for (var sales in _salesBreakDowns) {
      if (sales.totalSales.toDouble > _maxSale) {
        _maxSale = sales.totalSales.toDouble;
      } else if (sales.totalSales.toDouble < _minSale) {
        _minSale = sales.totalSales.toDouble;
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
        itemBuilder: (context, index) => Card(
          borderOnForeground: true,
          elevation: 1,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8), side: BorderSide(color: AppColors.tabDatePickerColor)),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 5),
                Expanded(
                    child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    _salesBreakDowns[index].totalSales.withoutNullDecimals.commaSeparated,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        color: _getSalesBreakDownItemColor(_salesBreakDowns[index]),
                        fontSize: 24,
                        fontWeight: FontWeight.w600),
                  ),
                )),
                SizedBox(height: 4),
                Expanded(
                  child: Text(
                    _salesBreakDowns[index].type,
                    style: TextStyle(
                      color: AppColors.textColorGray,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getSalesBreakDownItemColor(SalesBreakDownItem salesBreakDownItem) {
    if (salesBreakDownItem.totalSales.toDouble == _maxSale) return AppColors.green;
    if (salesBreakDownItem.totalSales.toDouble == _minSale) return AppColors.red;
    return AppColors.yellow;
  }
}
