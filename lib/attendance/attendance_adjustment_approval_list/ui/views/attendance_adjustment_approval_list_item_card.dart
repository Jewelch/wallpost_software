import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/entities/attendance_adjustment_approval_list_item.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/ui/presenters/attendance_adjustment_approval_list_presenter.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/ui/views/action_button.dart';

import '../../../../_common_widgets/text_styles/text_styles.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../../../attendance_adjustment_approval/ui/views/attendance_adjustment_approval_alert.dart';
import '../../../attendance_adjustment_approval/ui/views/attendance_adjustment_rejection_alert.dart';

class AttendanceAdjustmentApprovalListCard extends StatefulWidget {
  final AttendanceAdjustmentApprovalListPresenter listPresenter;
  final AttendanceAdjustmentApprovalListItem approval;

  AttendanceAdjustmentApprovalListCard({
    required this.listPresenter,
    required this.approval,
  });

  @override
  State<AttendanceAdjustmentApprovalListCard> createState() => _AttendanceAdjustmentApprovalListCardState();
}

class _AttendanceAdjustmentApprovalListCardState extends State<AttendanceAdjustmentApprovalListCard> {
  final _loadingNotifier = ItemNotifier<bool>(defaultValue: false);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(width: 1, color: AppColors.listItemBorderColor),
      ),
      child: Row(
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
                SizedBox(height: 6),
                Text(widget.listPresenter.getEmployeeName(widget.approval), style: TextStyles.titleTextStyleBold),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        "${widget.listPresenter.getDate(widget.approval)} - Original Details",
                        style: TextStyles.subTitleTextStyle,
                      ),
                    ),
                    Text(
                      widget.listPresenter.getOriginalStatus(widget.approval),
                      style: TextStyles.subTitleTextStyle
                          .copyWith(color: widget.listPresenter.getOriginalStatusColor(widget.approval)),
                    )
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _labelAndValue(
                        label: "Punch In", value: widget.listPresenter.getOriginalPunchInTime(widget.approval)),
                    _labelAndValue(
                        label: "Punch Out", value: widget.listPresenter.getOriginalPunchOutTime(widget.approval)),
                  ],
                ),
                SizedBox(height: 8),
                Divider(),
                SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                        child: Text("${widget.listPresenter.getDate(widget.approval)} - Adjusted Details",
                            style: TextStyles.subTitleTextStyle)),
                    Text(widget.listPresenter.getAdjustedStatus(widget.approval),
                        style: TextStyles.subTitleTextStyle.copyWith(
                          color: widget.listPresenter.getAdjustedStatusColor(widget.approval),
                        ))
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _labelAndValue(
                        label: "Punch In", value: widget.listPresenter.getAdjustedPunchInTime(widget.approval)),
                    _labelAndValue(
                        label: "Punch Out", value: widget.listPresenter.getAdjustedPunchOutTime(widget.approval)),
                  ],
                ),
                SizedBox(height: 8),
                _labelAndValue(label: "Reason", value: widget.listPresenter.getAdjustmentReason(widget.approval)),
                SizedBox(height: 8),
                if (!widget.listPresenter.isSelectionInProgress) SizedBox(height: 20),
                if (!widget.listPresenter.isSelectionInProgress)
                  ItemNotifiable<bool>(
                    notifier: _loadingNotifier,
                    builder: (context, isLoading) {
                      return Row(
                        children: [
                          Expanded(
                            child: ActionButton(
                              title: "Approve",
                              color: AppColors.green,
                              onPressed: () => _approve(),
                              showLoader: isLoading,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: ActionButton(
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
    var didApprove = await showDialog(
      context: context,
      builder: (_) => AttendanceAdjustmentApprovalAlert(
        attendanceAdjustmentId: widget.approval.id,
        companyId: widget.approval.companyId,
        employeeName: widget.approval.employeeName,
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
      builder: (_) => AttendanceAdjustmentRejectionAlert(
        attendanceAdjustmentId: widget.approval.id,
        companyId: widget.approval.companyId,
        employeeName: widget.approval.employeeName,
      ),
    );
    if (didReject)
      widget.listPresenter.onDidProcessApprovalOrRejection(
        didReject,
        [widget.approval.id],
      );
  }
}
