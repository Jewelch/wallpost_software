import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/wp_action.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/_wp_core/performance/performance_calculator.dart';

import '../../../../notification_center/notification_center.dart';
import '../../../../notification_center/notification_observer.dart';
import '../../../company_dashboard_employee_my_portal/entities/employee_my_portal_data.dart';
import '../../../company_dashboard_employee_my_portal/services/employee_my_portal_data_provider.dart';
import '../models/graph_value.dart';
import '../view_contracts/employee_my_portal_view.dart';

class EmployeeMyPortalDashboardPresenter {
  final EmployeeMyPortalView _view;
  final EmployeeMyPortalDataProvider _dataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  final NotificationCenter _notificationCenter;
  EmployeeMyPortalData? _employeeMyPortalData;

  EmployeeMyPortalDashboardPresenter(EmployeeMyPortalView view)
      : this.initWith(
          view,
          EmployeeMyPortalDataProvider(),
          SelectedCompanyProvider(),
          NotificationCenter.getInstance(),
        );

  EmployeeMyPortalDashboardPresenter.initWith(
    this._view,
    this._dataProvider,
    this._selectedCompanyProvider,
    this._notificationCenter,
  ) {
    _startListeningToNotifications();
  }

  //MARK: Functions to start and stop listening to notifications

  void _startListeningToNotifications() {
    _notificationCenter.addExpenseApprovalRequiredObserver(
      NotificationObserver(key: "employeeMyPortal", callback: (_) => syncDataInBackground()),
    );
    _notificationCenter.addLeaveApprovalRequiredObserver(
      NotificationObserver(key: "employeeMyPortal", callback: (_) => syncDataInBackground()),
    );
    _notificationCenter.addAttendanceAdjustmentApprovalRequiredObserver(
      NotificationObserver(key: "employeeMyPortal", callback: (_) => syncDataInBackground()),
    );
  }

  void stopListeningToNotifications() {
    _notificationCenter.removeObserverFromAllChannels(key: "employeeMyPortal");
  }

  //MARK: Functions to load data

  Future<void> loadData() async {
    if (_dataProvider.isLoading) return;

    _view.showLoader();
    try {
      _employeeMyPortalData = await _dataProvider.get();
      _view.onDidLoadData();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  void goToAggregatedApprovalsScreen() {
    var company = _selectedCompanyProvider.getSelectedCompanyForCurrentUser();
    _view.goToApprovalsListScreen(company.id);
  }

  //MARK: Functions to sync the dashboard data in the background

  Future<void> syncDataInBackground() async {
    if (_employeeMyPortalData == null) return;

    try {
      var existingData = _employeeMyPortalData!;
      var newData = await _dataProvider.get();

      if (_didDataChange(existingData, newData)) {
        _employeeMyPortalData = newData;
        _view.onDidLoadData();
      }
    } on WPException catch (_) {
      //do nothing
    }
  }

  bool _didDataChange(EmployeeMyPortalData existingData, EmployeeMyPortalData newData) {
    return _getTotalApprovalCount(existingData) != _getTotalApprovalCount(newData);
  }

  //MARK: Function to get approval count

  int getTotalApprovalCount() {
    return _getTotalApprovalCount(_employeeMyPortalData!);
  }

  int _getTotalApprovalCount(EmployeeMyPortalData myPortalData) {
    int totalApprovalCount = 0;
    for (var approval in myPortalData.aggregatedApprovals) {
      totalApprovalCount += approval.approvalCount;
    }
    return totalApprovalCount;
  }

  //MARK: Functions to get graph values

  GraphValue getYTDPerformance() {
    var performance = _employeeMyPortalData!.ytdPerformance.toInt();
    return GraphValue(
      performance,
      PerformanceCalculator().getColorForPerformance(performance),
    );
  }

  GraphValue getCurrentMonthPerformance() {
    var performance = _employeeMyPortalData!.currentMonthPerformance.toInt();
    return GraphValue(
      performance,
      PerformanceCalculator().getColorForPerformance(performance),
    );
  }

  GraphValue getCurrentMonthAttendancePerformance() {
    var performance = _employeeMyPortalData!.currentMonthAttendancePerformance.toInt();
    return GraphValue(
      performance,
      PerformanceCalculator().getColorForPerformance(performance),
    );
  }

  //MARK: Functions to get and select request items

  List<String> getRequestItems() {
    var employee = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().employee;
    return employee.allowedActions.map((action) => action.toReadableString()).toList();
  }

  void selectRequestItemAtIndex(int index) {
    var employee = _selectedCompanyProvider.getSelectedCompanyForCurrentUser().employee;
    var allowedActions = employee.allowedActions;
    var selectedAction = allowedActions[index];

    switch (selectedAction) {
      case WPAction.Leave:
        _view.showLeaveActions();
        break;
      case WPAction.Expense:
        _view.showExpenseActions();
        break;
      case WPAction.PayrollAdjustment:
        _view.showPayrollAdjustmentActions();
        break;
    }
  }
}
