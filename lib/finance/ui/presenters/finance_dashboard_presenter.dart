import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/finance/entities/finance_bill_details.dart';
import 'package:wallpost/finance/entities/finance_dashboard_data.dart';
import 'package:wallpost/finance/entities/finance_invoice_details.dart';
import 'package:wallpost/finance/services/finance_dashboard_provider.dart';
import 'package:wallpost/finance/ui/view_contracts/finance_dashboard_view.dart';

import '../../../dashboard/company_dashboard_owner_my_portal/ui/models/owner_dashboard_filters.dart';

class FinanceDashboardPresenter {
  SelectedCompanyProvider _selectedCompanyProvider;

  int _selectedModuleIndex = 0;
  int selectedMonthIndex = 0;
  final FinanceDashBoardView _view;
  final FinanceDashBoardProvider _financeDashBoardProvider;
  var _filters = OwnerDashboardFilters();

  late FinanceDashBoardData _financeDashBoardData;


  FinanceDashboardPresenter(this._view) : _financeDashBoardProvider = FinanceDashBoardProvider(),        _selectedCompanyProvider = SelectedCompanyProvider();

  FinanceDashboardPresenter.initWith(this._view, this._financeDashBoardProvider,this._selectedCompanyProvider);

  //Function to load financial dashboard data

  Future<void> loadFinanceDashBoardDetails() async {
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

  //MARK: Function to set filters and load data

  Future<void> setFilter({required int month, required int year}) {
    _filters.month = month;
    _filters.year = year;
    return loadFinanceDashBoardDetails();
  }

  //MARK: Getters

  get filters => _filters;

  int get selectedMonth => _filters.month;

  int get selectedYear => _filters.year;

  String getProfitAndLossDetails() {
    return _financeDashBoardData.profitAndLoss;
  }

  String getIncomeDetails() {
    return _financeDashBoardData.income;
  }

  String getExpenseDetails() {
    return _financeDashBoardData.expenses;
  }

  String getBankAndCashDetails() {
    return _financeDashBoardData.bankAndCash;
  }

  String getCahInDetails() {
    return _financeDashBoardData.cashIn;
  }

  String getCashOutDetails() {
    return _financeDashBoardData.cashOut;
  }

  FinanceInvoiceDetails? getFinanceInvoiceReport() {
    return _financeDashBoardData.financeInvoiceDetails;
  }

  FinanceBillDetails? getFinanceBillDetails() {
    return _financeDashBoardData.financeBillDetails;
  }

//MARK: Function to initiate filter selection

  void onFiltersGotClicked() {
    _view.showFinanceDashboardFilter();
  }

//MARK: Function to get  monthly chart cash details

  List<String>? getMonthList() {
    List<String>? monthList = _financeDashBoardData.financeCashMonthlyDetails?.months;
    return monthList?.skip(selectedMonthIndex).toList();
  }

  List<String>? getCashInList() {
    List<String>? cashInList = _financeDashBoardData.financeCashMonthlyDetails?.cashIn;
    return cashInList?.skip(selectedMonthIndex).toList();
  }

  List<String>? getCashOutList() {
    List<String>? cashOutList = _financeDashBoardData.financeCashMonthlyDetails?.cashOut;
    return cashOutList?.skip(selectedMonthIndex).toList();
  }

  //MARK: Function to get next monthly cash details

  void onNextTextClick() {
    if (selectedMonthIndex < 9) selectedMonthIndex = selectedMonthIndex + 3;
  }

  //MARK: Function to get previous monthly cash details

  void onPreviousTextClick() {
    if (selectedMonthIndex > 0) selectedMonthIndex = selectedMonthIndex - 3;
  }

  //MARK: Function to set selected module

  void selectModuleAtIndex(int index) {
    _selectedModuleIndex = index;
  }

  int get selectedModuleIndex => _selectedModuleIndex;

  //MARK: Function to get selected month name

  String getSelectedMonthName() {
    var months = AppYears().currentAndPastShortenedMonthsOfYear(selectedYear);
    if (selectedMonth > 0) return months[selectedMonth-1];
    return "YTD";
  }

  //MARK: Function to get selected company name

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

}
