import 'dart:core';

import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/form_widgets/form_text_field.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/ui/presenters/purchase_bill_approval_presenter.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/ui/view_contracts/purchase_bill_approval_view.dart';
import '../../../../_common_widgets/buttons/rounded_action_button.dart';

class PurchaseBillRejectionAllAlert extends StatefulWidget {
  final int noOfSelectedItems;
  final List<String> billIds;
  final String companyId;

  PurchaseBillRejectionAllAlert({
    required this.noOfSelectedItems,
    required this.billIds,
    required this.companyId,
  });

  @override
  State<PurchaseBillRejectionAllAlert> createState() => _PurchaseBillRejectionAllAlertState();
}

class _PurchaseBillRejectionAllAlertState extends State<PurchaseBillRejectionAllAlert>
    implements PurchaseBillApprovalView {
  late PurchaseBillApprovalPresenter _presenter;
  final _reasonTextController = TextEditingController();
  var _reasonErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  var _showLoaderNotifier = ItemNotifier<bool>(defaultValue: false);

  @override
  void initState() {
    _presenter = PurchaseBillApprovalPresenter(this);
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
                  isIconLeftAligned: false,
                  height: 44,
                  borderRadiusCircular: 16,
                  showLoader: showLoader,
                  onPressed: () {
                    _presenter.massReject(widget.companyId, widget.billIds, _reasonTextController.text);
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
  void onDidPerformActionSuccessfully(String billId) {
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
