import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/buttons/capsule_action_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/attendance_adjustment_approval/entities/attendance_adjustment_approval.dart';
import 'package:wallpost/attendance_adjustment_approval/ui/presenters/attendance_adjustment_approval_list_presenter.dart';
import 'package:wallpost/attendance_adjustment_approval/ui/presenters/attendance_adjustment_approval_presenter.dart';
import 'package:wallpost/attendance_adjustment_approval/ui/views/attendance_approval_rejection_view.dart';

import '../../../_common_widgets/text_styles/text_styles.dart';
import '../../../_shared/constants/app_colors.dart';

class AttendanceAdjustmentApprovalListCard extends StatelessWidget {
  final AttendanceAdjustmentApprovalListPresenter listPresenter;
  final AttendanceAdjustmentApprovalPresenter approvalPresenter;
  final AttendanceAdjustmentApproval approval;
  final _loadingNotifier = ItemNotifier<bool>(defaultValue: false);

  AttendanceAdjustmentApprovalListCard({
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
          SizedBox(height: 6),
          Text(listPresenter.getEmployeeName(approval), style: TextStyles.titleTextStyleBold),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Text(
                  "${listPresenter.getDate(approval)} - Original Details",
                  style: TextStyles.subTitleTextStyle,
                ),
              ),
              Text(
                listPresenter.getOriginalStatus(approval),
                style: TextStyles.subTitleTextStyle.copyWith(color: listPresenter.getOriginalStatusColor(approval)),
              )
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _labelAndValue(label: "Punch In", value: listPresenter.getOriginalPunchInTime(approval)),
              _labelAndValue(label: "Punch Out", value: listPresenter.getOriginalPunchOutTime(approval)),
            ],
          ),
          SizedBox(height: 8),
          Divider(),
          SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                  child: Text("${listPresenter.getDate(approval)} - Adjusted Details",
                      style: TextStyles.subTitleTextStyle)),
              Text(listPresenter.getAdjustedStatus(approval),
                  style: TextStyles.subTitleTextStyle.copyWith(
                    color: listPresenter.getAdjustedStatusColor(approval),
                  ))
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _labelAndValue(label: "Punch In", value: listPresenter.getAdjustedPunchInTime(approval)),
              _labelAndValue(label: "Punch Out", value: listPresenter.getAdjustedPunchOutTime(approval)),
            ],
          ),
          SizedBox(height: 8),
          _labelAndValue(label: "Reason", value: listPresenter.getAdjustmentReason(approval)),
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

  Widget _labelAndValue({required String label, required String value}) {
    return Row(
      children: [
        Text("$label - ", style: TextStyles.labelTextStyleBold.copyWith(color: AppColors.textColorGray)),
        Text(value, style: TextStyles.labelTextStyle.copyWith(color: AppColors.textColorBlack)),
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
      content: AttendanceApprovalRejectionView(
        approval: approval,
        approvalPresenter: approvalPresenter,
        modalSheetController: modalSheetController,
      ),
      controller: modalSheetController,
      shouldDismissOnTap: false,
    );
  }
}
