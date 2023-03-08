import 'package:wallpost/purchase_bill/purchase_bill_approval_list/entities/purchase_bill_approval_list_item.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/services/purchase_bill_approval_list_provider.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/ui/models/purchase_bill_approval_list_item_view_type.dart';
import 'package:wallpost/purchase_bill/purchase_bill_approval_list/ui/view_contracts/purchase_bill_approval_list_view.dart';

import '../../../../_shared/exceptions/wp_exception.dart';

class PurchaseBillApprovalListPresenter{
  final PurchaseBillApprovalListView _view;
  final PurchaseBillApprovalListProvider _approvalListProvider;
  final List<PurchaseBillApprovalBillItem> _approvalItems = [];
  final List<PurchaseBillApprovalBillItem> _selectedItems = [];
  String _errorMessage = "";
  final String _noItemsMessage = "There are no approvals to show.\n\nTap here to reload.";
  int _numberOfApprovalsProcessed = 0;
  var _isSelectionInProgress = false;

  PurchaseBillApprovalListPresenter(String companyId, this._view)
      : _approvalListProvider = PurchaseBillApprovalListProvider(companyId);

  PurchaseBillApprovalListPresenter.initWith(this._view, this._approvalListProvider);

//MARK: Functions to load data

  Future<void> getNext() async {
    if (_approvalListProvider.isLoading) return;
    _isFirstLoad() ? _view.showLoader() : _view.updateList();
    _resetErrors();

    try {
      var newListItems = await _approvalListProvider.getNext();
      _handleResponse(newListItems);
    } on WPException catch (e) {
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _isFirstLoad() ? _view.showErrorMessage() : _view.updateList();
    }
  }

  void _handleResponse(List<PurchaseBillApprovalBillItem> newListItems) {
    _approvalItems.addAll(newListItems);
    _updateList();
  }

  void _updateList() {
    if (_isFirstLoad()) {
      _view.showNoItemsMessage();
    } else {
      _view.updateList();
    }
  }

  void _resetErrors() {
    _errorMessage = "";
  }

  bool _isFirstLoad() {
    return _approvalItems.isEmpty;
  }

  //MARK: Function to refresh the list

  Future<void> refresh() async {
    _approvalItems.clear();
    _selectedItems.clear();
    _isSelectionInProgress = false;
    _approvalListProvider.reset();
    getNext();
  }

  //MARK: Function to show item detail

  void showDetail(PurchaseBillApprovalBillItem approval) {
    _view.showExpenseDetail(approval);
  }

  //MARK: Functions to get the list details

  int getNumberOfListItems() {
    if (_approvalItems.isEmpty) return 0;
    return _approvalItems.length + 1;
  }

  PurchaseBillApprovalListItemViewType getItemTypeAtIndex(int index) {
    if (index < _approvalItems.length) return PurchaseBillApprovalListItemViewType.ListItem;

    if (_errorMessage.isNotEmpty) return PurchaseBillApprovalListItemViewType.ErrorMessage;

    if (_approvalListProvider.isLoading || _approvalListProvider.didReachListEnd == false)
      return PurchaseBillApprovalListItemViewType.Loader;

    return PurchaseBillApprovalListItemViewType.EmptySpace;
  }

  PurchaseBillApprovalBillItem getItemAtIndex(int index) {
    return _approvalItems[index];
  }


  //MARK: Getters

  int getCountOfAllItems() {
    return _approvalItems.length;
  }

  get isSelectionInProgress => _isSelectionInProgress;

  String get errorMessage => _errorMessage;

  String get noItemsMessage => _noItemsMessage;
}