import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/leave/leave_approval/ui/view_contracts/leave_approval_view.dart';

import '../../../../_common_widgets/buttons/capsule_action_button.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../presenters/leave_approval_presenter.dart';

class LeaveApprovalAlert extends StatefulWidget {
  final String leaveId;
  final String companyId;
  final String requestedBy;
  final ModalSheetController modalSheetController;

  LeaveApprovalAlert._({
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
      content: LeaveApprovalAlert._(
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
  State<LeaveApprovalAlert> createState() => _LeaveApprovalAlertState();
}

class _LeaveApprovalAlertState extends State<LeaveApprovalAlert> implements LeaveApprovalView {
  late LeaveApprovalPresenter _presenter;

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
      child: Padding(
        padding: EdgeInsets.only(left: 12, right: 12, bottom: 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Are you sure?", style: TextStyles.extraLargeTitleTextStyleBold),
            SizedBox(height: 16),
            Text("You want to approve ${widget.requestedBy}'s leave request?", style: TextStyles.titleTextStyleBold),
            SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                  child: CapsuleActionButton(
                    title: _presenter.getApproveButtonTitle(),
                    color: AppColors.green,
                    onPressed: () => _presenter.approve(widget.companyId, widget.leaveId),
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
    //do nothing
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
      widget.modalSheetController.close(result: true);
    });
  }
}
