import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_approval_item.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_item_data.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/services/purchase_bill_detail_provider.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/ui/view_contracts/purchase_bill_detail_view.dart';

class PurchaseBillDetailPresenter {
  final String _companyId;
  final String _billId;
  final bool _didLaunchDetailScreenForApproval;
  final PurchaseBillDetailView _view;
  final PurchaseBillDetailProvider _purchaseBillDetailProvider;
  late PurchaseBillDetailApprovalItem _billItemDetail;
  String? _errorMessage;

  PurchaseBillDetailPresenter(
    this._companyId,
    this._billId, {
    bool didLaunchDetailScreenForApproval = false,
    required PurchaseBillDetailView view,
  })  : this._didLaunchDetailScreenForApproval = didLaunchDetailScreenForApproval,
        this._view = view,
        _purchaseBillDetailProvider = PurchaseBillDetailProvider(_companyId);

  PurchaseBillDetailPresenter.initWith(
    this._companyId,
    this._billId,
    this._view,
    this._purchaseBillDetailProvider, {
    bool didLaunchDetailScreenForApproval = false,
  }) : this._didLaunchDetailScreenForApproval = didLaunchDetailScreenForApproval;

  Future<void> loadDetail() async {
    if (_purchaseBillDetailProvider.isLoading) return;

    _errorMessage = null;
    _view.showLoader();
    try {
      _billItemDetail = await _purchaseBillDetailProvider.get(_billId);
      _view.onDidLoadDetails();
    } on WPException catch (e) {
      _errorMessage = "${e.userReadableMessage}\n\nTap here to reload.";
      _view.onDidFailToLoadDetails();
    }
  }

  //MARK: Functions for approval and rejection

  void initiateApproval() {
    _view.processApproval(_companyId, _billItemDetail.id, _billItemDetail.billTo);
  }

  void initiateRejection() {
    _view.processRejection(_companyId, _billItemDetail.id, _billItemDetail.billTo);
  }

  //MARK: Getters

  String getSupplierName() {
    return _billItemDetail.billTo;
  }

  String getBillNumber() {
    return _billItemDetail.billNumber;
  }

  String getDueDate() {
    return _billItemDetail.dueDate;
  }

  String getCurrency() {
    return _billItemDetail.currency;
  }

  String getSubTotal() {
    return _billItemDetail.subTotal;
  }

  String getDiscount() {
    return _billItemDetail.grandTotalDiscount;
  }

  String getTax() {
    return _billItemDetail.totalTax;
  }

  String getTotal() {
    return _billItemDetail.total;
  }

  //MARK: Functions to get list details

  int getNumberOfListItems() {
    return _billItemDetail.billItemData.length;
  }

  PurchaseBillDetailItemData getItemAtIndex(int index) {
    return _billItemDetail.billItemData[index];
  }


  String? get errorMessage => _errorMessage;
}
