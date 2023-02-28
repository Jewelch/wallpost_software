import 'dart:core';

import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/form_widgets/form_text_field.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/ui/presenters/attendance_adjustment_approval_presenter.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/ui/view_contracts/attendance_adjustment_approval_view.dart';
import '../../../../_common_widgets/buttons/rounded_action_button.dart';

class AttendanceAdjustmentRejectionAllAlert extends StatefulWidget {
  final int noOfSelectedItems;
  final List<String> attendanceAdjustmentIds;
  final String companyId;

  AttendanceAdjustmentRejectionAllAlert({
    required this.noOfSelectedItems,
    required this.attendanceAdjustmentIds,
    required this.companyId,
  });

  @override
  State<AttendanceAdjustmentRejectionAllAlert> createState() => _AttendanceAdjustmentRejectionAllAlertState();
}

class _AttendanceAdjustmentRejectionAllAlertState extends State<AttendanceAdjustmentRejectionAllAlert>
    implements AttendanceAdjustmentApprovalView {
  late AttendanceAdjustmentApprovalPresenter _presenter;
  final _reasonTextController = TextEditingController();
  var _reasonErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  var _showLoaderNotifier = ItemNotifier<bool>(defaultValue: false);

  @override
  void initState() {
    _presenter = AttendanceAdjustmentApprovalPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      titlePadding: EdgeInsets.symmetric(horizontal: 4),
      contentPadding: EdgeInsets.all(14),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel",
                style: TextStyles.headerCardSubHeadingTextStyle
                    .copyWith(color: AppColors.red, fontWeight: FontWeight.w500)),
          ),
          SizedBox(width: 22),
          Text(
            "Reject All (${widget.noOfSelectedItems})",
            style: TextStyles.headerCardSubHeadingTextStyle
                .copyWith(color: AppColors.textColorBlack, fontWeight: FontWeight.w500),
          )
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Are you sure you want to reject all ${widget.noOfSelectedItems} selected requests ?",
              style: TextStyles.headerCardSubHeadingTextStyle.copyWith(color: AppColors.textColorBlack),
              textAlign: TextAlign.left),
          SizedBox(height: 16),
          ItemNotifiable<String?>(
            notifier: _reasonErrorNotifier,
            builder: (context, value) => FormTextField(
              hint: 'Write your reason here',
              controller: _reasonTextController,
              autoFocus: true,
              errorText: value,
              minLines: 3,
              maxLines: 8,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              isEnabled: _presenter.isRejectionInProgress() ? false : true,
            ),
          ),
          SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: ItemNotifiable<bool>(
                notifier: _showLoaderNotifier,
                builder: (context, showLoader) => RoundedRectangleActionButton(
                  title: "Yes Reject All",
                  icon: Icon(Icons.close, size: 22, color: Colors.white),
                  backgroundColor: AppColors.red,
                  showLoader: showLoader,
                  onPressed: () {
                    _presenter.massReject(widget.companyId, widget.attendanceAdjustmentIds, _reasonTextController.text);
                  },
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _showLoaderNotifier.notify(true);
  }

  @override
  void notifyInvalidRejectionReason(String message) {
    _reasonErrorNotifier.notify(message);
  }

  @override
  void onDidPerformActionSuccessfully(String attendanceAdjustmentId) {
    Navigator.pop(context, true);
  }

  @override
  void onDidFailToPerformAction(String title, String message) {
    Alert.showSimpleAlert(
      context: context,
      title: title,
      message: message,
      onPressed: () => Navigator.pop(context),
    );
  }
}
