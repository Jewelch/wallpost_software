import 'package:flutter/material.dart';

import '../../../../../_shared/constants/app_colors.dart';
import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_shared/extensions/string_extensions.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/balance_sheet_data.dart';
import '../../entities/profit_loss_report_filters.dart';
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

  //MARK: Load Aggregated Sales Data

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

  void onFiltersGotClicked() {
    _view.showFilter();
  }

  //MARK: Function to apply Filters

  Future applyFilters(BalanceSheetReportFilters? newFilters) async {
    if (newFilters == null) return;
    var oldFilter = filters;
    filters = newFilters;
    print(newFilters.dateFilters.selectedRangeOption);
    print(oldFilter.dateFilters.selectedRangeOption);
    if (newFilters.dateFilters != oldFilter.dateFilters) {
      await getBalance();
    }
  }

  Future resetFilters() async {
    filters.reset();
    await getBalance();
  }

  //MARK: Aggregated sales data getters

  // String getTotalSales() => _salesData?.totalSales ?? "0.00";
  String getTotalSales() => "0.00";

  String getNetSale() => "0.00";

  String getCostOfSales() => "0.00";

  String getGrossProfit() => "0.00";

  Color getGrossProfitBackgroundColor() => "10.00".isNegative ? AppColors.lightRed : AppColors.lightGreen;

  Color getGrossProfitTextColor() => "10.00".isNegative ? AppColors.red : AppColors.green;

  // Getters

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  String getCompanyCurrency() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().currency;

  String getAssetsAmount() => balanceSheetReport.assets.amount;

  String getProfitLossExactTitle() => balanceSheetReport.profitLossAccount.formattedAmount > 0 ? "Profit" : "Loss";
}
