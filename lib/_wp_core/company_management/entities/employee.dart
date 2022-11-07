import 'package:sift/sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/_wp_core/company_management/entities/role.dart';
import 'package:wallpost/_wp_core/company_management/entities/wp_action.dart';

class Employee extends JSONInitializable {
  late String _v1Id;
  late String _v2Id;
  late String _employeeName;
  late String _employeeEmail;
  late String _designation;
  late List<Role> _roles;
  late String? _lineManager;
  late List<WPAction> _allowedActions;

  Employee.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var employeeMap = sift.readMapFromMap(jsonMap, 'employee');
      var allowedActionsMapList = sift.readMapListFromMap(jsonMap, 'request_items');
      _v1Id = '${sift.readNumberFromMap(employeeMap, 'employment_id_v1')}';
      _v2Id = sift.readStringFromMap(employeeMap, 'employment_id');
      _employeeName = sift.readStringFromMap(employeeMap, 'name');
      _employeeEmail = sift.readStringFromMap(employeeMap, 'email_id_office');
      _designation = sift.readStringFromMap(employeeMap, 'designation');
      var roleStrings = sift.readStringListFromMap(employeeMap, "Roles");
      _roles = _initRoles(roleStrings);
      _lineManager = sift.readStringFromMapWithDefaultValue(employeeMap, 'line_manager', null);
      _allowedActions = _initAllowedActions(allowedActionsMapList);
    } on SiftException catch (e) {
      throw MappingException('Failed to cast Employee response. Error message - ${e.errorMessage}');
    } on MappingException {
      rethrow;
    }
  }

  List<Role> _initRoles(List<String> roleStrings) {
    List<Role> roles = [];
    roleStrings.forEach((roleString) {
      var role = Role.initFromString(roleString);
      if (role == null) throw MappingException('Failed to initialize role from Employee response.');
      roles.add(role);
    });
    return roles;
  }

  List<WPAction> _initAllowedActions(List<Map<String, dynamic>> responseMapList) {
    var actions = <WPAction>[];
    var eligibleItemsList = responseMapList.where((element) => element['visibility']! == true).toList();
    for (var responseMap in eligibleItemsList) {
      var item = WPAction.initFromString(responseMap['name']!);
      if (item != null) actions.add(item);
    }
    return actions;
  }

  bool isOwner() {
    return _roles.contains(Role.Owner);
  }

  bool isGM() {
    return _roles.contains(Role.GeneralManager);
  }

  bool isAFinanceManager() {
    return _roles.contains(Role.FinanceManager);
  }

  bool isACrmManager() {
    return _roles.contains(Role.CrmManager);
  }

  bool isAHrManager() {
    return _roles.contains(Role.HrManager);
  }

  bool isARestaurantManager() {
    return _roles.contains(Role.RestaurantManager);
  }

  bool isARetailManager() {
    return _roles.contains(Role.RetailManager);
  }

  String get v1Id => _v1Id;

  String get v2Id => _v2Id;

  String get employeeName => _employeeName;

  String get employeeEmail => _employeeEmail;

  String get designation => _designation;

  List<Role> get roles => _roles;

  String? get lineManager => _lineManager;

  List<WPAction> get allowedActions => _allowedActions;
}
