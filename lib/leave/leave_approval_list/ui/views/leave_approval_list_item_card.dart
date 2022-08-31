import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../../_common_widgets/buttons/capsule_action_button.dart';
import '../../../leave_approval/ui/views/leave_approval_alert.dart';
import '../../../leave_approval/ui/views/leave_rejection_alert.dart';
import '../../entities/leave_approval_list_item.dart';
import '../presenters/leave_approval_list_presenter.dart';

class LeaveApprovalListItemCard extends StatefulWidget {
  final LeaveApprovalListPresenter listPresenter;
  final LeaveApprovalListItem approval;

  LeaveApprovalListItemCard({
    required this.listPresenter,
    required this.approval,
  });

  @override
  State<LeaveApprovalListItemCard> createState() => _LeaveApprovalListItemCardState();
}

class _LeaveApprovalListItemCardState extends State<LeaveApprovalListItemCard> {
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
                    widget.listPresenter.getTotalDays(widget.approval),
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
                        "Start - ",
                        widget.listPresenter.getLeaveStartDate(widget.approval),
                      ),
                    ),
                    _labelAndValue(
                      "End - ",
                      widget.listPresenter.getLeaveEndDate(widget.approval),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _labelAndValue(
                      "Leave Type - ",
                      widget.listPresenter.getLeaveType(widget.approval),
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
    var didApprove = await LeaveApprovalAlert.show(
      context: context,
      leaveId: widget.approval.id,
      companyId: widget.approval.companyId,
      requestedBy: widget.approval.applicantName,
    );
    widget.listPresenter.onDidProcessApprovalOrRejection(didApprove, widget.approval.id);
  }

  void _reject() async {
    var didReject = await LeaveRejectionAlert.show(
      context: context,
      leaveId: widget.approval.id,
      companyId: widget.approval.companyId,
      requestedBy: widget.approval.applicantName,
    );
    widget.listPresenter.onDidProcessApprovalOrRejection(didReject, widget.approval.id);
  }
}
