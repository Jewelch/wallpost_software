import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/file/file_download_screen.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/expense/expense_approval/ui/views/expense_rejection_alert.dart';

import '../../../../_common_widgets/buttons/capsule_action_button.dart';
import '../../../expense_approval/ui/views/expense_approval_alert.dart';
import '../presenters/expense_detail_presenter.dart';
import '../view_contracts/expense_detail_view.dart';
import 'expense_detail_loader.dart';

class ExpenseDetailScreen extends StatefulWidget {
  final String companyId;
  final String expenseId;
  final bool isSourceScreenTheApprovalListScreen;

  ExpenseDetailScreen({
    required this.companyId,
    required this.expenseId,
    this.isSourceScreenTheApprovalListScreen = false,
  });

  @override
  _ExpenseDetailScreenState createState() => _ExpenseDetailScreenState();
}

class _ExpenseDetailScreenState extends State<ExpenseDetailScreen> implements ExpenseDetailView {
  late ExpenseDetailPresenter _presenter;
  final int viewTypeLoader = 1;
  final int viewTypeError = 2;
  final int viewTypeExpenseDetails = 3;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier(defaultValue: 1);

  @override
  void initState() {
    _presenter = ExpenseDetailPresenter(
      widget.companyId,
      widget.expenseId,
      this,
      didComeToDetailScreenFromApprovalList: widget.isSourceScreenTheApprovalListScreen,
    );
    _presenter.loadDetail();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.screenBackgroundColor,
      appBar: SimpleAppBar(
        title: "Expense Details",
        leadingButton: RoundedBackButton(
            onPressed: () => Navigator.pop(
              context,
                  _presenter.didProcessApprovalOrRejection,
                )),
      ),
      body: SafeArea(
        child: ItemNotifiable(
          notifier: _viewTypeNotifier,
          builder: (context, viewType) {
            if (viewType == viewTypeLoader) {
              return ExpenseDetailLoader();
            } else if (viewType == viewTypeError) {
              return _buildErrorView();
            } else {
              return _buildExpenseDetailsView();
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

  Widget _buildExpenseDetailsView() {
    return RefreshIndicator(
      onRefresh: () => _presenter.loadDetail(),
      child: ListView(
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          SizedBox(height: 20),
          _title(_presenter.getTitle()),
          SizedBox(height: 20),
          _labelAndValue("Request No", _presenter.getRequestNumber()),
          _labelAndValue("Date", _presenter.getRequestDate()),
          _labelAndValue("Requested by", _presenter.getRequestedBy()),
          _labelAndValue("Main category", _presenter.getMainCategory()),
          _labelAndValue("Project", _presenter.getProject()),
          _labelAndValue("Sub category", _presenter.getSubCategory()),
          _labelAndValue("Rate", _presenter.getRate()),
          _labelAndValue("Quantity", _presenter.getQuantity()),
          _labelAndValue("Amount", _presenter.getTotalAmount()),
          _labelAndValue(
            "Status",
            _presenter.getStatus(),
            valueStyle: TextStyles.titleTextStyle.copyWith(color: _presenter.getStatusColor()),
          ),
          _labelAndValue("Rejection Reason", _presenter.getRejectionReason()),
          GestureDetector(
            onTap: () {
              if (_presenter.getAttachmentUrl() != null)
                FileDownloadScreen.show(
                  context: context,
                  url: _presenter.getAttachmentUrl()!,
                );
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
    if (value == null || value.isEmpty) return Container();

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
    _viewTypeNotifier.notify(viewTypeExpenseDetails);
  }

  @override
  void processApproval(String companyId, String expenseId, String requestedBy) {
    _approve(companyId, expenseId, requestedBy);
  }

  @override
  void processRejection(String companyId, String expenseId, String requestedBy) {
    _showRejectionSheet(companyId, expenseId, requestedBy, context);
  }

  //MARK: Functions to approve and reject

  void _approve(String companyId, String expenseId, String requestedBy) async {
    var didApprove = await ExpenseApprovalAlert.show(
      context: context,
      expenseId: expenseId,
      companyId: companyId,
      requestedBy: requestedBy,
    );
    _presenter.onDidProcessApprovalOrRejection(didApprove);
  }

  void _showRejectionSheet(String companyId, String expenseId, String requestedBy, BuildContext context) async {
    var didReject = await ExpenseRejectionAlert.show(
      context: context,
      expenseId: expenseId,
      companyId: companyId,
      requestedBy: requestedBy,
    );
    _presenter.onDidProcessApprovalOrRejection(didReject);
  }
}
