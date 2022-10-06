import "package:collection/collection.dart";
import 'package:wallpost/notification_center/notification_center.dart';

import '../../../../_shared/exceptions/wp_exception.dart';
import '../../../../notification_center/notification_observer.dart';
import '../../entities/aggregated_approval.dart';
import '../../services/aggregated_approvals_list_provider.dart';
import '../view_contracts/aggregated_approvals_list_view.dart';

class AggregatedApprovalsListPresenter {
  final String? companyId;
  final AggregatedApprovalsListView _view;
  final AggregatedApprovalsListProvider _provider;
  final NotificationCenter _notificationCenter;
  List<AggregatedApproval> _approvals = [];

  late String _selectedCompanyName;
  late String _selectedModuleName;

  AggregatedApprovalsListPresenter(AggregatedApprovalsListView view, {String? companyId})
      : this.initWith(
          view,
          AggregatedApprovalsListProvider(),
          NotificationCenter.getInstance(),
          companyId: companyId,
        );

  AggregatedApprovalsListPresenter.initWith(
    this._view,
    this._provider,
    this._notificationCenter, {
    this.companyId,
  }) {
    _startListeningToNotifications();
  }

  //MARK: Functions to start and stop listening to notifications

  void _startListeningToNotifications() {
    _notificationCenter.addExpenseApprovalRequiredObserver(
      NotificationObserver(key: "aggregatedApprovalsList", callback: (_) => loadApprovalsList()),
    );
    _notificationCenter.addLeaveApprovalRequiredObserver(
      NotificationObserver(key: "aggregatedApprovalsList", callback: (_) => loadApprovalsList()),
    );
    _notificationCenter.addAttendanceAdjustmentApprovalRequiredObserver(
      NotificationObserver(key: "aggregatedApprovalsList", callback: (_) => loadApprovalsList()),
    );
  }

  void stopListeningToNotifications() {
    _notificationCenter.removeObserverFromAllChannels(key: "aggregatedApprovalsList");
  }

  //MARK: Functions to load data

  Future<void> loadApprovalsList() async {
    if (_provider.isLoading) return;

    _view.showLoader();
    _resetFilters();

    try {
      if (companyId == null) {
        _approvals = await _provider.getAllApprovals();
      } else {
        _approvals = await _provider.getAllApprovals(companyId: companyId);
      }

      if (_approvals.isEmpty) {
        _view.showErrorMessage("There are no pending approvals.\n\nTap here to reload.");
        return;
      }

      _view.updateList();
    } on WPException catch (e) {
      _approvals.clear();
      _view.showErrorMessage('${e.userReadableMessage}\n\nTap here to reload.');
    }
  }

  //MARK: Functions to get list details

  int getNumberOfRows() {
    return _getFilteredApprovals().length;
  }

  AggregatedApproval getItemAtIndex(int index) {
    return _getFilteredApprovals()[index];
  }

  //MARK: Filter functions

  bool shouldShowCompanyFilter() {
    return companyId == null;
  }

  filter({String? companyName, String? moduleName}) {
    if (companyName != null) _selectedCompanyName = companyName;
    if (moduleName != null) _selectedModuleName = moduleName;

    var filteredList = _getFilteredApprovals();
    if (filteredList.isEmpty) {
      _view.showNoMatchingResultsMessage("There are no approvals that match\nthe selected filters.");
      return;
    } else {
      _view.updateList();
    }
  }

  List<AggregatedApproval> _getFilteredApprovals() {
    var filteredList = _approvals;
    if (_selectedCompanyName != "All Companies") {
      filteredList = _approvals.where((approval) => (approval.companyName == _selectedCompanyName)).toList();
    }
    if (_selectedModuleName != "All Modules") {
      filteredList =
          filteredList.where((approval) => (approval.module.toReadableString() == _selectedModuleName)).toList();
    }
    return filteredList;
  }

  String getSelectedCompanyName() {
    return _selectedCompanyName;
  }

  String getSelectedModuleName() {
    return _selectedModuleName;
  }

  void _resetFilters() {
    _selectedCompanyName = "All Companies";
    _selectedModuleName = "All Modules";
  }

  //MARK: Function to handle processed approvals

  void didProcessApprovals(AggregatedApproval aggregatedApproval, dynamic numberOfApprovalsProcessed) {
    if (numberOfApprovalsProcessed == null || !(numberOfApprovalsProcessed is int)) return;

    var existingCount = aggregatedApproval.approvalCount;
    var updatedCount = existingCount - numberOfApprovalsProcessed;
    updatedCount > 0 ? aggregatedApproval.setCount(updatedCount) : _approvals.remove(aggregatedApproval);

    _approvals.isNotEmpty ? _view.updateList() : _view.onDidProcessAllApprovals();
  }

  //MARK: Getters

  List<String> getCompanyNames() {
    final companyNames = _approvals.groupListsBy((element) => element.companyName);
    var names = companyNames.keys.toList();
    names.insert(0, "All Companies");
    return names;
  }

  List<String> getModuleNames() {
    var uniqueModules = _approvals.groupListsBy((element) => element.module).keys.toList();
    var names = uniqueModules.map((m) => m.toReadableString()).toList();
    names.insert(0, "All Modules");
    return names;
  }
}
