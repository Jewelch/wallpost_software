import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/expense/expense_approval/ui/view_contracts/expense_approval_view.dart';

import '../../../../_common_widgets/buttons/capsule_action_button.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../presenters/expense_approval_presenter.dart';

class ExpenseApprovalAlert extends StatefulWidget {
  final String expenseId;
  final String companyId;
  final String requestedBy;
  final ModalSheetController modalSheetController;

  ExpenseApprovalAlert._({
    required this.expenseId,
    required this.companyId,
    required this.requestedBy,
    required this.modalSheetController,
  });

  static Future<dynamic> show({
    required BuildContext context,
    required String expenseId,
    required String companyId,
    required String requestedBy,
  }) {
    var modalSheetController = ModalSheetController();
    return ModalSheetPresenter.present(
      context: context,
      content: ExpenseApprovalAlert._(
        companyId: companyId,
        expenseId: expenseId,
        requestedBy: requestedBy,
        modalSheetController: modalSheetController,
      ),
      controller: modalSheetController,
      shouldDismissOnTap: false,
    );
  }

  @override
  State<ExpenseApprovalAlert> createState() => _ExpenseApprovalAlertState();
}

class _ExpenseApprovalAlertState extends State<ExpenseApprovalAlert> implements ExpenseApprovalView {
  late ExpenseApprovalPresenter _presenter;

  @override
  void initState() {
    _presenter = ExpenseApprovalPresenter(this);
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
          Text("You want to approve ${widget.requestedBy}'s expense request?", style: TextStyles.titleTextStyleBold),
          SizedBox(height: 30),
          Row(
            children: [
              Expanded(
                child: CapsuleActionButton(
                  title: _presenter.getApproveButtonTitle(),
                  color: AppColors.green,
                  onPressed: () => _presenter.approve(widget.companyId, widget.expenseId),
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
  void onDidPerformActionSuccessfully(String expenseId) {
    setState(() {});
    Future.delayed(Duration(seconds: 2)).then((_) {
      widget.modalSheetController.close(result: true);
    });
  }
}
