import 'dart:async';

import 'package:wallpost/_shared/network_adapter/network_adapter.dart';
import 'package:wallpost/_shared/wpapi/wp_api.dart';
import 'package:wallpost/company_management/services/selected_company_provider.dart';
import 'package:wallpost/task/constants/task_urls.dart';
import 'package:wallpost/task/entities/task_assignee.dart';

class TaskAssigneesListProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  TaskAssigneesListProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  TaskAssigneesListProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<TaskAssignee>> getNext() async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = TaskUrls.assigneesUrl(companyId, _pageNumber, _perPage);
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

  Future<List<TaskAssignee>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<TaskAssignee>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<TaskAssignee> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var taskAssigneeList = <TaskAssignee>[];
      for (var responseMap in responseMapList) {
        var taskAssignee = TaskAssignee.fromJson(responseMap);
        taskAssigneeList.add(taskAssignee);
      }
      _updatePaginationRelatedData(taskAssigneeList.length);
      return taskAssigneeList;
    } catch (e) {
      throw InvalidResponseException();
    }
  }

  void _updatePaginationRelatedData(int noOfItemsReceived) {
    if (noOfItemsReceived > 0) {
      _pageNumber += 1;
    }
    if (noOfItemsReceived < _perPage) {
      _didReachListEnd = true;
    }
  }

  int getCurrentPageNumber() {
    return _pageNumber;
  }
}
