import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/company_core/entities/company_list.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';
import 'package:wallpost/company_core/services/company_list_provider.dart';
import 'package:wallpost/company_list/view_contracts/company_list_view.dart';

import '../../company_core/entities/company_group.dart';
import '../../company_core/services/company_details_provider.dart';

class CompanyListPresenter {
  final CompaniesListView _view;
  final CurrentUserProvider _currentUserProvider;
  final CompanyListProvider _companyListProvider;
  late CompanyList _companyList;
  var _searchText = "";
  CompanyGroup? _selectedGroup;

  CompanyListPresenter(this._view)
      : _currentUserProvider = CurrentUserProvider(),
        _companyListProvider = CompanyListProvider();

  CompanyListPresenter.initWith(
    this._view,
    this._currentUserProvider,
    this._companyListProvider,
  );

  //MARK: Functions to load company list

  Future<void> loadCompanies() async {
    if (_companyListProvider.isLoading) return;

    _clearFilters();
    _view.showLoader();

    try {
      var companyList = await _companyListProvider.get();
      _handleResponse(companyList);
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  void _handleResponse(CompanyList companyList) {
    _companyList = companyList;
    if (_companyList.companies.isNotEmpty) {
      _view.onDidLoadData();
      _updateFinancialDataView();
      _showFilteredCompanies();
    } else {
      _view.showErrorMessage("There are no companies.\n\nTap here to reload.");
    }
  }

  void _updateFinancialDataView() {
    FinancialSummary? summaryToShow;
    if (_selectedGroup != null && _selectedGroup?.financialSummary != null) {
      summaryToShow = _selectedGroup?.financialSummary;
    } else if (_companyList.financialSummary != null) {
      summaryToShow = _companyList.financialSummary;
    }

    if (_shouldShowFinancialData() && summaryToShow != null) {
      _view.updateFinancialSummary(summaryToShow);
    } else {
      _view.updateFinancialSummary(null);
    }
  }

  bool _shouldShowFinancialData() {
    //checking if at least one company has financial data
    //if no company has financial data, then hide the financial summary
    if (_companyList.companies.where((c) => c.financialSummary != null).toList().length > 0) {
      return true;
    } else {
      return false;
    }
  }

  void _showFilteredCompanies() {
    var allCompanies = _companyList.companies;
    var companyIdsFilteredByGroup = _selectedGroup?.companyIds ?? allCompanies.map((c) => c.id).toList();
    var companiesFilteredByGroup = allCompanies.where((c) => companyIdsFilteredByGroup.contains(c.id)).toList();
    var companiesFilteredBySearchText = companiesFilteredByGroup.where((c) {
      return c.name.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    var filteredCompanies = companiesFilteredBySearchText;
    _view.updateCompanyList(filteredCompanies);
  }

  //MARK: Function to refresh the company list

  refresh() {
    _clearFilters();
    _companyListProvider.reset();
    loadCompanies();
  }

  //MARK: Functions to perform search

  void performSearch(String searchText) {
    _searchText = searchText;
    _showFilteredCompanies();
  }

  //MARK: Functions to select and deselect company group filter

  void selectGroupAtIndex(int index) {
    _selectedGroup = _companyList.groups[index];
    _updateFinancialDataView();
    _showFilteredCompanies();
  }

  void clearGroupSelection() {
    _selectedGroup = null;
    _updateFinancialDataView();
    _showFilteredCompanies();
  }

  //MARK: Functions to clear filters

  void clearFiltersAndUpdateViews() {
    _clearFilters();
    _updateFinancialDataView();
    _showFilteredCompanies();
  }

  void _clearFilters() {
    _searchText = "";
    _selectedGroup = null;
  }

  selectCompany(CompanyListItem company) async {
      _view.goToCompanyDetailScreen(company.id);
  }

  //MARK: Getters

  String getProfileImageUrl() {
    return _currentUserProvider.getCurrentUser().profileImageUrl;
  }

  String getSearchText() {
    return _searchText;
  }

  List<CompanyGroup> getCompanyGroups() {
    return _companyList.groups;
  }

  bool shouldShowCompanyGroupsFilter() {
    return _companyList.groups.isNotEmpty;
  }

  int getApprovalCount() {
    num approvalCount = 0;
    for (var i = 0; i < _companyList.companies.length; i++) {
      approvalCount += _companyList.companies[i].approvalCount;
    }
    return approvalCount.toInt();
  }
}
