import 'dart:async';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_file_uploader.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';
import 'package:wallpost/expense_requests/constants/expense_requests_urls.dart';
import 'package:wallpost/expense_requests/entities/expense_request_form.dart';
import 'package:wallpost/expense_requests/exeptions/failed_to_save_requet.dart';

class ExpenseRequestCreator {
  WPFileUploader _fileUploader;
  NetworkAdapter _networkAdapter;
  SelectedCompanyProvider _companyProvider;
  bool isExecuting = false;

  ExpenseRequestCreator()
      : _networkAdapter = WPAPI(),
        _fileUploader = WPFileUploader(),
        _companyProvider = SelectedCompanyProvider();

  ExpenseRequestCreator.initWith(this._networkAdapter, this._fileUploader, this._companyProvider);

  Future execute(ExpenseRequestForm expenseRequest) async {
    if (isExecuting) return;
    isExecuting = true;
    String url = _prepareUrl();
    try {
      await _uploadFiles(expenseRequest);
      await _execute(expenseRequest, url);
      isExecuting = false;
    } on WPException {
      isExecuting = false;
      rethrow;
    }
  }

  String _prepareUrl() {
    var companyId = _companyProvider.getSelectedCompanyForCurrentUser().id;
    var url = ExpenseRequestsUrls.getExpenseAddingUrl(companyId);
    return url;
  }

  //MARK: Functions to upload files to the server

  Future _uploadFiles(ExpenseRequestForm expenseRequests) async {
    if (expenseRequests.file == null) return;
    var uploadResponse = await _fileUploader.upload([expenseRequests.file!]);
    var filesString = _processUploadFileResponse(uploadResponse);
    expenseRequests.fileString = filesString;
  }

  String _processUploadFileResponse(APIResponse apiResponse) {
    if (apiResponse.data == null) throw InvalidResponseException();
    print(apiResponse.data);

    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    if (apiResponse.data['sample_pdf'] == null || apiResponse.data['sample_pdf'] == '')
      // && (apiResponse.data['IMG_0004_jpeg'] == null || apiResponse.data['IMG_0004_jpeg'] == '')
      throw FailedToSaveRequest();

    var response = apiResponse.data as Map<String, dynamic>;
    return response['sample_pdf'].toString();
  }

  //MARK: Functions to send expense request to the server

  Future<bool> _execute(ExpenseRequestForm expenseRequests, String url) async {
    var apiRequest = APIRequest(url);
    apiRequest.addParameter("expenseItems", [expenseRequests.toJson()]);
    var apiResponse = await _networkAdapter.postWithFormData(apiRequest);
    return _processResponse(apiResponse);
  }

  bool _processResponse(APIResponse apiResponse) {
    if (apiResponse.data == null) throw InvalidResponseException();

    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    if (apiResponse.data['status'] != "success") throw FailedToSaveRequest();
    return true;
  }
}
