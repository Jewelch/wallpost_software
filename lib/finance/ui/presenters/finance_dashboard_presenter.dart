import 'dart:ui';

import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/finance/entities/finance_bill_details.dart';
import 'package:wallpost/finance/entities/finance_dashboard_data.dart';
import 'package:wallpost/finance/entities/finance_invoice_details.dart';
import 'package:wallpost/finance/services/finance_dashboard_provider.dart';
import 'package:wallpost/finance/ui/models/finance_dashboard_value.dart';
import 'package:wallpost/finance/ui/models/finance_initail_filter_data.dart';
import 'package:wallpost/finance/ui/view_contracts/finance_dashboard_view.dart';

import '../../../_shared/constants/app_years.dart';
import '../../../_wp_core/company_management/entities/company.dart';

class FinanceDashboardPresenter {
  SelectedCompanyProvider _selectedCompanyProvider;

  int _selectedModuleIndex = 0;
  int selectedMonthIndex = 0;
  final FinanceDashBoardView _view;
  final FinanceDashBoardProvider _financeDashBoardProvider;
  var _filters = FinanceInitialFilterData();

  late FinanceDashBoardData _financeDashBoardData;

  FinanceDashboardPresenter(this._view)
      : _financeDashBoardProvider = FinanceDashBoardProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  FinanceDashboardPresenter.initWith(this._view, this._financeDashBoardProvider, this._selectedCompanyProvider);

  //Function to load financial dashboard data

  Future<void> loadFinanceDashBoardDetails() async {
    _selectedModuleIndex=0;

    if (_financeDashBoardProvider.isLoading) return;

    _view.showLoader();
    try {
      _financeDashBoardData = await _financeDashBoardProvider.get(
        month: _filters.month == 0 ? null : _filters.month,
        year: _filters.year,
      );
      _view.onDidLoadFinanceDashBoardData();
    } on WPException {
      _view.showErrorAndRetryView("Failed to load finance details.\nTap here to reload.");
    }
  }

  //MARK: Function to get  monthly chart cash details

  List<String> getMonthList() {
    List<String> monthList = _financeDashBoardData.monthsList;
    return monthList.skip(selectedMonthIndex).toList();
  }

  List<String> getCashInList() {
    List<String> cashInList = _financeDashBoardData.cashInList;
    return cashInList.skip(selectedMonthIndex).toList();
  }

  List<String> getCashOutList() {
    List<String> cashOutList = _financeDashBoardData.cashOutList;
    return cashOutList.skip(selectedMonthIndex).toList();
  }

  //MARK: Function to get next and previous month cash details

  void onNextTextClick() {
    if (selectedMonthIndex < 9) selectedMonthIndex = selectedMonthIndex + 3;
  }

  void onPreviousTextClick() {
    if (selectedMonthIndex > 0) selectedMonthIndex = selectedMonthIndex - 3;
  }

  //MARK: Function to set and get filters

  void initiateFilterSelection() {
    _view.showFilters();
  }

  Future<void> setFilter({required int month, required int year}) {
    _filters.month = month;
    _filters.year = year;
    return loadFinanceDashBoardDetails();
  }

  void selectModuleAtIndex(int index) {
    _selectedModuleIndex = index;
  }

  int get selectedMonth => _filters.month;

  int get selectedYear => _filters.year;

  int get selectedModuleIndex => _selectedModuleIndex;

  //MARK: Getters

  Company getSelectedCompany() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser();

  FinanceDashBoardValue getProfitAndLoss() {
    return FinanceDashBoardValue(
      label: _financeDashBoardData.isInProfit() ? "Profit This Year":"Loss This Year",
      value: _financeDashBoardData.profitAndLoss,
      valueColor:  _financeDashBoardData.isInProfit() ? _successColor() : _failureColor(),
    );
  }

  FinanceDashBoardValue getIncome() {
    return FinanceDashBoardValue(
      label:  "Income",
      value: _financeDashBoardData.income,
      valueColor: _successColor(),
    );
  }

  FinanceDashBoardValue getExpenses() {
    return FinanceDashBoardValue(
      label:  "Expense",
      value: _financeDashBoardData.expenses,
      valueColor: _failureColor(),
    );
  }

  FinanceDashBoardValue getCashInBank() {
    return FinanceDashBoardValue(
      label: "Available Balance In Bank/Cash",
      value: _financeDashBoardData.bankAndCash,
      valueColor:  _financeDashBoardData.isProfitCashInBank() ? _successColor() : _failureColor(),
    );
  }

  String getCashIn() {
    return _financeDashBoardData.cashIn;
  }

  String getCashOut() {
    return _financeDashBoardData.cashOut;
  }

  FinanceInvoiceDetails? getFinanceInvoiceReport() {
    return _financeDashBoardData.financeInvoiceDetails;
  }

  FinanceBillDetails? getFinanceBillDetails() {
    return _financeDashBoardData.financeBillDetails;
  }

  Color profitLossBoxColor(){
    return _financeDashBoardData.isInProfit() ? _successBoxColor() : _failureBoxColor();
  }

  Color _successColor() {
    return AppColors.green;
  }

  Color _failureColor() {
    return AppColors.red;
  }

  Color _successBoxColor() {
    return AppColors.lightGreen;
  }

  Color _failureBoxColor() {
    return AppColors.lightRed;
  }

  List<String> getMonthNamesForSelectedYear(int _selectedYear) {
    var years = AppYears().currentAndPastShortenedMonthsOfYear(_selectedYear);
    return years;
  }
  int getMonthCountForTheSelectedYear(int _selectedYear){
    var monthCount = AppYears().currentAndPastShortenedMonthsOfYear(_selectedYear).length;
    return monthCount;

  }
}
