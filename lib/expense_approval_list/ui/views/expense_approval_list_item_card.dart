import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/expense_approval/ui/views/expense_approval_alert.dart';
import 'package:wallpost/expense_approval_list/entities/expense_approval_list_item.dart';

import '../../../_common_widgets/buttons/capsule_action_button.dart';
import '../../../expense_approval/ui/views/expense_rejection_alert.dart';
import '../presenters/expense_approval_list_presenter.dart';

class ExpenseApprovalListItemCard extends StatefulWidget {
  final ExpenseApprovalListPresenter listPresenter;
  final ExpenseApprovalListItem approval;

  ExpenseApprovalListItemCard({
    required this.listPresenter,
    required this.approval,
  });

  @override
  State<ExpenseApprovalListItemCard> createState() => _ExpenseApprovalListItemCardState();
}

class _ExpenseApprovalListItemCardState extends State<ExpenseApprovalListItemCard> {
  final _loadingNotifier = ItemNotifier<bool>(defaultValue: false);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: AppColors.listItemBorderColor),
      ),
      child: InkWell(
        onTap: () => widget.listPresenter.selectItem(widget.approval),
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
                      widget.listPresenter.getTitle(widget.approval),
                      style: TextStyles.titleTextStyleBold,
                    ),
                  ),
                  Text(
                    widget.listPresenter.getTotalAmount(widget.approval),
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
                        widget.listPresenter.getRequestNumber(widget.approval),
                      ),
                    ),
                    _labelAndValue(
                      "Date - ",
                      widget.listPresenter.getRequestDate(widget.approval),
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
                      widget.listPresenter.getRequestedBy(widget.approval),
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios_sharp,
                    color: AppColors.textColorBlack,
                    size: 16,
                  ),
                ],
              ),
              SizedBox(height: 20),
              ItemNotifiable<bool>(
                notifier: _loadingNotifier,
                builder: (context, isLoading) {
                  return Row(
                    children: [
                      Expanded(
                        child: CapsuleActionButton(
                          title: "Approve",
                          color: AppColors.green,
                          onPressed: () => _approve(),
                          showLoader: isLoading,
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: CapsuleActionButton(
                          title: "Reject",
                          color: AppColors.red,
                          onPressed: () => _reject(),
                          disabled: isLoading ? true : false,
                        ),
                      ),
                    ],
                  );
                },
              ),
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

  void _approve() async {
    var didApprove = await ExpenseApprovalAlert.show(
      context: context,
      expenseId: widget.approval.id,
      companyId: widget.approval.companyId,
      requestedBy: widget.approval.requestedBy,
    );
    widget.listPresenter.onDidProcessApprovalOrRejection(didApprove, widget.approval.id);
  }

  void _reject() async {
    var didReject = await ExpenseRejectionAlert.show(
      context: context,
      expenseId: widget.approval.id,
      companyId: widget.approval.companyId,
      requestedBy: widget.approval.requestedBy,
    );
    widget.listPresenter.onDidProcessApprovalOrRejection(didReject, widget.approval.id);
  }
}
