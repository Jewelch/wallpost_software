import 'package:wallpost/company_core/entities/wp_action.dart';
import 'package:wallpost/company_core/repositories/allowed_actions_repository.dart';
import 'package:wallpost/company_core/services/selected_employee_provider.dart';

class SelectedEmployeeActionsProvider {
  final SelectedEmployeeProvider _selectedEmployeeProvider;
  final AllowedActionsRepository _allowedActionsRepository;

  SelectedEmployeeActionsProvider()
      : _selectedEmployeeProvider = SelectedEmployeeProvider(),
        _allowedActionsRepository = AllowedActionsRepository.getInstance();

  SelectedEmployeeActionsProvider.initWith(this._selectedEmployeeProvider, this._allowedActionsRepository);

  //NOTE: Should only call this function once a company
  //has already be selected. Returning null from this function
  //will mean using the force unwrap operator (!) throughout
  //the app
  List<WPAction> getAllowedActionsForSelectedEmployee() {
    var selectedEmployee = _selectedEmployeeProvider.getSelectedEmployeeForCurrentUser();
    return _allowedActionsRepository.getAllowedActionsForEmployee(selectedEmployee);
  }
}
