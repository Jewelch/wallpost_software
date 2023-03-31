import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/ui/views/purchase_bill_approval_alert.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/ui/presenters/purchase_bill_detail_presenter.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/ui/view_contracts/purchase_bill_detail_view.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/ui/views/purchase_bill_detail_app_bar.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/ui/views/purchase_bill_detail_item_list_card.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/ui/views/purchase_bill_detail_loader.dart';

class PurchaseBillDetailScreen extends StatefulWidget {
  final String companyId;
  final String billId;
  final bool isLaunchingDetailScreenForApproval;

  PurchaseBillDetailScreen({
    required this.companyId,
    required this.billId,
    this.isLaunchingDetailScreenForApproval = false,
  });

  @override
  _PurchaseBillDetailScreenState createState() => _PurchaseBillDetailScreenState();
}

class _PurchaseBillDetailScreenState extends State<PurchaseBillDetailScreen> implements PurchaseBillDetailView {
  late PurchaseBillDetailPresenter _presenter;
  final int viewTypeLoader = 1;
  final int viewTypeError = 2;
  final int viewTypePurchaseBillDetails = 3;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier(defaultValue: 1);

  @override
  void initState() {
    _presenter = PurchaseBillDetailPresenter(
      widget.companyId,
      widget.billId,
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
      body: SafeArea(
        child: ItemNotifiable(
          notifier: _viewTypeNotifier,
          builder: (context, viewType) {
            if (viewType == viewTypeLoader) {
              return PurchaseBillDetailLoader();
            } else if (viewType == viewTypeError) {
              return _buildErrorView();
            } else {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PurchaseBillDetailAppBar(supplierName: _presenter.getSupplierName()),
                  Expanded(child: _buildBillDetailDetailsView()),
                  _approveAllAndRejectAllActionButton(),
                ],
              );
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

  Widget _buildBillDetailDetailsView() {
    return RefreshIndicator(
      onRefresh: () => _presenter.loadDetail(),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14),
        child: ListView(
          physics: AlwaysScrollableScrollPhysics(),
          children: [
            SizedBox(height: 20),
            _labelAndValue("Bill To", _presenter.getSupplierName()),
            Divider(color: AppColors.appBarShadowColor),
            _labelAndValue("Bill No", _presenter.getBillNumber()),
            Divider(color: AppColors.appBarShadowColor),
            _labelAndValue("Due Date", _presenter.getDueDate()),
            Divider(color: AppColors.appBarShadowColor),
            SizedBox(height: 20),
            _presenter.getNumberOfListItems() > 0
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Items/Services", style: TextStyles.largeTitleTextStyleBold),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Text("Cost", style: TextStyles.labelTextStyle),
                        ),
                      ),
                      ListView.separated(
                        shrinkWrap: true,
                        separatorBuilder: (BuildContext context, int index) =>
                            Divider(color: AppColors.appBarShadowColor),
                        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
                        itemCount: _presenter.getNumberOfListItems(),
                        itemBuilder: (context, index) => PurchaseBillDetailItemListCard(
                          presenter: _presenter,
                          billDetailListItem: _presenter.getItemAtIndex(index),
                        ),
                      ),
                      Divider(color: AppColors.appBarShadowColor),
                      SizedBox(height: 20),
                    ],
                  )
                : Container(),
            Text("Total Summary", style: TextStyles.largeTitleTextStyleBold),
            SizedBox(height: 4),
            _summaryValue("Sub Total", _presenter.getSubTotal()),
            _summaryValue("Discount", _presenter.getDiscount()),
            _summaryValue("Tax", _presenter.getTax()),
            _summaryValue("Total", _presenter.getTotal())
          ],
        ),
      ),
    );
  }

  Widget _approveAllAndRejectAllActionButton() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.screenBackgroundColor2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: RoundedRectangleActionButton(
              title: "Approve",
              icon: Icon(Icons.check, size: 18, color: Colors.white),
              backgroundColor: AppColors.green,
              isIconLeftAligned: false,
              height: 44,
              borderRadiusCircular: 16,
              onPressed: () => {_presenter.initiateApproval()},
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: RoundedRectangleActionButton(
              title: "Reject",
              icon: Icon(Icons.close, size: 18, color: Colors.white),
              backgroundColor: AppColors.red,
              isIconLeftAligned: false,
              height: 44,
              borderRadiusCircular: 16,
              onPressed: () => {_presenter.initiateRejection()},
            ),
          ),
        ],
      ),
    );
  }

  Widget _labelAndValue(String label, String? value, {TextStyle? valueStyle}) {
    if (value == null || value.isEmpty) return Container();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
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

  Widget _summaryValue(String label, String? value) {
    if (value == null || value.isEmpty) return Container();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          (label == 'Total')
              ? Text(label, style: TextStyles.titleTextStyleBold)
              : Text(label, style: TextStyles.titleTextStyle),
          Wrap(
            children: [
              (label == 'Discount')
                  ? Text(
                      value,
                      style: TextStyles.titleTextStyleBold.copyWith(color: AppColors.red),
                    )
                  : Text(
                      value,
                      style: TextStyles.titleTextStyleBold.copyWith(color: AppColors.textColorBlack),
                    ),
              SizedBox(width: 2),
              Padding(
                padding: const EdgeInsets.only(top: 1),
                child: Text(_presenter.getCurrency(),
                    style: TextStyles.smallLabelTextStyle.copyWith(color: AppColors.textColorBlueGray)),
              )
            ],
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
    _viewTypeNotifier.notify(viewTypePurchaseBillDetails);
  }

  @override
  void processApproval(String companyId, String billId, String billTo) {
    _approve(companyId, billId, billTo);
  }

  @override
  void processRejection(String companyId, String billId, String billTo) {
    _reject(companyId, billId, billTo);
  }

  //MARK: Functions to approve and reject

  void _approve(String companyId, String billId, String billTo) async {
    var didApprove = await showDialog(
      context: context,
      builder: (_) => PurchaseBillApprovalAlert(billId: billId, companyId: companyId, supplierName: billTo),
    );
    if (didApprove == true) Navigator.pop(context, true);
  }

  void _reject(String companyId, String billId, String billTo) async {
    var didReject = await showDialog(
      context: context,
      builder: (_) => PurchaseBillApprovalAlert(
        billId: billId,
        companyId: companyId,
        supplierName: billTo,
      ),
    );
    if (didReject == true) Navigator.pop(context, true);
  }
}
