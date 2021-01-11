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
  final TaskListProvider _taskListProvider;
  final TaskCountProvider _taskCountProvider;
  TaskListFilters _filters = TaskListFilters();
  List<TaskListItem> _tasks = [];
  TaskCount _taskCount;
  String _errorMessage;

  TaskListPresenter(this._view)
      : _taskListProvider = TaskListProvider(),
        _taskCountProvider = TaskCountProvider();

  Future<void> loadTaskCount() async {
    try {
      _taskCount = await _taskCountProvider.getCount(_filters);
      _view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      _view.reloadData();
    }
  }

  Future<void> loadNextListOfTasks() async {
    if (_taskListProvider.isLoading) return null;

    _resetErrors();
    try {
      var taskList = await _taskListProvider.getNext(_filters);
      _tasks.addAll(taskList);
      if (_tasks.isEmpty) _errorMessage = 'There are no tasks to show.';
      _view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      _view.reloadData();
    }
  }

  //MARK: Functions to get task list count and views

  int getNumberOfTasks() {
    return _tasks.length + 1;
  }

  Widget getTaskViewForIndex(int index) {
    if (index < _tasks.length) return _buildTaskViewForIndex(index);

    if (_hasErrors()) {
      return _buildErrorView(_errorMessage);
    } else {
      if (_taskListProvider.didReachListEnd) {
        return Container(height: 200);
      } else {
        return LoaderListTile();
      }
    }
  }

  Widget _buildTaskViewForIndex(int index) {
    return TaskListTile(_tasks[index], onTaskListTileTap: () {
      _view.onTaskSelected(index);
    });
  }

  Widget _buildErrorView(String errorMessage) {
    return ErrorListTile(
      '$errorMessage Tap here to reload.',
      onTap: () {
        loadNextListOfTasks();
        _view.reloadData();
      },
    );
  }

  //MARK: Functions to get task and filters data

  String getOverdueTaskCount() {
    return _taskCount != null ? '${_taskCount.overdue}' : '';
  }

  String getCountOfTasksThatAreDueToday() {
    return _taskCount != null ? '${_taskCount.dueToday}' : '';
  }

  String getCountOfTasksThatAreDueInAWeek() {
    return _taskCount != null ? '${_taskCount.dueInAWeek}' : '';
  }

  String getUpcomingDueTaskCount() {
    return _taskCount != null ? '${_taskCount.upcomingDue}' : '';
  }

  String getCompletedTaskCount() {
    return _taskCount != null ? '${_taskCount.completed}' : '';
  }

  String getCountOfAllTasks() {
    return _taskCount != null ? '${_taskCount.all}' : '';
  }

  TaskListItem getTaskForIndex(int index) {
    return _tasks[index];
  }

  TaskListFilters getFilters() {
    return _filters;
  }

  //MARK: Functions to change the filters

  void updateStatus(int index) {
    switch (index) {
      case 0:
        _filters.showOverdueTasks();
        break;
      case 1:
        _filters.showTasksThatAreDueToday();
        break;
      case 2:
        _filters.showTasksThatAreDueInAWeek();
        break;
      case 3:
        _filters.showUpcomingDueTasks();
        break;
      case 4:
        _filters.showCompletedTasks();
        break;
      case 5:
        _filters.showAllTasks();
        break;
      default:
        _filters.showUpcomingDueTasks();
        break;
    }
    reset();
    loadNextListOfTasks();
  }

  void updateSearchText(String searchText) {
    _filters.searchText = searchText;
    reset();
    loadNextListOfTasks();
  }

  void updateFilters(TaskListFilters filters) {
    this._filters = filters;
    reset();
    loadTaskCount();
    loadNextListOfTasks();
  }

  //MARK: Util functions

  void reset() {
    _tasks.clear();
    _taskListProvider.reset();
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
