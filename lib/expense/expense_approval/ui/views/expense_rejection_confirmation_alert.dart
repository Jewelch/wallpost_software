import 'dart:core';

import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/form_widgets/form_text_field.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/expense/expense_approval/ui/presenters/expense_approval_presenter.dart';
import 'package:wallpost/expense/expense_approval/ui/view_contracts/expense_approval_view.dart';
import 'package:wallpost/expense/expense_approval_list/ui/views/action_button.dart';

class ExpenseRejectionConfirmationAlert extends StatefulWidget {
  final String expenseId;
  final String companyId;
  final String requestedBy;

  ExpenseRejectionConfirmationAlert({required this.expenseId, required this.companyId, required this.requestedBy});

  @override
  State<ExpenseRejectionConfirmationAlert> createState() => _ExpenseRejectionConfirmationAlertState();
}

class _ExpenseRejectionConfirmationAlertState extends State<ExpenseRejectionConfirmationAlert>
    implements ExpenseApprovalView {
  late ExpenseApprovalPresenter _presenter;
  final _reasonTextController = TextEditingController();
  var _reasonErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  var _showLoaderNotifier = ItemNotifier<bool>(defaultValue: false);

  @override
  void initState() {
    _presenter = ExpenseApprovalPresenter(this);
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
            onPressed: () => Navigator.pop(context, true),
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
          Text("Do you want to reject ${widget.requestedBy}'s expense request?",
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
                    _presenter.reject(widget.companyId, widget.expenseId, _reasonTextController.text);
                  },
                ),
              ),
            ),
          ])
        ],
      ),
    );
  }

  @override
  void notifyInvalidRejectionReason(String message) {
    _reasonErrorNotifier.notify(message);
  }

  @override
  void onDidFailToPerformAction(String title, String message) {
    Alert.showSimpleAlert(
        context: context, title: title, message: message, onPressed: () => Navigator.pop(context, 'FAILED'));
  }

  @override
  void onDidPerformActionSuccessfully(String expenseId) {
    Navigator.pop(context, 'REJECTED');
  }

  @override
  void showLoader() {
    _showLoaderNotifier.notify(true);
  }

//TODO: same as approval all confirmation class return values
}
