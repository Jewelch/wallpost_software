import 'dart:ui';

import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_shared/extensions/string_extensions.dart';
import 'package:wallpost/finance/entities/finance_dashboard_data.dart';
import 'package:wallpost/finance/services/finance_dashboard_provider.dart';
import 'package:wallpost/finance/ui/models/finance_dashboard_detail.dart';
import 'package:wallpost/finance/ui/view_contracts/finance_dasbooard_view.dart';

class FinanceDasBoardPresenter {
  int _selectedModuleIndex = 0;
  final FinanceDasBoardView _view;
  final FinanceDashBoardProvider _financeDashBoardProvider;

  late FinanceDashBoardData _financeDashBoardData;

  FinanceDasBoardPresenter(this._view) : _financeDashBoardProvider = FinanceDashBoardProvider();

  FinanceDasBoardPresenter.initWith(this._view, this._financeDashBoardProvider);

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

  FinanceDashBoardDetail getProfitAndLossDetails() {
    return FinanceDashBoardDetail(
      label: _financeDashBoardData.profitAndLoss.isNegative? "Loss this Year":"Profit This Year",
      value: _financeDashBoardData.profitAndLoss,
      valueColor: _financeDashBoardData.profitAndLoss.isNegative? _failureValueColor() : _successValueColor(),
      backgroundColor: _financeDashBoardData.profitAndLoss.isNegative? _failureBackgroundColor() : _successBackgroundColor(),
    );
  }

  Color _successValueColor() {
    return AppColors.greenOnDarkDefaultColorBg;
  }

  Color _failureValueColor() {
    return AppColors.redOnDarkDefaultColorBg;
  }

  Color _successBackgroundColor() {
    return AppColors.greenOnDarkDefaultColorBg;
  }

  Color _failureBackgroundColor() {
    return AppColors.redOnDarkDefaultColorBg;
  }

  List<String> getCashInList() {
     List<String> values = <String>['1.2M', '3M', '4M'];

    return values;
  }
  List<String> getCashOutList() {
    List<String> values = <String>['1.2M', '3M', '4M'];

    return values;
  }
  List<String> getMonthList() {
    final List<String> entries = <String>['Jan', 'Feb', 'Mar'];
    return entries;
  }
  void selectModuleAtIndex(int index) {
    _selectedModuleIndex = index;
  }

  int get selectedModuleIndex => _selectedModuleIndex;
}
