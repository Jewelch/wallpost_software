import 'package:wallpost/_wp_core/company_management/entities/module.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

import '../../../../_wp_core/company_management/entities/company.dart';

class ModulePageViewPresenter {
  final SelectedCompanyProvider _companyProvider;
  late final Company _company;
  int _selectedModuleIndex = 0;

  ModulePageViewPresenter() : this.initWith(SelectedCompanyProvider());

  ModulePageViewPresenter.initWith(this._companyProvider) {
    _company = this._companyProvider.getSelectedCompanyForCurrentUser();
  }

  int getNumberOfModules() {
    return getModuleNames().length;
  }

  bool shouldDisplayModules() {
    return getNumberOfModules() > 0;
  }

  List<Module> getModules() {
    //filter out only those modules that are to be shown in the dashboard
    var allDashboardModules = [Module.Crm, Module.Hr, Module.Restaurant, Module.Retail];
    var modulesToShow = _company.modules.where((m) => allDashboardModules.contains(m)).toList();
    return modulesToShow;
  }

  List<String> getModuleNames() {
    return getModules().map((m) => m.toReadableString()).toList();
  }

  void selectModuleAtIndex(int index) {
    _selectedModuleIndex = index;
  }

  int get selectedModuleIndex => _selectedModuleIndex;
}
