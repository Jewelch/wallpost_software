import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/wpapi/services/network_adapter.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/task/constants/task_urls.dart';
import 'package:wallpost/task/entities/task_employee.dart';

class TaskEmployeeListProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;
  bool _shouldGetAllEmployees = true;

  TaskEmployeeListProvider.initWith(this._selectedCompanyProvider, this._networkAdapter, this._shouldGetAllEmployees);

  TaskEmployeeListProvider.allEmployeesProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI(),
        _shouldGetAllEmployees = true;

  TaskEmployeeListProvider.subordinatesProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI(),
        _shouldGetAllEmployees = false;

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<TaskEmployee>> getNext({String searchText}) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    String url;
    if (_shouldGetAllEmployees) {
      url = TaskUrls.assigneesUrl(companyId, _pageNumber, _perPage, searchText);
    } else {
      url = TaskUrls.subordinatesUrl(companyId, _pageNumber, _perPage, searchText);
    }
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

  Future<List<TaskEmployee>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<TaskEmployee>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<TaskEmployee> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var taskEmployeeList = <TaskEmployee>[];
      for (var responseMap in responseMapList) {
        var taskEmployee = TaskEmployee.fromJson(responseMap);
        taskEmployeeList.add(taskEmployee);
      }
      _updatePaginationRelatedData(taskEmployeeList.length);
      return taskEmployeeList;
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
