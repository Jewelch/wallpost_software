import 'dart:async';

import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/leave/constants/leave_urls.dart';
import 'package:wallpost/leave/entities/leave_employee.dart';

import '../../company_core/services/selected_company_provider.dart';

class LeaveEmployeesListProvider {
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NetworkAdapter _networkAdapter;
  final int _perPage = 15;
  int _pageNumber = 1;
  bool _didReachListEnd = false;
  String _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
  bool isLoading = false;
  bool _shouldGetAllEmployees = true;

  LeaveEmployeesListProvider.initWith(
    this._selectedCompanyProvider,
    this._networkAdapter,
    this._shouldGetAllEmployees,
  );

  LeaveEmployeesListProvider.allEmployeesProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI(),
        _shouldGetAllEmployees = true;

  LeaveEmployeesListProvider.subordinatesProvider()
      : _selectedCompanyProvider = SelectedCompanyProvider(),
        _networkAdapter = WPAPI(),
        _shouldGetAllEmployees = false;

  void reset() {
    _pageNumber = 1;
    _didReachListEnd = false;
    _sessionId = DateTime.now().millisecondsSinceEpoch.toString();
    isLoading = false;
  }

  Future<List<LeaveEmployee>> getNext({String? searchText}) async {
    var companyId = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().id;
    String url;
    if (_shouldGetAllEmployees) {
      url = LeaveUrls.assigneesUrl(companyId, _pageNumber, _perPage, searchText ?? "");
    } else {
      url = LeaveUrls.subordinatesUrl(companyId, _pageNumber, _perPage, searchText ?? "");
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

  Future<List<LeaveEmployee>> _processResponse(APIResponse apiResponse) async {
    //returning if the response is from another session
    if (apiResponse.apiRequest.requestId != _sessionId) return Completer<List<LeaveEmployee>>().future;
    if (apiResponse.data == null) throw InvalidResponseException();
    if (apiResponse.data is! List<Map<String, dynamic>>) throw WrongResponseFormatException();

    var responseMapList = apiResponse.data as List<Map<String, dynamic>>;
    return _readItemsFromResponse(responseMapList);
  }

  List<LeaveEmployee> _readItemsFromResponse(List<Map<String, dynamic>> responseMapList) {
    try {
      var taskEmployeeList = <LeaveEmployee>[];
      for (var responseMap in responseMapList) {
        var taskEmployee = LeaveEmployee.fromJson(responseMap);
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
