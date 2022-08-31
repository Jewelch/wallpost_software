import "package:collection/collection.dart";

import '../../../../_shared/exceptions/wp_exception.dart';
import '../../entities/aggregated_approval.dart';
import '../../services/aggregated_approvals_list_provider.dart';
import '../view_contracts/aggregated_approvals_list_view.dart';

class AggregatedApprovalsListPresenter {
  final String? companyId;
  final AggregatedApprovalsListView _view;
  final AggregatedApprovalsListProvider _provider;
  List<AggregatedApproval> approvals = [];

  late String _selectedCompanyName;
  late String _selectedModuleName;

  AggregatedApprovalsListPresenter(this._view, {this.companyId}) : _provider = AggregatedApprovalsListProvider();

  AggregatedApprovalsListPresenter.initWith(this._view, this._provider, {this.companyId});

  Future<void> loadApprovalsList() async {
    if (_provider.isLoading) return;

    _view.showLoader();
    _resetFilters();

    try {
      if (companyId == null) {
        approvals = await _provider.getAllApprovals();
      } else {
        approvals = await _provider.getAllApprovals(companyId: companyId);
      }

      if (approvals.isEmpty) {
        _view.showErrorMessage("There are no pending approvals.\n\nTap here to reload.");
        return;
      }

      _view.onDidLoadApprovals();
    } on WPException catch (e) {
      approvals.clear();
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
      _view.onDidLoadApprovals();
    }
  }

  List<AggregatedApproval> _getFilteredApprovals() {
    var filteredList = approvals;
    if (_selectedCompanyName != "All Companies") {
      filteredList = approvals.where((company) => (company.companyName == _selectedCompanyName)).toList();
    }
    if (_selectedModuleName != "All Modules") {
      filteredList = filteredList.where((company) => (company.module == _selectedModuleName)).toList();
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

  //MARK: Getters

  List<String> getCompanyNames() {
    final companyNames = approvals.groupListsBy((element) => element.companyName);
    var names = companyNames.keys.toList();
    names.insert(0, "All Companies");
    return names;
  }

  List<String> getModuleNames() {
    final moduleNames = approvals.groupListsBy((element) => element.module);
    var names = moduleNames.keys.toList();
    names.insert(0, "All Modules");
    return names;
  }
}
