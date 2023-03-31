import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval/ui/views/purchase_bill_approval_all_alert.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/entities/purchase_bill_approval_list_item.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/ui/models/purchase_bill_approval_list_item_view_type.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/ui/presenters/purchase_bill_approval_list_presenter.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/ui/view_contracts/purchase_bill_approval_list_view.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/ui/views/purchase_bill_approval_list_app_bar.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/ui/views/purchase_bill_approval_list_item_card.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/ui/views/purchase_bill_approval_list_loader.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/ui/views/purchase_bill_detail_screen.dart';

import '../../../../_common_widgets/buttons/rounded_action_button.dart';
import '../../../../_common_widgets/screen_presenter/screen_presenter.dart';
import '../../../../_shared/constants/app_colors.dart';
import '../../../purchase_bill_approval/ui/views/purchase_bill_rejection_all_alert.dart';

class PurchaseBillApprovalListScreen extends StatefulWidget {
  final String companyId;

  PurchaseBillApprovalListScreen({required this.companyId});

  @override
  State<PurchaseBillApprovalListScreen> createState() => _PurchaseBillApprovalListScreenState();
}

class _PurchaseBillApprovalListScreenState extends State<PurchaseBillApprovalListScreen>
    implements PurchaseBillApprovalListView {
  late PurchaseBillApprovalListPresenter _listPresenter;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier(defaultValue: 0);
  final _scrollController = ScrollController();
  final int viewTypeLoader = 1;
  final int viewTypeError = 2;
  final int viewTypeNoItems = 3;
  final int viewTypeList = 4;

  @override
  void initState() {
    _listPresenter = PurchaseBillApprovalListPresenter(widget.companyId, this);
    loadData();
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void loadData() async {
    await _listPresenter.getNext();
    _listPresenter.initiateMultipleSelection();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _listPresenter.getNext();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
        _dismiss();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: AppColors.screenBackgroundColor,
        body: SafeArea(
          child: ItemNotifiable(
            notifier: _viewTypeNotifier,
            builder: (context, viewType) {
              if (viewType == viewTypeLoader) {
                return _buildLoaderView();
              } else if (viewType == viewTypeError) {
                return _buildErrorView();
              } else if (viewType == viewTypeNoItems) {
                return _buildNoItemsView();
              } else {
                return _dataView();
              }
            },
          ),
        ),
      ),
    );
  }

  Widget _buildLoaderView() {
    return PurchaseBillApprovalListLoader();
  }

  Widget _buildErrorView() {
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _listPresenter.getNext(),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  _listPresenter.errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyles.titleTextStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoItemsView() {
    return Column(
      children: [
        SizedBox(height: 20),
        Expanded(
          child: GestureDetector(
            onTap: () => _listPresenter.getNext(),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  _listPresenter.noItemsMessage,
                  textAlign: TextAlign.center,
                  style: TextStyles.titleTextStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dataView() {
    return Container(
      color: AppColors.screenBackgroundColor2,
      child: Column(
        children: [
          PurchaseBillApprovalListAppBar(
            selectedCompanyName: "",
            noOfSelectedItems: _listPresenter.getCountOfSelectedItems(),
            isAllItemAreSelected: _listPresenter.areAllItemsSelected(),
            isMultipleSelectionInProgress: _listPresenter.isSelectionInProgress,
            onInitiateMultipleSelectionButtonPressed: () => _listPresenter.initiateMultipleSelection(),
            onEndMultipleSelectionButtonPressed: () => _listPresenter.endMultipleSelection(),
            onSelectAllButtonPress: () => _listPresenter.selectAll(),
            onUnselectAllButtonPress: () => _listPresenter.unselectAll(),
            onBackButtonPress: () => _dismiss(),
          ),
          SizedBox(height: 20),
          Expanded(child: _listView()),
          _listPresenter.isSelectionInProgress ? _approveAndRejectActionButton() : _approveAllAndRejectAllActionButton()
        ],
      ),
    );
  }

  Widget _listView() {
    return RefreshIndicator(
      onRefresh: () => _listPresenter.refresh(),
      child: ListView.builder(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _listPresenter.getNumberOfListItems(),
        itemBuilder: (context, index) {
          switch (_listPresenter.getItemTypeAtIndex(index)) {
            case PurchaseBillApprovalListItemViewType.ListItem:
              return _listItem(index);
            case PurchaseBillApprovalListItemViewType.Loader:
              return _listLoader();
            case PurchaseBillApprovalListItemViewType.ErrorMessage:
              return _errorListTile();
            case PurchaseBillApprovalListItemViewType.EmptySpace:
              return Container(height: 150);
          }
        },
      ),
    );
  }

  Widget _listItem(index) {
    return PurchaseBillApprovalListItemCard(
      listPresenter: _listPresenter,
      approval: _listPresenter.getItemAtIndex(index),
    );
  }

  Widget _listLoader() {
    return Container(
      height: 150,
      child: Center(
        child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 3)),
      ),
    );
  }

  Widget _errorListTile() {
    return GestureDetector(
      onTap: () => _listPresenter.getNext(),
      child: Container(
        height: 100,
        child: Text(_listPresenter.errorMessage),
      ),
    );
  }

  Widget _approveAndRejectActionButton() {
    if (_listPresenter.getCountOfSelectedItems() > 0)
      return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
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
                onPressed: () => _approveSelectedItems(),
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
                onPressed: () => _rejectSelectedItems(),
              ),
            ),
          ],
        ),
      );
    return Container();
  }

  Widget _approveAllAndRejectAllActionButton() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: RoundedRectangleActionButton(
              title: "Approve All",
              icon: Icon(Icons.check, size: 18, color: Colors.white),
              backgroundColor: AppColors.green,
              isIconLeftAligned: false,
              height: 44,
              borderRadiusCircular: 16,
              onPressed: () => _approveAll(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: RoundedRectangleActionButton(
              title: "Reject All",
              icon: Icon(Icons.close, size: 18, color: Colors.white),
              backgroundColor: AppColors.red,
              isIconLeftAligned: false,
              height: 44,
              borderRadiusCircular: 16,
              onPressed: () => _rejectAll(),
            ),
          ),
        ],
      ),
    );
  }

  //MARK: mass approve function

  void _approveAll() async {
    var didApprove = await showDialog(
      context: context,
      builder: (_) => PurchaseBillApprovalAllAlert(
        noOfSelectedItems: _listPresenter.getCountOfAllItems(),
        billIds: _listPresenter.getAllIds(),
        companyId: _listPresenter.getItemAtIndex(0).companyId,
      ),
    );
    if (didApprove) _listPresenter.onDidProcessApprovalOrRejection(didApprove, _listPresenter.getAllIds());
  }

  //MARK: mass reject function

  void _rejectAll() async {
    var didRejected = await showDialog(
      context: context,
      builder: (_) => PurchaseBillRejectionAllAlert(
        noOfSelectedItems: _listPresenter.getCountOfAllItems(),
        billIds: _listPresenter.getAllIds(),
        companyId: _listPresenter.getItemAtIndex(0).companyId,
      ),
    );
    if (didRejected) _listPresenter.onDidProcessApprovalOrRejection(didRejected, _listPresenter.getAllIds());
  }

  //MARK: approve selected items function

  void _approveSelectedItems() async {
    var didApprove = await showDialog(
      context: context,
      builder: (_) => PurchaseBillApprovalAllAlert(
        noOfSelectedItems: _listPresenter.getCountOfSelectedItems(),
        billIds: _listPresenter.getSelectedItemIds(),
        companyId: _listPresenter.getItemAtIndex(0).companyId,
      ),
    );

    if (didApprove) _listPresenter.onDidProcessApprovalOrRejection(didApprove, _listPresenter.getSelectedItemIds());
  }

  //MARK:  reject selected  function

  void _rejectSelectedItems() async {
    var didReject = await showDialog(
      context: context,
      builder: (_) => PurchaseBillRejectionAllAlert(
        noOfSelectedItems: _listPresenter.getCountOfSelectedItems(),
        billIds: _listPresenter.getSelectedItemIds(),
        companyId: _listPresenter.getItemAtIndex(0).companyId,
      ),
    );
    if (didReject) _listPresenter.onDidProcessApprovalOrRejection(didReject, _listPresenter.getSelectedItemIds());
  }

  //MARK: Approval list view functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(viewTypeLoader);
  }

  @override
  void showErrorMessage() {
    _viewTypeNotifier.notify(viewTypeError);
  }

  @override
  void showNoItemsMessage() {
    _viewTypeNotifier.notify(viewTypeNoItems);
  }

  @override
  void updateList() {
    _viewTypeNotifier.notify(viewTypeList);
  }

  @override
  void showBillDetail(PurchaseBillApprovalBillItem approval) {
    _goToPurchaseBillDetailScreen(approval);
  }

  void _goToPurchaseBillDetailScreen(PurchaseBillApprovalBillItem approval) async {
    var didPerformAction = await ScreenPresenter.present(
      PurchaseBillDetailScreen(
        companyId: widget.companyId,
        billId: approval.id,
        isLaunchingDetailScreenForApproval: true,
      ),
      context,
    );
    _listPresenter.onDidProcessApprovalOrRejection(didPerformAction, [approval.id]);
  }

  @override
  void onDidProcessAllApprovals() {
    _dismiss();
  }

  @override
  void onDidEndMultipleSelection() {
    _viewTypeNotifier.notify(viewTypeList);
  }

  @override
  void onDidInitiateMultipleSelection() {
    _viewTypeNotifier.notify(viewTypeList);
  }

  //MARK: Function to dismiss the screen

  void _dismiss() {
    Navigator.pop(context, _listPresenter.numberOfApprovalsProcessed);
  }
}
