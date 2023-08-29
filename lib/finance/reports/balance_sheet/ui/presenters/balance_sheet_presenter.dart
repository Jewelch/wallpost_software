import 'package:flutter/material.dart';

import '../../../../../_shared/constants/app_colors.dart';
import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/balance_sheet_data.dart';
import '../../entities/balance_sheet_filters.dart';
import '../../services/balance_sheet_provider.dart';
import '../view_contracts/balance_sheet_view.dart';

class BalanceSheetPresenter {
  BalanceSheetView _view;
  BalanceSheetProvider _balanceSheetProvider;
  SelectedCompanyProvider _selectedCompanyProvider;

  late BalanceSheetData balanceSheetReport;

  BalanceSheetPresenter(this._view)
      : _balanceSheetProvider = BalanceSheetProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  BalanceSheetPresenter.initWith(
    this._view,
    this._balanceSheetProvider,
    this._selectedCompanyProvider,
  );

  BalanceSheetReportFilters filters = BalanceSheetReportFilters();

  //MARK: Load balance sheet Data

  Future getBalance() async {
    if (_balanceSheetProvider.isLoading) return;

    _view.showLoader();
    try {
      balanceSheetReport = await _balanceSheetProvider.getBalance(filters.dateFilters);
      _view.onDidLoadBalanceSheet();
    } on WPException catch (e) {
      _view.showErrorMessage(e.userReadableMessage + "\n\nTap here to reload.");
    }
  }

  //MARK: Filtering behavior

  void onFiltersGotClicked() {
    _view.showFilter();
  }

  Future applyFilters(BalanceSheetReportFilters? newFilters) async {
    if (newFilters == null) return;
    var oldFilter = filters;
    filters = newFilters;
    if (newFilters.dateFilters != oldFilter.dateFilters) {
      await getBalance();
    }
  }

  Future resetFilters() async {
    filters.reset();
    await getBalance();
  }

  // UI Getters

  String firstElement() => balanceSheetReport.details.first.name;
  String firstElementValue() => balanceSheetReport.details.first.amount;

  String secondElement() => balanceSheetReport.details[1].name;
  String secondElementValue() => balanceSheetReport.details[1].amount;

  String thirdElement() => balanceSheetReport.details[2].name;
  String thirdElementValue() => balanceSheetReport.details[2].amount;

  String getProfitLossExactTitle() =>
      balanceSheetReport.amounts.firstWhere((element) => element.isProfit).formattedAmount > 0 ? "Profit" : "Loss";

  String getProfit() => balanceSheetReport.amounts.firstWhere((element) => element.isProfit).amount;
  bool isProfit(int index) => balanceSheetReport.amounts[index].isProfit;

  Color getProfitLossBackgroundColor() =>
      balanceSheetReport.amounts.firstWhere((element) => element.isProfit).formattedAmount.isNegative
          ? AppColors.lightRed
          : AppColors.lightGreen;

  Color getProfitLossTextColor() =>
      balanceSheetReport.amounts.firstWhere((element) => element.isProfit).formattedAmount.isNegative
          ? AppColors.red
          : AppColors.green;

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  String getCompanyCurrency() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().currency;
}
