import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/leave/leave_approval/ui/view_contracts/leave_approval_view.dart';

import '../../../../_common_widgets/buttons/capsule_action_button.dart';
import '../../../../_common_widgets/form_widgets/form_text_field.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../presenters/leave_approval_presenter.dart';

class LeaveRejectionAlert extends StatefulWidget {
  final String leaveId;
  final String companyId;
  final String requestedBy;
  final ModalSheetController modalSheetController;

  LeaveRejectionAlert._({
    required this.leaveId,
    required this.companyId,
    required this.requestedBy,
    required this.modalSheetController,
  });

  static Future<dynamic> show({
    required BuildContext context,
    required String leaveId,
    required String companyId,
    required String requestedBy,
  }) {
    var modalSheetController = ModalSheetController();
    return ModalSheetPresenter.present(
      context: context,
      content: LeaveRejectionAlert._(
        companyId: companyId,
        leaveId: leaveId,
        requestedBy: requestedBy,
        modalSheetController: modalSheetController,
      ),
      controller: modalSheetController,
      shouldDismissOnTap: false,
    );
  }

  @override
  State<LeaveRejectionAlert> createState() => _LeaveRejectionAlertState();
}

class _LeaveRejectionAlertState extends State<LeaveRejectionAlert> implements LeaveApprovalView {
  late LeaveApprovalPresenter _presenter;
  final _reasonTextController = TextEditingController();

  @override
  void initState() {
    _presenter = LeaveApprovalPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        widget.modalSheetController.close();
        return Future.value(false);
      },
      child: Container(
        height: 800,
        padding: EdgeInsets.only(left: 12, right: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you sure?", style: TextStyles.extraLargeTitleTextStyleBold),
            SizedBox(height: 16),
            Text("You want to reject ${widget.requestedBy}'s leave request?", style: TextStyles.titleTextStyleBold),
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
                      widget.leaveId,
                      _reasonTextController.text,
                    ),
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
    setState(() {});
  }

  @override
  void onDidFailToPerformAction(String title, String message) {
    setState(() {});
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void onDidPerformActionSuccessfully(String leaveId) {
    setState(() {});
    Future.delayed(Duration(seconds: 2)).then((_) {
      widget.modalSheetController.close(result: leaveId);
    });
  }
}
