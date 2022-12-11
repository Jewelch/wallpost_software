import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/restaurant/sales_reports/item_sales/ui/presenter/item_sales_presenter.dart';

class ItemSalesCard extends StatelessWidget {
  final ItemSalesPresenter _presenter;

  ItemSalesCard(this._presenter);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        borderOnForeground: true,
        elevation: 0,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Spacer(flex: 2),
                  Text(
                    "Qty.",
                    style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                  ),
                  Spacer(),
                  Text(
                    "Revenue",
                    style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                  )
                ],
              ),
            ),
            ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: 3,
              // _presenter.getCategoryWiseListLength(),
              itemBuilder: (context, index) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 4,
                          child: Text(
                            "Bergur",
                            //_presenter.getCategoryNameAtIndex(index),
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: AppColors.textColorBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        Expanded(
                          child: Text(
                            '8',
                            // _presenter.getCategoryQtyAtIndex(index).toString(),
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: AppColors.textColorBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                            width: 120,
                            child: Row(
                              children: [
                                SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    "100",
                                    // _presenter.getCategoryRevenueAtIndex(index).toString(),
                                    textAlign: TextAlign.right,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyles.largeTitleTextStyleBold,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Column(
                                  children: [
                                    Text(
                                      'DRR',
                                      // _presenter.getCompanyCurrency(),
                                      style: TextStyle(
                                        color: AppColors.textColorBlueGray,
                                        fontSize: 8, // 11 is not logic
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    SizedBox(height: 3),
                                  ],
                                ),
                              ],
                            )),
                      ],
                    ),
                  ),
                  // _presenter.getNumberOfBreakdowns()
                  index < 3 - 1 ? Divider(height: 1) : SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
