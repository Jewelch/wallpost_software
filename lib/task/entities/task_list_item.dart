import 'package:sift/Sift.dart';
import 'package:wallpost/_shared/exceptions/mapping_exception.dart';
import 'package:wallpost/_shared/json_serialization_base/json_initializable.dart';
import 'package:wallpost/task/entities/task_employee.dart';

class TaskListItem extends JSONInitializable {
  num _id;
  String _name;
  List<TaskEmployee> _assignees;
  DateTime _startDate;
  DateTime _startTime;
  DateTime _endDate;
  DateTime _endTime;
  String _status;
  bool _isEscalated;

  TaskListItem.fromJson(Map<String, dynamic> jsonMap) : super.fromJson(jsonMap) {
    var sift = Sift();
    try {
      var statusMap = sift.readMapFromMap(jsonMap, 'status');
      var scheduleMap = sift.readMapFromMap(jsonMap, 'schedule');
      var assigneesMapList = sift.readMapListFromMap(jsonMap, 'assignees');
      _id = sift.readNumberFromMap(jsonMap, 'id');
      _name = sift.readStringFromMap(jsonMap, 'name');
      _assignees = _readTaskAssigneeFromMapList(assigneesMapList);
      _startDate = sift.readDateFromMap(scheduleMap, 'start_date', 'yyyy-MM-dd');
      _startTime = sift.readDateFromMap(scheduleMap, 'start_time', 'HH:mm:ss');
      _endDate = sift.readDateFromMap(scheduleMap, 'end_date', 'yyyy-MM-dd');
      _endTime = sift.readDateFromMap(scheduleMap, 'end_time', 'HH:mm:ss');
      _status = sift.readStringFromMap(statusMap, 'display_name');
      _isEscalated = sift.readNumberFromMap(jsonMap, 'is_escalated') == 1;
    } on SiftException catch (e) {
      throw MappingException('Failed to cast TaskListItem response. Error message - ${e.errorMessage}');
    }
  }

  List<TaskEmployee> _readTaskAssigneeFromMapList(List<Map<String, dynamic>> jsonMapList) {
    var items = <TaskEmployee>[];
    for (var jsonMap in jsonMapList) {
      var employeeMap = Sift().readMapFromMap(jsonMap, 'employee');
      var item = TaskEmployee.fromJson(employeeMap);
      items.add(item);
    }
    return items;
  }

  num get id => _id;

  String get name => _name;

  List<TaskEmployee> get assignees => _assignees;

  DateTime get startDate => _startDate;

  DateTime get startTime => _startTime;

  DateTime get endDate => _endDate;

  DateTime get endTime => _endTime;

  String get status => _status;

  bool get isEscalated => _isEscalated;
}
