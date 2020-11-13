import 'dart:async';

import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/task/constants/task_urls.dart';
import 'package:wallpost/task/entities/task_time_zones.dart';

class TaskTimeZonesProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  bool isLoading = false;
  String _sessionId;

  TaskTimeZonesProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  TaskTimeZonesProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  Future<TaskTimeZones> getTimeZones() async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = TaskUrls.getTimeZonesUrl(companyId);
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    var apiRequest = APIRequest.withId(url, _sessionId);
    isLoading = true;

    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }

  Future<TaskTimeZones> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<TaskTimeZones>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! Map<String, dynamic>) throw WrongResponseFormatException();

    var responseMap = apiResponse.data as Map<String, dynamic>;
    try {
      var taskTimeZones = TaskTimeZones.fromJson(responseMap);
      return taskTimeZones;
    } catch (e) {
      throw InvalidResponseException();
    }
  }
}
