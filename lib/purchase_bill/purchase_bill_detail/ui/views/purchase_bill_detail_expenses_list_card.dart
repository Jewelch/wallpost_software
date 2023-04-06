import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_expenses.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/ui/presenters/purchase_bill_detail_presenter.dart';

class PurchaseBillDetailExpensesListCard extends StatelessWidget {
  final PurchaseBillDetailPresenter presenter;
  final PurchaseBillDetailExpenses billDetailExpensesItem;

  PurchaseBillDetailExpensesListCard({
    required this.presenter,
    required this.billDetailExpensesItem,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                billDetailExpensesItem.expenseName,
                style: TextStyles.titleTextStyle.copyWith(color: AppColors.textColorBlueGray,fontWeight: FontWeight.w500,fontSize:16.0),
              ),
              Wrap(
                children: [
                  Text(
                    billDetailExpensesItem.amount,
                    style: TextStyles.titleTextStyleBold.copyWith(color: AppColors.textColorBlack,fontWeight: FontWeight.w800,fontSize:17.0),
                  ),
                  SizedBox(width: 2),
                  Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(presenter.getCurrency(),
                        style: TextStyles.smallLabelTextStyle.copyWith(color: AppColors.textColorBlueGray,fontWeight: FontWeight.w500)),
                  )
                ],
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(billDetailExpensesItem.description),
        ],
      ),
    );
  }
}
