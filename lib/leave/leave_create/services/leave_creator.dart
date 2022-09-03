import 'dart:io';

import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_file_uploader.dart';
import 'package:wallpost/leave/leave_create/constants/create_leave_urls.dart';

import '../entities/leave_request_form.dart';

class LeaveCreator {
  SelectedCompanyProvider _companyProvider;
  WPFileUploader _fileUploader;
  NetworkAdapter _networkAdapter;
  bool _isLoading = false;

  LeaveCreator()
      : _companyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI(),
        _fileUploader = WPFileUploader();

  LeaveCreator.initWith(
    this._companyProvider,
    this._networkAdapter,
    this._fileUploader,
  );

  Future<void> create(LeaveRequestForm leaveRequestForm, File? attachment) async {
    _isLoading = true;
    try {
      var uploadedFileName = await _uploadFile(attachment);
      leaveRequestForm.attachedFileName = uploadedFileName;
      await _createLeave(leaveRequestForm);
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

  Future<void> _createLeave(LeaveRequestForm leaveRequestForm) async {
    var company = _companyProvider.getSelectedCompanyForCurrentUser();
    var url = CreateLeaveUrls.createLeaveUrl(company.id, company.employee.v1Id);
    var apiRequest = APIRequest(url);

    apiRequest.addParameters(leaveRequestForm.toJson());
    await _networkAdapter.post(apiRequest);
    return;
  }

  bool get isLoading => _isLoading;
}
