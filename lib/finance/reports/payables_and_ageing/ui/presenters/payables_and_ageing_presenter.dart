import 'package:flutter/material.dart';

import '../../../../../_shared/constants/app_colors.dart';
import '../../../../../_shared/exceptions/wp_exception.dart';
import '../../../../../_wp_core/company_management/services/selected_company_provider.dart';
import '../../entities/payables_and_ageing_data.dart';
import '../../services/payables_and_ageing_provider.dart';
import '../view_contracts/payables_and_ageing_view.dart';

class PayablesPresenter {
  PayablesView _view;
  PayablesProvider _provider;
  SelectedCompanyProvider _selectedCompanyProvider;

  late PayablesData payablesReport;

  PayablesPresenter(this._view)
      : _provider = PayablesProvider(),
        _selectedCompanyProvider = SelectedCompanyProvider();

  PayablesPresenter.initWith(
    this._view,
    this._provider,
    this._selectedCompanyProvider,
  );

  //MARK: Load Payables report Data

  Future getPayables() async {
    if (_provider.isLoading) return;

    _view.showLoader();
    try {
      payablesReport = await _provider.getPayables();
      _view.onDidLoadPayables();
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
