import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/profit_loss_model.dart';
import '../../entities/profit_loss_report_filters.dart';
import '../../services/profit_loss_provider.dart';
import '../view_contracts/profit_loss_view.dart';

class ProfitsLossesPresenter {
  final ProfitsLossesView _view;
  final ProfitsLossesProvider _profitLossDataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;

  late ProfitsLossesReport profitLossReport;

  ProfitsLossesPresenter(this._view)
      : _profitLossDataProvider = ProfitsLossesProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  ProfitsLossesReportFilters filters = ProfitsLossesReportFilters();

  ProfitsLossesPresenter.initWith(
    this._view,
    this._profitLossDataProvider,
    this._selectedCompanyProvider,
  );

  loadProfitsLossesData() async {
    if (_profitLossDataProvider.isLoading) return;

    _view.showLoader();
    try {
      var dateFilters = filters.dateFilters;
      profitLossReport = await _profitLossDataProvider.getProfitsLosses(dateFilters);
      _view.onDidLoadReport();
    } on WPException catch (e) {
      _view.showErrorMessage("${e.userReadableMessage}\n\nTap here to reload.");
    }
  }

  //MARK: Function to apply Filters

  Future applyFilters(ProfitsLossesReportFilters? newFilters) async {
    if (newFilters == null) return;
    var oldFilter = filters;
    filters = newFilters;
    print(newFilters.dateFilters.selectedRangeOption);
    print(oldFilter.dateFilters.selectedRangeOption);
    if (newFilters.dateFilters != oldFilter.dateFilters) {
      await loadProfitsLossesData();
    }
  }

  void onFiltersGotClicked() {
    _view.showFilter();
  }

  Future resetFilters() async {
    filters.reset();
    await loadProfitsLossesData();
  }

  // Getters

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  String getCompanyCurrency() {
    return _selectedCompanyProvider.getSelectedCompanyForCurrentUser().currency;
  }

  String getNetProfit() => profitLossReport.netProfit.amount;

  String getNetSaleTitle() => profitLossReport.netProfit.formattedAmount > 0 ? "Net Profit" : "Net Loss";

  Color getNetSaleColor() =>
      profitLossReport.netProfit.formattedAmount >= 0 ? AppColors.lightGreen : AppColors.lightRed;
  Color getNetSaleTextColor() =>
      profitLossReport.netProfit.formattedAmount >= 0 ? AppColors.brightGreen : AppColors.red;
}
