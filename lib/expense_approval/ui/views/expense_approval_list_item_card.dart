import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../_common_widgets/buttons/capsule_action_button.dart';
import '../../../_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import '../../entities/expense_approval.dart';
import '../presenters/expense_approval_list_presenter.dart';
import '../presenters/expense_approval_presenter.dart';
import 'expense_approval_rejection_view.dart';

class ExpenseApprovalListItemCard extends StatelessWidget {
  final ExpenseApprovalListPresenter listPresenter;
  final ExpenseApprovalPresenter approvalPresenter;
  final ExpenseApproval approval;
  final _loadingNotifier = ItemNotifier<bool>(defaultValue: false);

  ExpenseApprovalListItemCard({
    required this.listPresenter,
    required this.approvalPresenter,
    required this.approval,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: AppColors.listItemBorderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  listPresenter.getTitle(approval),
                  style: TextStyles.titleTextStyleBold,
                ),
              ),
              Text(
                listPresenter.getTotalAmount(approval),
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
                    listPresenter.getRequestNumber(approval),
                  ),
                ),
                _labelAndValue(
                  "Date - ",
                  listPresenter.getRequestDate(approval),
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
                  listPresenter.getRequestedBy(approval),
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
                      onPressed: () => _showRejectionSheet(context),
                      disabled: isLoading ? true : false,
                    ),
                  ),
                ],
              );
            },
          ),
        ],
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
    _loadingNotifier.notify(true);
    await approvalPresenter.approve(approval);
    _loadingNotifier.notify(false);
  }

  void _showRejectionSheet(BuildContext context) async {
    var modalSheetController = ModalSheetController();
    ModalSheetPresenter.present(
      context: context,
      content: ExpenseApprovalRejectionView(
        approval: approval,
        approvalPresenter: approvalPresenter,
        modalSheetController: modalSheetController,
      ),
      controller: modalSheetController,
      shouldDismissOnTap: false,
    );
  }
}
