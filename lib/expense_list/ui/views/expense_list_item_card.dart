import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/expense_list/ui/presenters/expense_list_presenter.dart';

import '../../../expense__core/entities/expense_request.dart';

class ExpenseListItemCard extends StatelessWidget {
  final ExpenseListPresenter presenter;
  final ExpenseRequest expenseRequest;

  ExpenseListItemCard({
    required this.presenter,
    required this.expenseRequest,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: AppColors.listItemBorderColor),
      ),
      child: InkWell(
        onTap: () => presenter.selectItem(expenseRequest),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      presenter.getTitle(expenseRequest),
                      style: TextStyles.titleTextStyleBold,
                    ),
                  ),
                  Text(
                    presenter.getTotalAmount(expenseRequest),
                    style: TextStyles.titleTextStyleBold,
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                child: Row(
                  children: [
                    Expanded(
                      child: _labelAndValue(
                        "Request No - ",
                        presenter.getRequestNumber(expenseRequest),
                      ),
                    ),
                    _labelAndValue(
                      "Date - ",
                      presenter.getRequestDate(expenseRequest),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _labelAndValue(
                      "Requested By - ",
                      presenter.getRequestedBy(expenseRequest),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: AppColors.textColorBlack,
                    size: 16,
                  ),
                ],
              ),
              if (presenter.getStatus(expenseRequest).isNotEmpty) SizedBox(height: 12),
              if (presenter.getStatus(expenseRequest).isNotEmpty)
                Text(
                  presenter.getStatus(expenseRequest),
                  style: TextStyles.subTitleTextStyleBold.copyWith(
                    color: presenter.getStatusColor(expenseRequest),
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelAndValue(String label, String value) {
    return Row(
      children: [
        Text(
          label,
          style: TextStyles.labelTextStyleBold.copyWith(color: AppColors.textColorGray),
          overflow: TextOverflow.ellipsis,
        ),
        Text(
          value,
          style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack),
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
