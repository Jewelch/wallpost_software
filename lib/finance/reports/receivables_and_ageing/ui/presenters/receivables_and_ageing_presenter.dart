import 'package:flutter/material.dart';

import '../../../../../_shared/constants/app_colors.dart';
import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/receivables_and_ageing_data.dart';
import '../../services/receivables_and_ageing_provider.dart';
import '../view_contracts/receivables_and_ageing_view.dart';

class ReceivablesPresenter {
  ReceivablesView _view;
  ReceivablesProvider _provider;
  SelectedCompanyProvider _selectedCompanyProvider;

  late ReceivablesData receivablesReport;

  ReceivablesPresenter(this._view)
      : _provider = ReceivablesProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  ReceivablesPresenter.initWith(
    this._view,
    this._provider,
    this._selectedCompanyProvider,
  );

  //MARK: Load receivable report Data

  Future getReceivables() async {
    if (_provider.isLoading) return;

    _view.showLoader();
    try {
      receivablesReport = await _provider.getReceivables();
      _view.onDidLoadReceivables();
    } on WPException catch (e) {
      _view.showErrorMessage(e.userReadableMessage + "\n\nTap here to reload.");
    }
  }

  // UI Getters

  Color getOverDueTextColor(String text) =>
      (num.tryParse(text.replaceAll(",", '')) ?? 0) > 0 ? AppColors.red : AppColors.yellow;

  String getSelectedCompanyName() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().name;

  String getCompanyCurrency() => _selectedCompanyProvider.getSelectedCompanyForCurrentUser().currency;
}
