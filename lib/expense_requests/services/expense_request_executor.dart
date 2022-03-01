import 'dart:async';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_file_uploader.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';
import 'package:wallpost/expense_requests/constants/expense_requests_urls.dart';
import 'package:wallpost/expense_requests/entities/expense_request_form.dart';
import 'package:wallpost/expense_requests/exeptions/failed_to_save_requet.dart';

class ExpenseRequestExecutor {
  WPFileUploader _fileUploader;
  NetworkAdapter _networkAdapter;
  SelectedCompanyProvider _companyProvider;

  ExpenseRequestExecutor()
      : _networkAdapter = WPAPI(),
        _fileUploader = WPFileUploader(),
        _companyProvider = SelectedCompanyProvider();

  ExpenseRequestExecutor.initWith(this._networkAdapter, this._fileUploader, this._companyProvider);

  Future execute(List<ExpenseRequestForm> expenseRequests) async {
    if (expenseRequests.isEmpty) return;
    String url = _prepareUrl();
    try {
      await _uploadFiles(expenseRequests);
      return await _execute(expenseRequests, url);
    } on WPException {
      rethrow;
    }
  }

  String _prepareUrl() {
    var companyId = _companyProvider.getSelectedCompanyForCurrentUser().id;
    var url = ExpenseRequestsUrls.getExpenseAddingUrl(companyId);
    return url;
  }

  //MARK: Functions to upload files to the server

  Future _uploadFiles(List<ExpenseRequestForm> expenseRequests) async {
    for (var expenseRequest in expenseRequests) {
      var uploadResponse = await _fileUploader.upload(expenseRequest.files);
      var filesString = _processUploadFileResponse(uploadResponse);
      expenseRequest.filesString = filesString;
    }
  }

  String _processUploadFileResponse(APIResponse apiResponse) {
    if (apiResponse.data == null) throw InvalidResponseException();

    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var response = apiResponse.data as Map<String, dynamic>;
    return response['file'];
  }

  //MARK: Functions to send expense request to the server

  Future<bool> _execute(List<ExpenseRequestForm> expenseRequests, String url) async {
    var mappedRequests = expenseRequests.map((e) => e.toJson()).toList();
    var apiRequest = APIRequest(url);
    apiRequest.addParameter("expenseItems", mappedRequests);
    var apiResponse = await _networkAdapter.post(apiRequest);
    return _processResponse(apiResponse);
  }

  bool _processResponse(APIResponse apiResponse) {
    if (apiResponse.data == null) throw InvalidResponseException();

    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    if (apiResponse.data['status'] != "success") throw FailedToSaveRequest();
    return true;
  }
}
