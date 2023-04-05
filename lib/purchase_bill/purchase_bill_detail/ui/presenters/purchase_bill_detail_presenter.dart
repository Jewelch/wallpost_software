import 'package:intl/intl.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/entities/purchase_bill_detail_item.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/services/purchase_bill_detail_provider.dart';
import 'package:wallpost/purchase_bill/purchase_bill_detail/ui/view_contracts/purchase_bill_detail_view.dart';

class PurchaseBillDetailPresenter {
  final String _companyId;
  final String _billId;
  final PurchaseBillDetailView _view;
  final PurchaseBillDetailProvider _purchaseBillDetailProvider;
  late PurchaseBillDetail _billDetailData;
  String? _errorMessage;

  PurchaseBillDetailPresenter(
    this._companyId,
    this._billId, {
    bool didLaunchDetailScreenForApproval = false,
    required PurchaseBillDetailView view,
  })  : this._view = view,
        _purchaseBillDetailProvider = PurchaseBillDetailProvider(_companyId);

  PurchaseBillDetailPresenter.initWith(
    this._companyId,
    this._billId,
    this._view,
    this._purchaseBillDetailProvider, {
    bool didLaunchDetailScreenForApproval = false,
  });

  Future<void> loadDetail() async {
    if (_purchaseBillDetailProvider.isLoading) return;

    _errorMessage = null;
    _view.showLoader();
    try {
      _billDetailData = await _purchaseBillDetailProvider.get(_billId);
      _view.onDidLoadDetails();
    } on WPException catch (e) {
      _errorMessage = "${e.userReadableMessage}\n\nTap here to reload.";
      _view.onDidFailToLoadDetails();
    }
  }

  //MARK: Functions for approval and rejection

  void initiateApproval() {
    _view.processApproval(_companyId, _billId, _billDetailData.billTo);
  }

  void initiateRejection() {
    _view.processRejection(_companyId, _billId, _billDetailData.billTo);
  }

  //MARK: Getters

  String getSupplierName() {
    return _billDetailData.billTo;
  }

  String getBillNumber() {
    return _billDetailData.billNumber;
  }

  String getDueDate() {
    return DateFormat("dd-MMM-yyyy").format(_billDetailData.dueDate);
  }

  String getCurrency() {
    return _billDetailData.currency;
  }

  String getSubTotal() {
    return _billDetailData.subTotal;
  }

  String getDiscount() {
    return _billDetailData.grandTotalDiscount;
  }

  String getTax() {
    return _billDetailData.totalTax;
  }

  String getTotal() {
    return _billDetailData.total;
  }

  //MARK: Functions to get list details

  int getNumberOfListItems() {
    return _billDetailData.billDetailItem.length;
  }

  PurchaseBillDetailItem getItemAtIndex(int index) {
    return _billDetailData.billDetailItem[index];
  }

  String? get errorMessage => _errorMessage;
}
