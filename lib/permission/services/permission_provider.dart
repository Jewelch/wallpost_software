import 'package:wallpost/company_list/services/selected_company_provider.dart';
import 'package:wallpost/company_list/services/selected_employee_provider.dart';
import 'package:wallpost/permission/entities/permissions.dart';
import 'package:wallpost/permission/repositories/wp_actions_repository.dart';

class PermissionProvider {
  SelectedCompanyProvider _companyProvider;
  SelectedEmployeeProvider _employeeProvider;
  WpActionsRepository _requestItemsRepository;

  PermissionProvider.initWith(this._companyProvider, this._employeeProvider, this._requestItemsRepository);

  PermissionProvider()
      : _employeeProvider = SelectedEmployeeProvider(),
        _companyProvider = SelectedCompanyProvider(),
        _requestItemsRepository = WpActionsRepository();

  Future<Permissions> getPermissions() async {
    var company = _companyProvider.getSelectedCompanyForCurrentUser();
    var employee = _employeeProvider.getSelectedEmployeeForCurrentUser();
    var allowedActions = await _requestItemsRepository.getActionsForEmployee(company.id);
    return Permissions.initWith(company, employee, allowedActions);
  }
}
