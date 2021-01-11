import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/task/constants/task_urls.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';
import 'package:wallpost/task/entities/task_list_item.dart';

class TaskListProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;

  TaskListProvider.initWith(this._selectedCompanyProvider, this._networkAdapter);

  TaskListProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI();

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<TaskListItem>> getNext(TaskListFilters filters) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    var url = TaskUrls.taskListUrl(companyId, filters, _pageNumber, _perPage);
    var apiRequest = APIRequest.withId(url, _sessionId);

    isLoading = true;
    _didReachListEnd = false;
    try {
      var apiResponse = await _networkAdapter.get(apiRequest);
      isLoading = false;
      return _processResponse(apiResponse);
    } on APIException catch (exception) {
      isLoading = false;
      throw exception;
    }
  }

  Future<List<TaskListItem>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<TaskListItem>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<TaskListItem> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var taskListItemList = <TaskListItem>[];
      for (var responseMap in responseMapList) {
        var taskListItem = TaskListItem.fromJson(responseMap);
        taskListItemList.add(taskListItem);
      }
      _updatePaginationRelatedData(taskListItemList.length);
      return taskListItemList;
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

  bool get didReachListEnd => _didReachListEnd;
}
