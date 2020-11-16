import 'dart:async';

import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/network_adapter/network_adapter.dart';
import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/task/constants/task_urls.dart';
import 'package:wallpost/task/entities/create_task_form.dart';

class TaskCreator {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  String _sessionId;

  TaskCreator.initWith(this._selectedCompanyProvider, this._networkAdapter);

  TaskCreator()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  Future<String> create(CreateTaskForm createTaskForm) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = TaskUrls.createTaskUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    apiRequest.addParameters(createTaskForm.toJson());
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.postWithNonce(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }

  Future<String> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<String>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    var sift = Sift();
    try {
      return sift.readStringFromMap(responseMap, 'task_id');
    } on SiftException catch (_) {
      throw InvalidResponseException();
    }
  }
}
