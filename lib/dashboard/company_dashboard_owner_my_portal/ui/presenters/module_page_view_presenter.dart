import 'package:wallpost/_wp_core/company_management/entities/module.dart';
import 'package:wallpost/permissions/permissions_provider.dart';

class ModulePageViewPresenter {
  final PermissionsProvider _permissionsProvider;
  int _selectedModuleIndex = 0;

  ModulePageViewPresenter() : this.initWith(PermissionsProvider());

  ModulePageViewPresenter.initWith(this._permissionsProvider);

  bool shouldDisplayModules() {
    return getNumberOfModules() > 0;
  }

  List<Module> getAllDashboardModules() {
    //modules that are to be shown in the dashboard
    return [Module.Crm, Module.Hr, Module.Restaurant, Module.Retail];
  }

  int getNumberOfModules() {
    return getModuleNames().length;
  }

  List<Module> getModules() {
    var allDashboardModules = getAllDashboardModules();
    List<Module> allowedModules = [];
    if (_permissionsProvider.canAccessCrmModule()) allowedModules.add(Module.Crm);
    if (_permissionsProvider.canAccessHrModule()) allowedModules.add(Module.Hr);
    if (_permissionsProvider.canAccessRestaurantModule()) allowedModules.add(Module.Restaurant);
    if (_permissionsProvider.canAccessRetailModule()) allowedModules.add(Module.Retail);

    var modulesToShow = allDashboardModules.where((m) => allowedModules.contains(m));
    return modulesToShow.toList();
  }

  List<String> getModuleNames() {
    return getModules().map((m) => m.toReadableString()).toList();
  }

  void selectModuleAtIndex(int index) {
    _selectedModuleIndex = index;
  }

  int get selectedModuleIndex => _selectedModuleIndex;
}
