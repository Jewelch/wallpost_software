import 'package:wallpost/_shared/local_storage/secure_shared_prefs.dart';
import 'package:wallpost/company_core/entities/employee.dart';
import 'package:wallpost/company_core/entities/wp_action.dart';

class AllowedActionsRepository {
  late SecureSharedPrefs _sharedPrefs;
  Map<String, List<WPAction>> _allowedActions = {};
  final _key = "wp_actions";

  static AllowedActionsRepository? _singleton;

  // ignore: unused_element
  AllowedActionsRepository._();

  static Future<void> initRepo() async {
    await getInstance()._readAllowedActionsData();
  }

  static AllowedActionsRepository getInstance() {
    if (_singleton == null) {
      _singleton = AllowedActionsRepository.withSharedPrefs(SecureSharedPrefs());
    }
    return _singleton!;
  }

  AllowedActionsRepository.withSharedPrefs(SecureSharedPrefs sharedPrefs) {
    _sharedPrefs = sharedPrefs;
    _readAllowedActionsData();
  }

  //MARK: Functions to save actions for an employee

  void saveActionsForEmployee(List<WPAction> actions, Employee employee) {
    _allowedActions[employee.v1Id] = actions;
    _saveAllowedActionsData();
  }

  //MARK: Functions to get actions for an employee

  List<WPAction> getAllowedActionsForEmployee(Employee employee) {
    if (_allowedActions.containsKey(employee.v1Id) == false) return [];
    return _allowedActions[employee.v1Id]!;
  }

  //MARK: Function to remove allowed actions

  Future removeAllAllowedActions() async {
    await _sharedPrefs.removeMap(_key);
  }

  //MARK: Functions to read allowed actions data from the storage

  Future<void> _readAllowedActionsData() async {
    var itemsMap = await _sharedPrefs.getMap(_key);
    if (itemsMap == null) return;

    itemsMap.keys.forEach((key) {
      var employeeId = key;
      var actions = itemsMap[key].map<WPAction>((item) => initializeRequestFromString(item)!).toList();
      _allowedActions[employeeId] = actions;
    });
  }

  //MARK: Functions to save allowed actions data to the storage

  Future _saveAllowedActionsData() async {
    Map<String, List<String>> allowedActionsMap = {};

    _allowedActions.keys.forEach((key) {
      var employeeId = key;
      var actionsAsStringList = _allowedActions[employeeId]!.map((action) => action.toReadableString()).toList();
      allowedActionsMap[employeeId] = actionsAsStringList;
    });

    _sharedPrefs.saveMap(_key, allowedActionsMap);
  }
}
