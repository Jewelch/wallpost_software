import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';

void main() {
  test('test defaults', () async {
    var filters = TasksListFilters();

    expect(filters.scope, TasksListFilters.MY_SCOPE);
    expect(filters.status, TasksListFilters.OVERDUE);
    expect(filters.searchText, null);
    expect(filters.year, null);
    expect(filters.assignees, isEmpty);
    expect(filters.departments, isEmpty);
    expect(filters.categories, isEmpty);
  });

  test('setting the scope', () async {
    var filters = TasksListFilters();

    filters.showMyTasks();
    expect(filters.scope, TasksListFilters.MY_SCOPE);

    filters.showTeamTasks();
    expect(filters.scope, TasksListFilters.TEAM_SCOPE);
  });

  test('setting the status', () async {
    var filters = TasksListFilters();

    filters.showOverdueTasks();
    expect(filters.status, TasksListFilters.OVERDUE);

    filters.showTasksThatAreDueToday();
    expect(filters.status, TasksListFilters.DUE_TODAY);

    filters.showTasksThatAreDueInAWeek();
    expect(filters.status, TasksListFilters.DUE_IN_A_WEEK);

    filters.showUpcomingDueTasks();
    expect(filters.status, TasksListFilters.UPCOMING_DUE);

    filters.showCompletedTasks();
    expect(filters.status, TasksListFilters.COMPLETED);

    filters.showAllTasks();
    expect(filters.status, TasksListFilters.ALL);
  });

  test('resetting the filters', () async {
    var filters = TasksListFilters();
    filters.showTeamTasks();
    filters.showAllTasks();

    filters.reset();

    expect(filters.scope, TasksListFilters.MY_SCOPE);
    expect(filters.status, TasksListFilters.OVERDUE);
    expect(filters.searchText, null);
    expect(filters.year, null);
    expect(filters.assignees, isEmpty);
    expect(filters.departments, isEmpty);
    expect(filters.categories, isEmpty);
  });
}
