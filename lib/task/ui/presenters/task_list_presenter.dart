import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/list_view/loader_list_tile.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/task_count.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';
import 'package:wallpost/task/entities/task_list_item.dart';
import 'package:wallpost/task/services/task_count_provider.dart';
import 'package:wallpost/task/services/task_list_provider.dart';
import 'package:wallpost/task/ui/views/task_list/list/task_list_tile.dart';

abstract class TaskListView {
  void reloadData();
  void onTaskSelected(int index);
}

class TaskListPresenter {
  final TaskListView _view;
  final TaskListProvider _provider;
  final TaskCountProvider _taskCountProvider;
  List<TaskListItem> _task = [];
  String _errorMessage;
  String _searchText;
  TaskCount taskCount;
  int overdueCount = 0;
  int dueTodayCount = 0;
  int dueInAWeekCount = 0;
  int upcomingDueCount = 0;
  int completedCount = 0;
  int allCount = 0;

  TaskListPresenter(this._view)
      : _provider = TaskListProvider(),
        _taskCountProvider = TaskCountProvider();

  Future<void> loadTaskCount(
      int selectedTab, TaskListFilters _selectedFilters) async {
    if (_taskCountProvider.isLoading) return null;

    try {
      taskCount = await _taskCountProvider.getCount(
          year: _selectedFilters.year == null
              ? DateTime.now().year
              : _selectedFilters.year);
      overdueCount = taskCount.overdue;
      dueTodayCount = taskCount.dueToday;
      dueInAWeekCount = taskCount.dueInAWeek;
      upcomingDueCount = taskCount.upcomingDue;
      completedCount = taskCount.completed;
      allCount = taskCount.all;
      _view.reloadData();
      loadNextListOfTasks(selectedTab, _selectedFilters);
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      _view.reloadData();
    }
  }

  Future<void> loadNextListOfTasks(
      int selectedTab, TaskListFilters _selectedFilters) async {
    if (_provider.isLoading || _provider.didReachListEnd) return null;

    _searchText = _selectedFilters == null ? '' : _selectedFilters.searchText;
    _resetErrors();
    if (_selectedFilters == null) {
      _selectedFilters = TaskListFilters();
    }
    if (_searchText != '') {
      _selectedFilters.searchText = _searchText;
    }
    _selectedFilters.showTeamTasks();
    switch (selectedTab) {
      case 0:
        {
          _selectedFilters.showOverdueTasks();
        }
        break;

      case 1:
        {
          _selectedFilters.showTasksThatAreDueToday();
        }
        break;

      case 2:
        {
          _selectedFilters.showTasksThatAreDueInAWeek();
        }
        break;
      case 3:
        {
          _selectedFilters.showUpcomingDueTasks();
        }
        break;
      case 4:
        {
          _selectedFilters.showCompletedTasks();
        }
        break;

      case 5:
        {
          _selectedFilters.showAllTasks();
        }
        break;

      default:
        {
          _selectedFilters.showUpcomingDueTasks();
        }
        break;
    }

    try {
      var taskList = await _provider.getNext(_selectedFilters);
      _task.addAll(taskList);
      _view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      _view.reloadData();
    }
  }

  //MARK: Functions to get task list count and views

  int getNumberOfTask() {
    if (_hasErrors()) return _task.length + 1;

    if (_task.isEmpty) return 1;

    if (_provider.didReachListEnd) {
      return _task.length;
    } else {
      return _task.length + 1;
    }
  }

  TaskListItem getTaskForIndex(int index) {
    return _task[index];
  }

  Widget getTaskViewForIndex(int index) {
    if (_shouldShowErrorAtIndex(index)) return _buildErrorView(_errorMessage);

    if (_task.isEmpty) return _buildViewWhenThereAreNoResults();

    if (index < _task.length) {
      return _buildTaskViewForIndex(index);
    } else {
      return LoaderListTile();
    }
  }

  bool _shouldShowErrorAtIndex(int index) {
    return _hasErrors() && index == _task.length;
  }

  Widget _buildErrorView(String errorMessage) {
    return ErrorListTile(
      '$errorMessage Tap here to reload.',
      onTap: () {
        loadNextListOfTasks(0, null);
        _view.reloadData();
      },
    );
  }

  Widget _buildViewWhenThereAreNoResults() {
    if (_provider.didReachListEnd) {
      return ErrorListTile(
        'There are no tasks',
      );
    } else {
      return LoaderListTile();
    }
  }

  Widget _buildTaskViewForIndex(int index) {
    return TaskListTile(_task[index], onTaskListTileTap: () {
      _view.onTaskSelected(index);
    });
  }

  //MARK: Util functions

  void reset() {
    _task.clear();
    _provider.reset();
    _resetErrors();
    _view.reloadData();
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }
}
