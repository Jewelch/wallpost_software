import 'package:wallpost/task/entities/department.dart';
import 'package:wallpost/task/entities/task_category.dart';
import 'package:wallpost/task/entities/task_employee.dart';

class TasksListFilters {
  static const String MY_SCOPE = 'mytasks';
  static const String TEAM_SCOPE = 'teamtasks';

  static const String OVERDUE = 'overdue';
  static const String DUE_TODAY = 'due_today';
  static const String DUE_IN_A_WEEK = 'due_in_week';
  static const String UPCOMING_DUE = 'up_comming_dues';
  static const String COMPLETED = 'completed';
  static const String ALL = 'all';

  String _scope = MY_SCOPE;
  String _status = OVERDUE;
  String _searchText;
  int year;
  List<TaskEmployee> assignees = [];
  List<Department> departments = [];
  List<TaskCategory> categories = [];

  void showMyTasks() => _scope = MY_SCOPE;

  void showTeamTasks() => _scope = TEAM_SCOPE;

  void showOverdueTasks() => _status = OVERDUE;

  void showTasksThatAreDueToday() => _status = DUE_TODAY;

  void showTasksThatAreDueInAWeek() => _status = DUE_IN_A_WEEK;

  void showUpcomingDueTasks() => _status = UPCOMING_DUE;

  void showCompletedTasks() => _status = COMPLETED;

  void showAllTasks() => _status = ALL;

  void reset() {
    _scope = MY_SCOPE;
    _status = OVERDUE;
    _searchText = null;
    year = null;
    assignees = [];
    departments = [];
    categories = [];
  }

  String get scope => _scope;

  String get status => _status;

  String get searchText => _searchText;
}
