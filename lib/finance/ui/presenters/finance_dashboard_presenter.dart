import 'dart:ui';

import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/string_extensions.dart';
import 'package:wallpost/finance/entities/finance_dashboard_data.dart';
import 'package:wallpost/finance/services/finance_dashboard_provider.dart';
import 'package:wallpost/finance/ui/models/finance_dashboard_detail.dart';
import 'package:wallpost/finance/ui/models/finance_filter_data.dart';
import 'package:wallpost/finance/ui/view_contracts/finance_dasbooard_view.dart';

class FinanceDasBoardPresenter {
  final FinanceDasBoardView _view;
  final FinanceDashBoardProvider _financeDashBoardProvider;
  FinanceFilterData dateFilters;

  late FinanceDashBoardData _financeDashBoardData;

  FinanceDasBoardPresenter(this._view) :
        _financeDashBoardProvider = FinanceDashBoardProvider(), dateFilters = FinanceFilterData();

  FinanceDasBoardPresenter.initWith(this._view, this._financeDashBoardProvider,this.dateFilters);

  //Function to load financial dashboard data

  Future<void> loadFinanceDashBoardDetails() async {
    if (_financeDashBoardProvider.isLoading) return;

    _view.showLoader();
    try {
      _financeDashBoardData = await _financeDashBoardProvider.get();
      _view.onDidLoadFinanceDashBoardData();
    } on WPException {
      _view.showErrorAndRetryView("Failed to load finance details.\nTap here to reload.");
    }
  }


  //MARK: Functions to get financial profit and loss details

  // FinanceDashBoardDetail getProfitAndLossDetails() {
  //   return FinanceDashBoardDetail(
  //     label: _financeDashBoardData.profitAndLoss.isNegative? "Loss this Year":"Profit This Year",
  //     value: _financeDashBoardData.profitAndLoss,
  //     valueColor: _financeDashBoardData.profitAndLoss.isNegative? _failureValueColor() : _successValueColor(),
  //     backgroundColor: _financeDashBoardData.profitAndLoss.isNegative? _failureBackgroundColor() : _successBackgroundColor(),
  //   );
  // }

  String getProfitAndLossDetails(){
    return _financeDashBoardData.profitAndLoss;
  }
  String getIncomeDetails(){
    return _financeDashBoardData.income;
  }
  String getExpenseDetails(){
    return _financeDashBoardData.expenses;
  }

//MARK: Function to initiate filter selection

  void onFiltersGotClicked() {
    _view.showFinanceDashboardFilter();
  }

}
