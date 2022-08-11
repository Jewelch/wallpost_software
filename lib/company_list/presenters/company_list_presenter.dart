import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/user_management/services/current_user_provider.dart';
import 'package:wallpost/company_core/entities/company_list.dart';
import 'package:wallpost/company_core/entities/company_list_item.dart';
import 'package:wallpost/company_core/entities/financial_summary.dart';
import 'package:wallpost/company_core/services/company_list_provider.dart';
import 'package:wallpost/company_list/models/financial_details.dart';
import 'package:wallpost/company_list/view_contracts/company_list_view.dart';

import '../../company_core/entities/company_group.dart';

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
      _view.updateCompanyList();
    } else {
      _view.showErrorMessage("There are no companies.\n\nTap here to reload.");
    }
  }

  List<CompanyListItem> _getFilteredCompanies() {
    var allCompanies = _companyList.companies;
    var companyIdsFilteredByGroup = _selectedGroup?.companyIds ?? allCompanies.map((c) => c.id).toList();
    var companiesFilteredByGroup = allCompanies.where((c) => companyIdsFilteredByGroup.contains(c.id)).toList();
    var companiesFilteredBySearchText = companiesFilteredByGroup.where((c) {
      return c.name.toLowerCase().contains(_searchText.toLowerCase());
    }).toList();

    return companiesFilteredBySearchText;
  }

  FinancialSummary? _getFilteredFinancialSummary() {
    FinancialSummary? summaryToShow;
    if (_selectedGroup != null && _selectedGroup?.financialSummary != null) {
      summaryToShow = _selectedGroup?.financialSummary;
    } else if (_companyList.financialSummary != null) {
      summaryToShow = _companyList.financialSummary;
    }

    if (_companyList.shouldShowFinancialData() && summaryToShow != null) {
      return summaryToShow;
    } else {
      return null;
    }
  }

  //MARK: Function to refresh the company list

  refresh() {
    _clearFilters();
    loadCompanies();
  }

  //MARK: Functions to perform search

  void performSearch(String searchText) {
    _searchText = searchText;
    _view.updateCompanyList();
  }

  //MARK: Functions to select and deselect company group filter

  void selectGroupAtIndex(int index) {
    _selectedGroup = _companyList.groups[index];
    _view.updateCompanyList();
  }

  void clearGroupSelection() {
    _selectedGroup = null;
    _view.updateCompanyList();
  }

  //MARK: Functions to clear filters

  void clearFiltersAndUpdateViews() {
    _clearFilters();
    _view.updateCompanyList();
  }

  void _clearFilters() {
    _searchText = "";
    _selectedGroup = null;
  }

  //MARK: Functions to perform selections

  void selectCompany(CompanyListItem company) async {
    _view.goToCompanyDetailScreen(company);
  }

  void showAggregatedApprovals() {
    _view.goToApprovalsListScreen();
  }

  //MARK: Functions to get number of rows and items

  int getNumberOfRows() {
    if (_getFilteredCompanies().isEmpty) return 0;

    if (_getFilteredFinancialSummary() != null)
      return _getFilteredCompanies().length + 1;
    else
      return _getFilteredCompanies().length;
  }

  dynamic getItemAtIndex(int index) {
    if (_getFilteredFinancialSummary() != null) {
      if (index == 0)
        return _getFilteredFinancialSummary();
      else
        return _getFilteredCompanies()[index - 1];
    } else {
      return _getFilteredCompanies()[index];
    }
  }

  //MARK: Functions to get financial details

  FinancialDetails getProfitLossDetails(FinancialSummary? financialSummary, {bool isForHeaderCard = false}) {
    if (financialSummary == null) return _emptyFinancialDetails();

    return FinancialDetails.name(
      label: "Profit & Loss",
      value: financialSummary.profitLoss,
      textColor: _isLessThanZero(financialSummary.profitLoss)
          ? _failureColor(isForHeaderCard)
          : _successColor(isForHeaderCard),
    );
  }

  FinancialDetails getAvailableFundsDetails(FinancialSummary? financialSummary, {bool isForHeaderCard = false}) {
    if (financialSummary == null) return _emptyFinancialDetails();

    return FinancialDetails.name(
      label: "Available Funds",
      value: financialSummary.availableFunds,
      textColor: _isLessThanZero(financialSummary.availableFunds) ||
              _isZero(financialSummary.currency, financialSummary.availableFunds)
          ? _failureColor(isForHeaderCard)
          : _successColor(isForHeaderCard),
    );
  }

  FinancialDetails getOverdueReceivablesDetails(FinancialSummary? financialSummary, {bool isForHeaderCard = false}) {
    if (financialSummary == null) return _emptyFinancialDetails();

    return FinancialDetails.name(
      label: "Receivables Overdue",
      value: financialSummary.receivableOverdue,
      textColor: _isGreaterThanZero(financialSummary.currency, financialSummary.receivableOverdue)
          ? _failureColor(isForHeaderCard)
          : _successColor(isForHeaderCard),
    );
  }

  FinancialDetails getOverduePayablesDetails(FinancialSummary? financialSummary, {bool isForHeaderCard = false}) {
    if (financialSummary == null) return _emptyFinancialDetails();

    return FinancialDetails.name(
      label: "Payables Overdue",
      value: financialSummary.payableOverdue,
      textColor: _isGreaterThanZero(financialSummary.currency, financialSummary.payableOverdue)
          ? _failureColor(isForHeaderCard)
          : _successColor(isForHeaderCard),
    );
  }

  FinancialDetails _emptyFinancialDetails() {
    return FinancialDetails.name(label: "", value: "", textColor: Colors.transparent);
  }

  bool _isZero(String currency, String value) {
    return value == currency + " 0";
  }

  bool _isLessThanZero(String value) {
    return value.contains("-");
  }

  bool _isGreaterThanZero(String currency, String value) {
    return !(_isLessThanZero(value) || _isZero(currency, value));
  }

  Color _successColor(bool isForHeaderCard) {
    return isForHeaderCard ? AppColors.headerCardSuccessColor : AppColors.successColor;
  }

  Color _failureColor(bool isForHeaderCard) {
    return isForHeaderCard ? AppColors.headerCardFailureColor : AppColors.failureColor;
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
