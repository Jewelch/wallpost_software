import 'dart:core';

import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/ui/presenters/purchase_bill_approval_presenter.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/ui/view_contracts/purchase_bill_approval_view.dart';
import '../../../../_common_widgets/buttons/rounded_action_button.dart';

class PurchaseBillApprovalAlert extends StatefulWidget {
  final String billId;
  final String companyId;
  final String supplierName;

  PurchaseBillApprovalAlert({
    required this.billId,
    required this.companyId,
    required this.supplierName,
  });

  @override
  State<PurchaseBillApprovalAlert> createState() => _PurchaseBillApprovalAlertState();
}

class _PurchaseBillApprovalAlertState extends State<PurchaseBillApprovalAlert>
    implements PurchaseBillApprovalView {
  late PurchaseBillApprovalPresenter _presenter;
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
                  style: TextStyles.headerCardSubHeadingTextStyle.copyWith(
                    color: AppColors.red,
                    fontWeight: FontWeight.w500,
                  ))),
          SizedBox(width: 22),
          Text("Approve",
              style: TextStyles.headerCardSubHeadingTextStyle.copyWith(
                color: AppColors.textColorBlack,
                fontWeight: FontWeight.w500,
              )),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text("Do you want to approve ${widget.supplierName}'s purchase bill request?",
              style: TextStyles.headerCardSubHeadingTextStyle.copyWith(color: AppColors.textColorBlack),
              textAlign: TextAlign.left),
          SizedBox(height: 18),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Expanded(
              child: ItemNotifiable<bool>(
                notifier: _showLoaderNotifier,
                builder: (context, showLoader) => RoundedRectangleActionButton(
                  title: "Yes Approve",
                  icon: Icon(Icons.check, size: 22, color: Colors.white),
                  backgroundColor: AppColors.green,
                  showLoader: showLoader,
                  isIconLeftAligned: false,
                  height: 44,
                  borderRadiusCircular: 16,
                  onPressed: () {
                    _presenter.approve(widget.companyId, widget.billId);
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
  void notifyInvalidRejectionReason(String message) {}

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
