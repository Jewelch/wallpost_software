import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';

void main() {
  test('test defaults', () async {
    var filters = TaskListFilters();

    expect(filters.scope, TaskListFilters.MY_SCOPE);
    expect(filters.status, TaskListFilters.OVERDUE);
    expect(filters.searchText, null);
    expect(filters.year, DateTime.now().year);
    expect(filters.assignees, isEmpty);
    expect(filters.departments, isEmpty);
    expect(filters.categories, isEmpty);
  });

  test('setting the scope', () async {
    var filters = TaskListFilters();

    filters.showMyTasks();
    expect(filters.scope, TaskListFilters.MY_SCOPE);

    filters.showTeamTasks();
    expect(filters.scope, TaskListFilters.TEAM_SCOPE);
  });

  test('setting the status', () async {
    var filters = TaskListFilters();

    filters.showOverdueTasks();
    expect(filters.status, TaskListFilters.OVERDUE);

    filters.showTasksThatAreDueToday();
    expect(filters.status, TaskListFilters.DUE_TODAY);

    filters.showTasksThatAreDueInAWeek();
    expect(filters.status, TaskListFilters.DUE_IN_A_WEEK);

    filters.showUpcomingDueTasks();
    expect(filters.status, TaskListFilters.UPCOMING_DUE);

    filters.showCompletedTasks();
    expect(filters.status, TaskListFilters.COMPLETED);

    filters.showAllTasks();
    expect(filters.status, TaskListFilters.ALL);
  });

  test('resetting the filters', () async {
    var filters = TaskListFilters();
    filters.showTeamTasks();
    filters.showAllTasks();

    filters.reset();

    expect(filters.scope, TaskListFilters.MY_SCOPE);
    expect(filters.status, TaskListFilters.OVERDUE);
    expect(filters.searchText, null);
    expect(filters.year, DateTime.now().year);
    expect(filters.assignees, isEmpty);
    expect(filters.departments, isEmpty);
    expect(filters.categories, isEmpty);
  });

  test('resetting date filter', () async {
    var filters = TaskListFilters();
    filters.year = 2018;

    filters.resetDateFilter();

    expect(filters.year, DateTime.now().year);
  });
}
