// ignore_for_file: unused_field

import 'package:flutter/material.dart';

import '../../../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../../../_shared/constants/app_colors.dart';
import '../../presenter/item_sales_presenter.dart';

class ItemSalesCategoryViewCard extends StatelessWidget {
  final ItemSalesPresenter presenter;

  const ItemSalesCategoryViewCard(
    this.presenter, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final double itemNameWidth = MediaQuery.of(context).size.width * .32;
    const double quantityWidth = 70;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        borderOnForeground: true,
        elevation: 0,
        child: Column(
          children: [
            SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  SizedBox(width: itemNameWidth),
                  SizedBox(
                    width: quantityWidth,
                    child: Text(
                      "Qty.",
                      style: TextStyles.labelTextStyle.copyWith(fontWeight: FontWeight.w500),
                      textAlign: TextAlign.center,
                    ),
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
              padding: EdgeInsets.only(top: 6),
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: presenter.getDataListLength(),
              itemBuilder: (context, index) => Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: itemNameWidth,
                          child: Text(
                            presenter.getCategoryNameAtIndex(index),
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: AppColors.textColorBlueGray,
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        SizedBox(
                          width: quantityWidth,
                          child: Text(
                            presenter.getCategoryTotalQtyAtIndex(index),
                            style: TextStyle(
                              overflow: TextOverflow.ellipsis,
                              color: AppColors.textColorBlack,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Expanded(
                            child: Row(
                          children: [
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                presenter.getCategoryTotalToDisplayRevenueAtIndex(index),
                                textAlign: TextAlign.right,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyles.largeTitleTextStyleBold,
                              ),
                            ),
                            SizedBox(width: 3),
                            Column(
                              children: [
                                Text(
                                  'QAR',
                                  style: TextStyle(
                                    color: AppColors.textColorBlueGray,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w500,
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
                  index < presenter.getDataListLength() - 1 ? Divider(height: 1) : SizedBox(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
