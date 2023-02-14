import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/expense/expense_approval/ui/views/expense_approval_all_confirmation_alert.dart';
import 'package:wallpost/expense/expense_approval/ui/views/expense_rejection_all_confirmation_alert.dart';
import 'package:wallpost/expense/expense_approval_list/entities/expense_approval_list_item.dart';
import 'package:wallpost/expense/expense_approval_list/ui/views/action_button.dart';
import 'package:wallpost/expense/expense_approval_list/ui/views/expense_approval_list_app_bar.dart';
import 'package:wallpost/expense/expense_detail/ui/views/expense_detail_screen.dart';

import '../../../../_shared/constants/app_colors.dart';
import '../models/expense_approval_list_item_view_type.dart';
import '../presenters/expense_approval_list_presenter.dart';
import '../view_contracts/expense_approval_list_view.dart';
import 'expense_approval_list_item_card.dart';
import 'expense_approval_list_loader.dart';

class ExpenseApprovalListScreen extends StatefulWidget {
  final String companyId;

  ExpenseApprovalListScreen({required this.companyId});

  @override
  State<ExpenseApprovalListScreen> createState() => _ExpenseApprovalListScreenState();
}

class _ExpenseApprovalListScreenState extends State<ExpenseApprovalListScreen> implements ExpenseApprovalListView {
  late ExpenseApprovalListPresenter _listPresenter;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier(defaultValue: 0);
  final _scrollController = ScrollController();
  final int viewTypeLoader = 1;
  final int viewTypeError = 2;
  final int viewTypeNoItems = 3;
  final int viewTypeList = 4;

  @override
  void initState() {
    _listPresenter = ExpenseApprovalListPresenter(widget.companyId, this);
    _listPresenter.getNext();
    _setupScrollDownToLoadMoreItems();
    super.initState();
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
    return ExpenseApprovalListLoader();
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
          ExpenseApprovalListAppBar(
            isMultipleSelectionInProgress: _listPresenter.isSelectionInProgress,
            onInitiateMultipleSelectionButtonPressed: () => _listPresenter.initiateMultipleSelection(),
            onEndMultipleSelectionButtonPressed: () => _listPresenter.endMultipleSelection(),
            onSelectAllButtonPress: () => _listPresenter.selectAll(),
            onUnselectAllButtonPress: () => _listPresenter.unselectAll(),
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
            case ExpenseApprovalListItemViewType.ListItem:
              return _listItem(index);
            case ExpenseApprovalListItemViewType.Loader:
              return _listLoader();
            case ExpenseApprovalListItemViewType.ErrorMessage:
              return _errorListTile();
            case ExpenseApprovalListItemViewType.EmptySpace:
              return Container(height: 150);
          }
        },
      ),
    );
  }

  Widget _listItem(index) {
    // if (!showCheckBoxList)
    return ExpenseApprovalListItemCard(
      listPresenter: _listPresenter,
      approval: _listPresenter.getItemAtIndex(index),
    );
    // else {
    //   return ExpenseApprovalListItemCardWithCheckBox(
    //     listPresenter: _listPresenter,
    //     approval: _listPresenter.getItemAtIndex(index),
    //   );
    // }
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
            SizedBox(width: 12),
            Expanded(
              child: ActionButton(
                title: "Approve",
                icon: Icon(Icons.check, size: 18, color: Colors.white),
                color: AppColors.green,
                onPressed: () => _approveSelectedItems(),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: ActionButton(
                title: "Reject",
                icon: Icon(Icons.close, size: 18, color: Colors.white),
                color: AppColors.red,
                onPressed: () => _rejectSelectedItems(),
              ),
            ),
            SizedBox(width: 12),
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
          SizedBox(width: 12),
          Expanded(
            child: ActionButton(
              title: "Approve All",
              icon: Icon(Icons.check, size: 18, color: Colors.white),
              color: AppColors.green,
              onPressed: () => _approveAll(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: ActionButton(
              title: "Reject All",
              icon: Icon(Icons.close, size: 18, color: Colors.white),
              color: AppColors.red,
              onPressed: () => _rejectAll(),
            ),
          ),
          SizedBox(width: 12),
        ],
      ),
    );
  }

  //MARK: mass approve function

  void _approveAll() async {
    String didApprove = await showDialog(
      context: context,
      builder: (_) => ExpenseApprovalAllConfirmationAlert(
        noOfSelectedItems: 0,
        expenseIds: "",
        companyId: _listPresenter.getItemAtIndex(0).companyId,
      ),
    );
//TODO
//     if (didApprove == 'APPROVED')
//       _listPresenter.onDidProcessMassApprovalOrRejection(true, _listPresenter.getAllExpenseIdsAsList());
  }

  //MARK: mass reject function

  void _rejectAll() async {
    String didRejected = await showDialog(
      context: context,
      builder: (_) => ExpenseRejectionAllConfirmationAlert(
        noOfSelectedItems: 0,
        expenseIds: "",
        companyId: _listPresenter.getItemAtIndex(0).companyId,
      ),
    );
    //TODO
    // if (didRejected == 'REJECTED')
    //   _listPresenter.onDidProcessMassApprovalOrRejection(true, _listPresenter.getSelectedExpenseIdsAsList());
  }

  //MARK: approve selected items function

  void _approveSelectedItems() async {
    String didApprove = await showDialog(
      context: context,
      builder: (_) => ExpenseApprovalAllConfirmationAlert(
        noOfSelectedItems: 0, //TODO _listPresenter.getSelectedExpenseCount(),
        expenseIds: "",
        companyId: _listPresenter.getItemAtIndex(0).companyId,
      ),
    );

    //TODO
    // if (didApprove == 'APPROVED')
    //   _listPresenter.onDidProcessMassApprovalOrRejection(true, _listPresenter.getSelectedExpenseIdsAsList());
  }

  //MARK:  reject selected  function

  void _rejectSelectedItems() async {
    String didReject = await showDialog(
      context: context,
      builder: (_) => ExpenseRejectionAllConfirmationAlert(
        noOfSelectedItems: 0, //TODO _listPresenter.getSelectedExpenseCount(),
        expenseIds: "",
        companyId: _listPresenter.getItemAtIndex(0).companyId,
      ),
    );

    //TODO
    // if (didReject == 'REJECTED')
    //   _listPresenter.onDidProcessMassApprovalOrRejection(true, _listPresenter.getSelectedExpenseIdsAsList());
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
  void showExpenseDetail(ExpenseApprovalListItem approval) {
    _goToExpenseDetailScreen(approval);
  }

  void _goToExpenseDetailScreen(ExpenseApprovalListItem approval) async {
    var didPerformAction = await ScreenPresenter.present(
      ExpenseDetailScreen(
        companyId: approval.companyId,
        expenseId: approval.id,
        isLaunchingDetailScreenForApproval: true,
      ),
      context,
    );
    _listPresenter.onDidProcessMassApprovalOrRejection(didPerformAction, [approval.id]);
  }

  @override
  void onDidProcessAllApprovals() {
    _dismiss();
  }

  //MARK: Function to dismiss the screen

  void _dismiss() {
    Navigator.pop(context, _listPresenter.numberOfApprovalsProcessed);
  }

  @override
  void toggleAppBarRightEndText(bool isSelected) {
    // _checkBoxSelectorNotifier.notify(isSelected);
    setState(() {});
  }

  @override
  void onDidEndMultipleSelection() {
    _viewTypeNotifier.notify(viewTypeList);
  }

  @override
  void onDidInitiateMultipleSelection() {
    _viewTypeNotifier.notify(viewTypeList);
  }
}
