import 'dart:core';

import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/form_widgets/form_text_field.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/ui/presenters/attendance_adjustment_approval_presenter.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/ui/view_contracts/attendance_adjustment_approval_view.dart';

class AttendanceAdjustmentRejectionAlert extends StatefulWidget {
  final String attendanceAdjustmentId;
  final String companyId;
  final String employeeName;

  AttendanceAdjustmentRejectionAlert({
    required this.attendanceAdjustmentId,
    required this.companyId,
    required this.employeeName,
  });

  @override
  State<AttendanceAdjustmentRejectionAlert> createState() => _AttendanceAdjustmentRejectionAlertState();
}

class _AttendanceAdjustmentRejectionAlertState extends State<AttendanceAdjustmentRejectionAlert>
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
          Text("Reject",
              style: TextStyles.headerCardSubHeadingTextStyle
                  .copyWith(color: AppColors.textColorBlack, fontWeight: FontWeight.w500)),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Do you want to reject ${widget.employeeName}'s attendance adjustment request?",
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
                builder: (context, showLoader) => ActionButton(
                  title: "Yes Reject",
                  icon: Icon(Icons.close, size: 22, color: Colors.white),
                  color: AppColors.red,
                  showLoader: showLoader,
                  onPressed: () {
                    _presenter.reject(widget.companyId, widget.attendanceAdjustmentId, _reasonTextController.text);
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
