import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/company_management/entities/financial_summary.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/models/manager_dashboard_filters.dart';
import 'package:wallpost/dashboard/company_dashboard_manager_my_portal/ui/view_contracts/module_performance_view.dart';

import '../../services/finance_dashboard_data_provider.dart';
import '../models/performance_value.dart';

class FinancePerformancePresenter {
  final ModulePerformanceView _view;
  final ManagerDashboardFilters _filters;
  final FinanceDashboardDataProvider _financeDataProvider;
  final SelectedCompanyProvider _selectedCompanyProvider;
  FinancialSummary? _financeData;
  String _errorMessage = "";

  FinancePerformancePresenter(this._view, this._filters)
      : _financeDataProvider = FinanceDashboardDataProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  FinancePerformancePresenter.initWith(
    this._view,
    this._filters,
    this._financeDataProvider,
    this._selectedCompanyProvider,
  );

  Future<void> loadData() async {
    if (_financeDataProvider.isLoading) return;

    _resetErrors();
    _financeData == null ? _view.showLoader() : _view.onDidLoadData();
    try {
      _financeData = await _financeDataProvider.get(month: _filters.month, year: _filters.year);
      _view.onDidLoadData();
    } on WPException catch (e) {
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _view.showErrorMessage();
    }
  }

  void _resetErrors() {
    _errorMessage = "";
  }

  //MARK: Getters

  PerformanceValue getProfitLoss() {
    return PerformanceValue(
      label: "Profit & Loss (${_financeData!.currency})",
      value: _financeData!.profitLoss,
      textColor: _financeData!.isInProfit() ? _successColor() : _failureColor(),
    );
  }

  PerformanceValue getAvailableFunds() {
    return PerformanceValue(
      label: "Available\nFunds",
      value: _financeData!.availableFunds,
      textColor: _financeData!.areFundsAvailable() ? _successColor() : _failureColor(),
    );
  }

  PerformanceValue getOverdueReceivables() {
    return PerformanceValue(
      label: "Receivables\nOverdue",
      value: _financeData!.receivableOverdue,
      textColor: _financeData!.areReceivablesOverdue() ? _failureColor() : _successColor(),
    );
  }

  PerformanceValue getOverduePayables() {
    return PerformanceValue(
      label: "Payables\nOverdue",
      value: _financeData!.payableOverdue,
      textColor: _financeData!.arePayablesOverdue() ? _failureColor() : _successColor(),
    );
  }

  Color _successColor() {
    return AppColors.greenOnDarkDefaultColorBg;
  }

  Color _failureColor() {
    return AppColors.redOnDarkDefaultColorBg;
  }

  String get errorMessage => _errorMessage;

  bool shouldShowDetailDisclosureIndicator() {
    if (_selectedCompanyProvider.isCompanySelected()) return true;
    return false;
  }
}
