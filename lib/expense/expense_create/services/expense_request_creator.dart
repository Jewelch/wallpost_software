import 'dart:async';
import 'dart:io';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_file_uploader.dart';
import 'package:wallpost/expense/expense_create/constants/create_expense_request_urls.dart';

import '../entities/expense_request_form.dart';

class ExpenseRequestCreator {
  SelectedCompanyProvider _companyProvider;
  WPFileUploader _fileUploader;
  NetworkAdapter _networkAdapter;
  bool _isLoading = false;

  ExpenseRequestCreator()
      : _companyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI(),
        _fileUploader = WPFileUploader();

  ExpenseRequestCreator.initWith(
    this._companyProvider,
    this._networkAdapter,
    this._fileUploader,
  );

  Future<void> create(ExpenseRequestForm expenseRequest, File? attachment) async {
    _isLoading = true;
    try {
      var uploadedFileName = await _uploadFile(attachment);
      expenseRequest.attachedFileName = uploadedFileName;
      await _createExpenseRequest(expenseRequest);
      _isLoading = false;
      return;
    } on WPException {
      _isLoading = false;
      rethrow;
    }
  }

  Future<String?> _uploadFile(File? attachment) async {
    if (attachment == null) return null;
    var uploadResponse = await _fileUploader.upload([attachment]);
    return uploadResponse.uploadedFileNames[0];
  }

  Future<void> _createExpenseRequest(ExpenseRequestForm expenseRequest) async {
    var companyId = _companyProvider.getSelectedCompanyForCurrentUser().id;
    var url = CreateExpenseRequestUrls.getCreateExpenseRequestUrl(companyId);
    var apiRequest = APIRequest(url);

    apiRequest.addParameter("expenseItems", [expenseRequest.toJson()]);
    await _networkAdapter.postWithFormData(apiRequest);
    return null;
  }

  bool get isLoading => _isLoading;
}
