import 'dart:core';

import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/form_widgets/form_text_field.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/ui/presenters/attendance_adjustment_approval_presenter.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/ui/view_contracts/attendance_adjustment_approval_view.dart';
import 'package:wallpost/expense/expense_approval_list/ui/views/action_button.dart';

class AttendanceAdjustmentRejectionAlert extends StatefulWidget {
  final String expenseId;
  final String companyId;
  final String employeeName;

  //final String requestedBy;

  AttendanceAdjustmentRejectionAlert({
    required this.expenseId,
    required this.companyId,
    required this.employeeName,
   // required this.requestedBy,
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

  //MARK: View functions

  @override
  void showLoader() {
    _showLoaderNotifier.notify(true);
  }

  @override
  void notifyInvalidRejectionReason() {}

  @override
  void onDidPerformActionSuccessfully(String expenseId) {
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

// import 'package:flutter/material.dart';
// import 'package:wallpost/_common_widgets/alert/alert.dart';
// import 'package:wallpost/_common_widgets/screen_presenter/modal_sheet_presenter.dart';
// import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
//
// import '../../../../_common_widgets/buttons/capsule_action_button.dart';
// import '../../../../_common_widgets/form_widgets/form_text_field.dart';
// import '../../../../_shared/constants/app_colors.dart';
// import '../presenters/attendance_adjustment_approval_presenter.dart';
// import '../view_contracts/attendance_adjustment_approval_view.dart';
//
// class AttendanceAdjustmentRejectionAlert extends StatefulWidget {
//   final String attendanceAdjustmentId;
//   final String companyId;
//   final String employeeName;
//   final ModalSheetController modalSheetController;
//
//   AttendanceAdjustmentRejectionAlert._({
//     required this.attendanceAdjustmentId,
//     required this.companyId,
//     required this.employeeName,
//     required this.modalSheetController,
//   });
//
//   static Future<dynamic> show({
//     required BuildContext context,
//     required String attendanceAdjustmentId,
//     required String companyId,
//     required String employeeName,
//   }) {
//     var modalSheetController = ModalSheetController();
//     return ModalSheetPresenter.present(
//       context: context,
//       content: AttendanceAdjustmentRejectionAlert._(
//         companyId: companyId,
//         attendanceAdjustmentId: attendanceAdjustmentId,
//         employeeName: employeeName,
//         modalSheetController: modalSheetController,
//       ),
//       controller: modalSheetController,
//       shouldDismissOnTap: false,
//     );
//   }
//
//   @override
//   State<AttendanceAdjustmentRejectionAlert> createState() => _AttendanceAdjustmentRejectionAlertState();
// }
//
// class _AttendanceAdjustmentRejectionAlertState extends State<AttendanceAdjustmentRejectionAlert>
//     implements AttendanceAdjustmentApprovalView {
//   late AttendanceAdjustmentApprovalPresenter _presenter;
//   final _reasonTextController = TextEditingController();
//
//   @override
//   void initState() {
//     _presenter = AttendanceAdjustmentApprovalPresenter(this);
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 800,
//       padding: EdgeInsets.only(left: 12, right: 12),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text("Are you sure?", style: TextStyles.extraLargeTitleTextStyleBold),
//           SizedBox(height: 16),
//           Text("You want to reject ${widget.employeeName}'s attendance adjustment request?",
//               style: TextStyles.titleTextStyleBold),
//           SizedBox(height: 16),
//           FormTextField(
//             hint: 'Write your reason here',
//             controller: _reasonTextController,
//             autoFocus: true,
//             errorText: _presenter.getRejectionReasonError(),
//             minLines: 3,
//             maxLines: 8,
//             keyboardType: TextInputType.multiline,
//             textInputAction: TextInputAction.done,
//             isEnabled: _presenter.isRejectionInProgress() ? false : true,
//           ),
//           SizedBox(height: 16),
//           Row(
//             children: [
//               Expanded(
//                 child: CapsuleActionButton(
//                   title: _presenter.getRejectButtonTitle(),
//                   color: AppColors.green,
//                   onPressed: () => _presenter.reject(
//                     widget.companyId,
//                     widget.attendanceAdjustmentId,
//                     _reasonTextController.text,
//                   ),
//                   showLoader: _presenter.isRejectionInProgress(),
//                 ),
//               ),
//               SizedBox(width: 16),
//               Expanded(
//                 child: CapsuleActionButton(
//                   title: "Close",
//                   color: AppColors.red,
//                   onPressed: () => widget.modalSheetController.close(),
//                 ),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
//
//   //MARK: View functions
//   @override
//   void showLoader() {
//     setState(() {});
//   }
//
//   @override
//   void notifyInvalidRejectionReason() {
//     //do nothing
//   }
//
//   @override
//   void onDidFailToPerformAction(String title, String message) {
//     setState(() {});
//     Alert.showSimpleAlert(context: context, title: title, message: message);
//   }
//
//   @override
//   void onDidPerformActionSuccessfully(String attendanceAdjustmentId) {
//     setState(() {});
//     Future.delayed(Duration(seconds: 2)).then((_) {
//       widget.modalSheetController.close(result: true);
//     });
//   }
// }
