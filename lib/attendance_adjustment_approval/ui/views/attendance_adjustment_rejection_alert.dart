import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

import '../../../_common_widgets/buttons/capsule_action_button.dart';
import '../../../_common_widgets/form_widgets/form_text_field.dart';
import '../../../_shared/constants/app_colors.dart';
import '../../../attendance_adjustment_approval_list/ui/view_contracts/attendance_adjustment_approval_view.dart';
import '../presenters/attendance_adjustment_approval_presenter.dart';

class AttendanceAdjustmentRejectionAlert extends StatefulWidget {
  final String attendanceAdjustmentId;
  final String companyId;
  final String employeeName;
  final ModalSheetController modalSheetController;

  AttendanceAdjustmentRejectionAlert._({
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
      content: AttendanceAdjustmentRejectionAlert._(
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
  State<AttendanceAdjustmentRejectionAlert> createState() => _AttendanceAdjustmentRejectionAlertState();
}

class _AttendanceAdjustmentRejectionAlertState extends State<AttendanceAdjustmentRejectionAlert>
    implements AttendanceAdjustmentApprovalView {
  late AttendanceAdjustmentApprovalPresenter _presenter;
  final _reasonTextController = TextEditingController();

  @override
  void initState() {
    _presenter = AttendanceAdjustmentApprovalPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Are you sure?", style: TextStyles.extraLargeTitleTextStyleBold),
          SizedBox(height: 16),
          Text("You want to reject ${widget.employeeName}'s attendance adjustment request?",
              style: TextStyles.titleTextStyleBold),
          SizedBox(height: 16),
          FormTextField(
            hint: 'Write your reason here',
            controller: _reasonTextController,
            autoFocus: true,
            errorText: _presenter.getRejectionReasonError(),
            minLines: 3,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            isEnabled: _presenter.isRejectionInProgress() ? false : true,
          ),
          SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: CapsuleActionButton(
                  title: _presenter.getRejectButtonTitle(),
                  color: AppColors.green,
                  onPressed: () => _presenter.reject(
                    widget.companyId,
                    widget.attendanceAdjustmentId,
                    _reasonTextController.text,
                  ),
                  showLoader: _presenter.isRejectionInProgress(),
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
