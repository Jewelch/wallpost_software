import 'package:wallpost/_wp_core/company_management/entities/module.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

class PermissionsProvider {
  final SelectedCompanyProvider _companyProvider;

  PermissionsProvider() : _companyProvider = SelectedCompanyProvider();

  PermissionsProvider.initWith(this._companyProvider);

  bool shouldShowOwnerDashboard() {
    var company = _companyProvider.getSelectedCompanyForCurrentUser();
    return company.employee.isOwner() || company.employee.isGM();
  }

  bool shouldShowManagerDashboard() {
    if (shouldShowOwnerDashboard()) return false;

    var company = _companyProvider.getSelectedCompanyForCurrentUser();
    return company.employee.isAFinanceManager() ||
        company.employee.isACrmManager() ||
        company.employee.isAHrManager() ||
        company.employee.isARestaurantManager() ||
        company.employee.isARetailManager();
  }

  bool canAccessFinanceModule() {
    var company = _companyProvider.getSelectedCompanyForCurrentUser();
    if (company.employee.isOwner() || company.employee.isGM()) {
      return company.modules.contains(Module.Finance);
    } else {
      return company.employee.isAFinanceManager();
    }
  }

  bool canAccessCrmModule() {
    var company = _companyProvider.getSelectedCompanyForCurrentUser();
    if (company.employee.isOwner() || company.employee.isGM()) {
      return company.modules.contains(Module.Crm);
    } else {
      return company.employee.isACrmManager();
    }
  }

  bool canAccessHrModule() {
    var company = _companyProvider.getSelectedCompanyForCurrentUser();
    if (company.employee.isOwner() || company.employee.isGM()) {
      return company.modules.contains(Module.Hr);
    } else {
      return company.employee.isAHrManager();
    }
  }

  bool canAccessRestaurantModule() {
    var company = _companyProvider.getSelectedCompanyForCurrentUser();
    if (company.employee.isOwner() || company.employee.isGM()) {
      return company.modules.contains(Module.Restaurant);
    } else {
      return company.employee.isARestaurantManager();
    }
  }

  bool canAccessRetailModule() {
    var company = _companyProvider.getSelectedCompanyForCurrentUser();
    if (company.employee.isOwner() || company.employee.isGM()) {
      return company.modules.contains(Module.Retail);
    } else {
      return company.employee.isARetailManager();
    }
  }
}
