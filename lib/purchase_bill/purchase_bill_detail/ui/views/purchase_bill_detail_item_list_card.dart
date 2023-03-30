import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_item_data.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/ui/presenters/purchase_bill_detail_presenter.dart';

class PurchaseBillDetailItemListCard extends StatelessWidget {
  final PurchaseBillDetailPresenter presenter;
  final PurchaseBillDetailItemData billDetailListItem;

  PurchaseBillDetailItemListCard({
    required this.presenter,
    required this.billDetailListItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  billDetailListItem.itemName,
                  style: TextStyles.titleTextStyle,
                ),
                Text(
                  billDetailListItem.total,
                  style: TextStyles.titleTextStyleBold.copyWith(color: AppColors.defaultColorDark),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text("${billDetailListItem.quantity} x ${billDetailListItem.rate}"),
            SizedBox(height: 8),
            Text(billDetailListItem.description),
          ],
        ),
      ),
    );
  }
}
