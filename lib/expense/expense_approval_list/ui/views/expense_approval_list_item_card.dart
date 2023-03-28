import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/expense/expense_approval/ui/views/expense_approval_confirmation_alert.dart';
import 'package:wallpost/expense/expense_approval/ui/views/expense_rejection_confirmation_alert.dart';
import 'package:wallpost/expense/expense_approval_list/entities/expense_approval_list_item.dart';
import '../../../../_common_widgets/buttons/rounded_action_button.dart';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: AppColors.listItemBorderColor),
      ),
      child: InkWell(
        onTap: () => widget.listPresenter.showDetail(widget.approval),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AnimatedCrossFade(
                alignment: Alignment.topRight,
                sizeCurve: Curves.easeIn,
                duration: const Duration(milliseconds: 200),
                firstChild: Container(
                  color: Colors.white,
                  child: Checkbox(
                    value: widget.listPresenter.isItemSelected(widget.approval),
                    onChanged: (_) {
                      widget.listPresenter.toggleSelection(widget.approval);
                      setState(() {});
                    },
                  ),
                ),
                secondChild: Container(),
                crossFadeState:
                    widget.listPresenter.isSelectionInProgress ? CrossFadeState.showFirst : CrossFadeState.showSecond,
              ),
              Expanded(
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
                        SizedBox(width: 16),
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
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: _labelAndValue(
                                "Request No - ",
                                widget.listPresenter.getRequestNumber(widget.approval),
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
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
                    if (!widget.listPresenter.isSelectionInProgress) SizedBox(height: 20),
                    if (!widget.listPresenter.isSelectionInProgress)
                      ItemNotifiable<bool>(
                        notifier: _loadingNotifier,
                        builder: (context, isLoading) {
                          return Row(
                            children: [
                              Expanded(
                                child: RoundedRectangleActionButton(
                                  title: "Approve",
                                  backgroundColor: AppColors.green,
                                  height: 44,
                                  borderRadiusCircular: 16,
                                  onPressed: () => _approve(),
                                  showLoader: isLoading,
                                ),
                              ),
                              SizedBox(width: 16),
                              Expanded(
                                child: RoundedRectangleActionButton(
                                  title: "Reject",
                                  backgroundColor: AppColors.red,
                                  height: 44,
                                  borderRadiusCircular: 16,
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
          style: TextStyles.labelTextStyle.copyWith(
            color: AppColors.textColorBlack,
            overflow: TextOverflow.ellipsis,
          ),
          overflow: TextOverflow.ellipsis,
          maxLines: 1,
        ),
      ],
    );
  }

  void _approve() async {

    var didApprove = await showDialog(
      context: context,
      builder: (_) => ExpenseApprovalConfirmationAlert(
        expenseId: widget.approval.id,
        companyId: widget.approval.companyId,
        requestedBy: widget.approval.requestedBy,
      ),
    );
    if (didApprove)
      widget.listPresenter.onDidProcessApprovalOrRejection(
        didApprove,
        [widget.approval.id],
      );
  }

  void _reject() async {
    var didReject = await showDialog(
      context: context,
      builder: (_) => ExpenseRejectionConfirmationAlert(
        expenseId: widget.approval.id,
        companyId: widget.approval.companyId,
        requestedBy: widget.approval.requestedBy,
      ),
    );
    if (didReject)
      widget.listPresenter.onDidProcessApprovalOrRejection(
        didReject,
        [widget.approval.id],
      );
  }
}
