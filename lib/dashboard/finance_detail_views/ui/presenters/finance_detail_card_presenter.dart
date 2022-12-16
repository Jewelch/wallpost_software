import 'package:flutter/material.dart';
import 'package:wallpost/_wp_core/company_management/entities/financial_summary.dart';
import 'package:wallpost/dashboard/finance_detail_views/ui/models/finance_detail.dart';

import '../../../../_shared/constants/app_colors.dart';
import '../../../../_wp_core/company_management/services/selected_company_provider.dart';

class FinanceDetailCardPresenter {
  final FinancialSummary _summary;

  FinanceDetailCardPresenter(this._summary);

  //MARK: Functions to get financial details

  FinanceDetail getProfitLossDetails() {
    return FinanceDetail(
      label: "Profit & Loss",
      value: _summary.profitLoss,
      valueColor: _summary.isInProfit() ? _successColor() : _failureColor(),
    );
  }

  FinanceDetail getAvailableFundsDetails() {
    return FinanceDetail(
      label: "Available\nFunds",
      value: _summary.availableFunds,
      valueColor: _summary.areFundsAvailable() ? _successColor() : _failureColor(),
    );
  }

  FinanceDetail getOverdueReceivablesDetails() {
    return FinanceDetail(
      label: "Receivables\nOverdue",
      value: _summary.receivableOverdue,
      valueColor: _summary.areReceivablesOverdue() ? _failureColor() : _successColor(),
    );
  }

  FinanceDetail getOverduePayablesDetails() {
    return FinanceDetail(
      label: "Payables\nOverdue",
      value: _summary.payableOverdue,
      valueColor: _summary.arePayablesOverdue() ? _failureColor() : _successColor(),
    );
  }

  Color _successColor() {
    return AppColors.greenOnDarkDefaultColorBg;
  }

  Color _failureColor() {
    return AppColors.redOnDarkDefaultColorBg;
  }

  String getCurrency() {
    return "(${_summary.currency})";
  }

  bool isCompanySelected() {
    if (SelectedCompanyProvider().isCompanySelected()) return true;
    return false;
  }
}
