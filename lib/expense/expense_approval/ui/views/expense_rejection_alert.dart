import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/expense/expense_approval/ui/view_contracts/expense_approval_view.dart';

import '../../../../_common_widgets/buttons/capsule_action_button.dart';
import '../../../../_common_widgets/form_widgets/form_text_field.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../presenters/expense_approval_presenter.dart';

class ExpenseRejectionAlert extends StatefulWidget {
  final String expenseId;
  final String companyId;
  final String requestedBy;
  final ModalSheetController modalSheetController;

  ExpenseRejectionAlert._({
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
      content: ExpenseRejectionAlert._(
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
  State<ExpenseRejectionAlert> createState() => _ExpenseRejectionAlertState();
}

class _ExpenseRejectionAlertState extends State<ExpenseRejectionAlert> implements ExpenseApprovalView {
  late ExpenseApprovalPresenter _presenter;
  final _reasonTextController = TextEditingController();

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
          Text("You want to reject ${widget.requestedBy}'s expense request?", style: TextStyles.titleTextStyleBold),
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
                    widget.expenseId,
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
  void onDidPerformActionSuccessfully(String expenseId) {
    setState(() {});
    Future.delayed(Duration(seconds: 2)).then((_) {
      widget.modalSheetController.close(result: expenseId);
    });
  }
}
