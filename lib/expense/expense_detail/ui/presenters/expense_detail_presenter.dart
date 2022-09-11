import 'dart:ui';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/expense/expense__core/entities/expense_request_approval_status.dart';
import 'package:wallpost/expense/expense_detail/services/expense_detail_provider.dart';

import '../../../../_shared/constants/app_colors.dart';
import '../../../expense__core/entities/expense_request.dart';
import '../view_contracts/expense_detail_view.dart';

class ExpenseDetailPresenter {
  final String _companyId;
  final String _expenseId;
  final bool _didLaunchDetailScreenForApproval;
  final ExpenseDetailView _view;
  final ExpenseDetailProvider _expenseDetailProvider;
  late ExpenseRequest _expenseRequest;
  String? _errorMessage;
  var _didProcessApprovalOrRejection = false;

  ExpenseDetailPresenter(
    this._companyId,
    this._expenseId, {
    bool didLaunchDetailScreenForApproval = false,
    required ExpenseDetailView view,
  })  : this._didLaunchDetailScreenForApproval = didLaunchDetailScreenForApproval,
        this._view = view,
        _expenseDetailProvider = ExpenseDetailProvider(_companyId);

  ExpenseDetailPresenter.initWith(
    this._companyId,
    this._expenseId,
    this._view,
    this._expenseDetailProvider, {
    bool didLaunchDetailScreenForApproval = false,
  }) : this._didLaunchDetailScreenForApproval = didLaunchDetailScreenForApproval;

  Future<void> loadDetail() async {
    if (_expenseDetailProvider.isLoading) return;

    _errorMessage = null;
    _view.showLoader();
    try {
      _expenseRequest = await _expenseDetailProvider.get(_expenseId);
      _view.onDidLoadDetails();
    } on WPException catch (e) {
      _errorMessage = "${e.userReadableMessage}\n\nTap here to reload.";
      _view.onDidFailToLoadDetails();
    }
  }

  //MARK: Functions for approval and rejection

  void initiateApproval() {
    _view.processApproval(_companyId, _expenseId, _expenseRequest.requestedBy);
  }

  void initiateRejection() {
    _view.processRejection(_companyId, _expenseId, _expenseRequest.requestedBy);
  }

  Future<void> onDidProcessApprovalOrRejection(dynamic didProcess) async {
    if (didProcess == true) {
      _didProcessApprovalOrRejection = true;
      await loadDetail();
    }
  }

  //MARK: Getters

  bool shouldShowApprovalActions() {
    return _didLaunchDetailScreenForApproval && _expenseRequest.approvalStatus == ExpenseRequestApprovalStatus.pending;
  }

  String getTitle() {
    return _expenseRequest.getTitle();
  }

  String getRequestNumber() {
    return _expenseRequest.requestNumber;
  }

  String getRequestDate() {
    return _expenseRequest.requestDate.toReadableString();
  }

  String getRequestedBy() {
    return _expenseRequest.requestedBy;
  }

  String? getMainCategory() {
    return _expenseRequest.mainCategory;
  }

  String? getProject() {
    return _expenseRequest.project;
  }

  String? getSubCategory() {
    return _expenseRequest.subCategory;
  }

  String getRate() {
    return _expenseRequest.rate;
  }

  String getQuantity() {
    return "${_expenseRequest.quantity}";
  }

  String getTotalAmount() {
    return _expenseRequest.totalAmount;
  }

  String? getAttachmentUrl() {
    return _expenseRequest.attachmentUrl;
  }

  String? getStatus() {
    return _expenseRequest.statusMessage;
  }

  Color getStatusColor() {
    if (_expenseRequest.approvalStatus == ExpenseRequestApprovalStatus.pending) {
      return AppColors.yellow;
    } else if (_expenseRequest.approvalStatus == ExpenseRequestApprovalStatus.rejected) {
      return AppColors.red;
    } else {
      return AppColors.green;
    }
  }

  String? getRejectionReason() {
    return _expenseRequest.rejectionReason;
  }

  String? get errorMessage => _errorMessage;

  get didProcessApprovalOrRejection => _didProcessApprovalOrRejection;
}
