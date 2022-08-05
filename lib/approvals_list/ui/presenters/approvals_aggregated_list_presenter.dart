import "package:collection/collection.dart";
import 'package:wallpost/approvals_list/entities/approval_aggregated.dart';
import 'package:wallpost/approvals_list/services/approvals_aggregated_list_provider.dart';
import 'package:wallpost/approvals_list/ui/view_contracts/approvals_list_view.dart';

import '../../../_shared/exceptions/wp_exception.dart';

class ApprovalsListPresenter {
  final ApprovalsListView _view;
  final ApprovalsAggregatedListProvider _provider;
  List<ApprovalAggregated> approvals = [];
  String _errorMessage = "";
  String _moduleKeyFilter = "";
  String _companyKeyFilter = "";

  ApprovalsListPresenter(this._view) : _provider = ApprovalsAggregatedListProvider();

  ApprovalsListPresenter.initWith(this._view, this._provider);

  Future<void> loadApprovalsList() async {
    if (_provider.isLoading) return;
    if (approvals.isEmpty) _view.onLoad();

    try {
      var approvalsList = await _provider.get(null);

      approvals.addAll(approvalsList);
      _resetErrors();

      List<String> companies = _getCompaniesAvailable(approvalsList);
      List<String> modules = _getModulesAvailable(approvalsList);

      _view.onDidLoadCompanies(companies);
      _view.onDidLoadModules(modules);

      showApprovalsList(approvals);
    } on WPException catch (e) {
      approvals.clear();
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _view.showErrorMessage(_errorMessage);
    }
  }

  List<String> _getCompaniesAvailable(List<ApprovalAggregated> approvalsList) {
    final companyNames = approvalsList.groupListsBy((element) => element.companyName);
    var names = companyNames.keys.toList();
    names.insert(0, " All Companies ");
    _companyKeyFilter = names[0];
    return names;
  }

  List<String> _getModulesAvailable(List<ApprovalAggregated> approvalsList) {
    final moduleNames = approvalsList.groupListsBy((element) => element.module);
    var names = moduleNames.keys.toList();
    names.insert(0, " All Modules ");
    _moduleKeyFilter = names[0];
    return names;
  }

  refresh() {
    _provider.reset();
    loadApprovalsList();
  }

  void _resetErrors() {
    _errorMessage = "";
  }

  bool isEmpty() {
    return approvals.isEmpty;
  }

  String get errorMessage => _errorMessage;

  filter(String? module, String? company) {
    if (module != null) {
      _moduleKeyFilter = module;
    }
    if (company != null) {
      _companyKeyFilter = company;
    }
    var filteredList = approvals;
    if (_companyKeyFilter != " All Companies ") {
      filteredList = approvals.where((company) => (company.companyName == _companyKeyFilter)).toList();
    }
    if (_moduleKeyFilter != " All Modules ") {
      filteredList.where((company) => (company.module == _moduleKeyFilter)).toList();
    }
    showApprovalsList(filteredList);
  }

  void showApprovalsList(List<ApprovalAggregated> approvals) {
    if (approvals.isNotEmpty) {
      _view.onDidLoadApprovals(approvals);
    } else {
      _view.showErrorMessage("There are no approvals.\n\nTap here to reload.");
    }
  }
}
