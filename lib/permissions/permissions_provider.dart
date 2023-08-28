import 'package:wallpost/_wp_core/company_management/entities/module.dart';
import 'package:wallpost/_wp_core/company_management/services/selected_company_provider.dart';

import '../_wp_core/company_management/entities/company.dart';

class PermissionsProvider {
  final SelectedCompanyProvider _companyProvider;

  PermissionsProvider() : _companyProvider = SelectedCompanyProvider();

  PermissionsProvider.initWith(this._companyProvider);

  Company get company => _companyProvider.getSelectedCompanyForCurrentUser();

  bool get fullAccessMembers =>
      company.employee.isOwner() || company.employee.isGeneralManager() || company.employee.isWpManager();

  bool shouldShowOwnerDashboard() {
    return fullAccessMembers;
  }

  bool shouldShowManagerDashboard() {
    if (shouldShowOwnerDashboard()) return false;

    return company.employee.isAFinanceManager() ||
        company.employee.isACrmManager() ||
        company.employee.isAHrManager() ||
        company.employee.isARestaurantManager() ||
        company.employee.isARetailManager();
  }

  bool shouldShowEmployeeDashboard() {
    if (shouldShowOwnerDashboard()) return false;
    if (shouldShowManagerDashboard()) return false;

    return true;
  }

  bool canAccessFinanceModule() {
    if (fullAccessMembers) {
      return company.modules.contains(Module.Finance);
    } else {
      return company.employee.isAFinanceManager() || company.employee.isWpFinance() || company.employee.isAccountant();
    }
  }

  bool canAccessCrmModule() {
    if (fullAccessMembers) {
      return company.modules.contains(Module.Crm);
    } else {
      return company.employee.isACrmManager() ||
          company.employee.isWpSalesManager() ||
          company.employee.isWpSalesOfficer();
    }
  }

  bool canAccessHrModule() {
    if (fullAccessMembers) {
      return company.modules.contains(Module.Hr);
    } else {
      return company.employee.isAHrManager();
    }
  }

  bool canAccessRestaurantModule() {
    if (fullAccessMembers) {
      return company.modules.contains(Module.Restaurant);
    } else {
      return company.employee.isARestaurantManager();
    }
  }

  bool canAccessRetailModule() {
    if (fullAccessMembers) {
      return company.modules.contains(Module.Retail);
    } else {
      return company.employee.isARetailManager();
    }
  }
}
