import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/file/file_download_screen.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/leave/leave_approval/ui/views/leave_rejection_alert.dart';

import '../../../../_common_widgets/buttons/capsule_action_button.dart';
import '../../../leave_approval/ui/views/leave_approval_alert.dart';
import '../presenters/leave_detail_presenter.dart';
import '../view_contracts/leave_detail_view.dart';
import 'leave_detail_loader.dart';

class LeaveDetailScreen extends StatefulWidget {
  final String companyId;
  final String leaveId;
  final bool isLaunchingDetailScreenForApproval;

  LeaveDetailScreen({
    required this.companyId,
    required this.leaveId,
    this.isLaunchingDetailScreenForApproval = false,
  });

  @override
  _LeaveDetailScreenState createState() => _LeaveDetailScreenState();
}

class _LeaveDetailScreenState extends State<LeaveDetailScreen> implements LeaveDetailView {
  late LeaveDetailPresenter _presenter;
  final int viewTypeLoader = 1;
  final int viewTypeError = 2;
  final int viewTypeLeaveDetails = 3;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier(defaultValue: 1);

  @override
  void initState() {
    _presenter = LeaveDetailPresenter(
      widget.companyId,
      widget.leaveId,
      didLaunchDetailScreenForApproval: widget.isLaunchingDetailScreenForApproval,
      view: this,
    );
    _presenter.loadDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: SimpleAppBar(
        title: "Leave Details",
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: ItemNotifiable(
          notifier: _viewTypeNotifier,
          builder: (context, viewType) {
            if (viewType == viewTypeLoader) {
              return LeaveDetailLoader();
            } else if (viewType == viewTypeError) {
              return _buildErrorView();
            } else {
              return _buildLeaveDetailsView();
            }
          },
        ),
      ),
    );
  }

  Widget _buildErrorView() {
    return Container(
      margin: EdgeInsets.only(left: 24, right: 24),
      child: Center(
        child: GestureDetector(
          onTap: () => _presenter.loadDetail(),
          child: Container(
            child: Text(_presenter.errorMessage ?? "", textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveDetailsView() {
    return RefreshIndicator(
      onRefresh: () => _presenter.loadDetail(),
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 20),
          _title(_presenter.getTitle()),
          SizedBox(height: 20),
          _labelAndValue("Leave Type", _presenter.getLeaveType()),
          _labelAndValue("Start", _presenter.getLeaveStartDate()),
          _labelAndValue("End", _presenter.getLeaveEndDate()),
          _labelAndValue("Duration", _presenter.getTotalDays()),
          _labelAndValue("Paid", _presenter.getTotalPaidDays()),
          _labelAndValue("Unpaid", _presenter.getTotalUnpaidDays()),
          _labelAndValue("Reason", _presenter.getLeaveReason()),
          _labelAndValue(
            "Status",
            _presenter.getStatus(),
            valueStyle: TextStyles.titleTextStyle.copyWith(color: _presenter.getStatusColor()),
          ),
          GestureDetector(
            onTap: () {
              if (_presenter.getAttachmentUrl() != null)
                FileDownloadScreen.show(context: context, url: _presenter.getAttachmentUrl()!);
            },
            child: _labelAndValue(
              "Attachment",
              _presenter.getAttachmentUrl(),
              valueStyle: TextStyles.titleTextStyle.copyWith(
                color: AppColors.defaultColor,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          SizedBox(height: 20),
          if (_presenter.shouldShowApprovalActions())
            Row(
              children: [
                SizedBox(width: 12),
                Expanded(
                  child: CapsuleActionButton(
                    title: "Approve",
                    color: AppColors.green,
                    onPressed: () => _presenter.initiateApproval(),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: CapsuleActionButton(
                    title: "Reject",
                    color: AppColors.red,
                    onPressed: () => _presenter.initiateRejection(),
                  ),
                ),
                SizedBox(width: 12),
              ],
            ),
        ],
      ),
    );
  }

  Widget _title(String title) {
    if (title.isEmpty) return Container();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Text(
        title,
        style: TextStyles.largeTitleTextStyleBold,
      ),
    );
  }

  Widget _labelAndValue(String label, String? value, {TextStyle? valueStyle}) {
    if (value == null) return Container();

    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12, bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              "$label:",
              style: TextStyles.titleTextStyleBold.copyWith(color: AppColors.textColorGray),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              value,
              style: valueStyle ??
                  TextStyles.titleTextStyle.copyWith(
                    color: AppColors.textColorBlack,
                  ),
            ),
          )
        ],
      ),
    );
  }

  //MARK: Detail view functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(viewTypeLoader);
  }

  @override
  void onDidFailToLoadDetails() {
    _viewTypeNotifier.notify(viewTypeError);
  }

  @override
  void onDidLoadDetails() {
    _viewTypeNotifier.notify(viewTypeLeaveDetails);
  }

  @override
  void processApproval(String companyId, String leaveId, String requestedBy) {
    _approve(companyId, leaveId, requestedBy);
  }

  @override
  void processRejection(String companyId, String leaveId, String requestedBy) {
    _showRejectionSheet(companyId, leaveId, requestedBy, context);
  }

  //MARK: Functions to approve and reject

  void _approve(String companyId, String leaveId, String requestedBy) async {
    var didApprove = await LeaveApprovalAlert.show(
      context: context,
      leaveId: leaveId,
      companyId: companyId,
      requestedBy: requestedBy,
    );
    if (didApprove == true) Navigator.pop(context, true);
  }

  void _showRejectionSheet(String companyId, String leaveId, String requestedBy, BuildContext context) async {
    var didReject = await LeaveRejectionAlert.show(
      context: context,
      leaveId: leaveId,
      companyId: companyId,
      requestedBy: requestedBy,
    );
    if (didReject == true) Navigator.pop(context, true);
  }
}
