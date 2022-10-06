import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

import '../../../../_common_widgets/buttons/capsule_action_button.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../presenters/attendance_adjustment_approval_presenter.dart';
import '../view_contracts/attendance_adjustment_approval_view.dart';

class AttendanceAdjustmentApprovalAlert extends StatefulWidget {
  final String attendanceAdjustmentId;
  final String companyId;
  final String employeeName;
  final ModalSheetController modalSheetController;

  AttendanceAdjustmentApprovalAlert._({
    required this.attendanceAdjustmentId,
    required this.companyId,
    required this.employeeName,
    required this.modalSheetController,
  });

  static Future<dynamic> show({
    required BuildContext context,
    required String attendanceAdjustmentId,
    required String companyId,
    required String employeeName,
  }) {
    var modalSheetController = ModalSheetController();
    return ModalSheetPresenter.present(
      context: context,
      content: AttendanceAdjustmentApprovalAlert._(
        companyId: companyId,
        attendanceAdjustmentId: attendanceAdjustmentId,
        employeeName: employeeName,
        modalSheetController: modalSheetController,
      ),
      controller: modalSheetController,
      shouldDismissOnTap: false,
    );
  }

  @override
  State<AttendanceAdjustmentApprovalAlert> createState() => _AttendanceAdjustmentApprovalAlertState();
}

class _AttendanceAdjustmentApprovalAlertState extends State<AttendanceAdjustmentApprovalAlert>
    implements AttendanceAdjustmentApprovalView {
  late AttendanceAdjustmentApprovalPresenter _presenter;

  @override
  void initState() {
    _presenter = AttendanceAdjustmentApprovalPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12, bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Are you sure?", style: TextStyles.extraLargeTitleTextStyleBold),
          SizedBox(height: 16),
          Text("You want to approve ${widget.employeeName}'s attendance adjustment request?",
              style: TextStyles.titleTextStyleBold),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: CapsuleActionButton(
                  title: _presenter.getApproveButtonTitle(),
                  color: AppColors.green,
                  onPressed: () => _presenter.approve(widget.companyId, widget.attendanceAdjustmentId),
                  showLoader: _presenter.isApprovalInProgress(),
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: CapsuleActionButton(
                  title: "Close",
                  color: AppColors.red,
                  onPressed: () => widget.modalSheetController.close(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //MARK: View functions
  @override
  void showLoader() {
    setState(() {});
  }

  @override
  void notifyInvalidRejectionReason() {
    //do nothing
  }

  @override
  void onDidFailToPerformAction(String title, String message) {
    setState(() {});
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void onDidPerformActionSuccessfully(String attendanceAdjustmentId) {
    setState(() {});
    Future.delayed(Duration(seconds: 2)).then((_) {
      widget.modalSheetController.close(result: true);
    });
  }
}
