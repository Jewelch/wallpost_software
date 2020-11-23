import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/_list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/_list_view/filter_loader_list_tile.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/department.dart';
import 'package:wallpost/task/entities/task_category.dart';
import 'package:wallpost/task/services/departments_list_provider.dart';
import 'package:wallpost/task/services/task_categories_list_provider.dart';

abstract class DepartmentsWrapView {
  void reloadData();
}

class TaskFilterPresenter {
  final DepartmentsWrapView view;
  final DepartmentsListProvider provider;
  final TaskCategoriesListProvider categoryProvider;
  List<Department> departments = [];
  List<TaskCategory> categories = [];
  String _errorMessage;

  TaskFilterPresenter(this.view)
      : provider = DepartmentsListProvider(),
        categoryProvider = TaskCategoriesListProvider();

  TaskFilterPresenter.initWith(this.view, this.provider, this.categoryProvider);

  Future<void> loadNextListOfDepartments() async {
    if (provider.isLoading || provider.didReachListEnd) return null;

    _resetErrors();
    try {
      var departmentsList = await provider.getNext();
      departments.addAll(departmentsList);
      view.reloadData();
      loadNextListOfCategories();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      view.reloadData();
    }
  }

  Future<void> loadNextListOfCategories() async {
    if (provider.isLoading || provider.didReachListEnd) return null;

    _resetErrors();
    try {
      var categoriesList = await categoryProvider.getNext();
      categories.addAll(categoriesList);
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      view.reloadData();
    }
  }

  Future<Map<Department, bool>> getListOfDepartments() async {
    if (provider.isLoading || provider.didReachListEnd) return null;

    _resetErrors();
    try {
      var departmentsList = await provider.getNext();
      departments.addAll(departmentsList);
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      view.reloadData();
    }
  }

  int getNumberOfItems() {
    if (_hasErrors()) return departments.length + 1;

    if (departments.isEmpty) return 1;

    if (provider.didReachListEnd) {
      return departments.length;
    } else {
      return departments.length + 1;
    }
  }

  int getNumberOfCategoryItems() {
    if (_hasErrors()) return departments.length + 1;

    if (categories.isEmpty) return 1;

    if (provider.didReachListEnd) {
      return categories.length;
    } else {
      return categories.length + 1;
    }
  }

  Widget getDepartmentTextAtIndex(int index, int numberOfDefaultFilterTiles) {
    if (_shouldShowErrorAtIndex(index))
      return ErrorListTile('$_errorMessage\nTap here to reload.');

    if (departments.isEmpty) return _buildViewWhenThereAreNoResults();

    if (index < numberOfDefaultFilterTiles) {
      return Text(departments[index].name);
    } else {
      return Text('more...');
    }
  }

  Widget getCategoryTextAtIndex(int index, int numberOfDefaultFilterTiles) {
    if (_shouldShowErrorAtIndex(index))
      return ErrorListTile('$_errorMessage\nTap here to reload.');

    if (categories.isEmpty) return _buildViewWhenThereAreNoResults();

    if (index > categories.length - 1) {
      return Text('more...');
    } else {
      return Text(categories[index].name);
    }
  }

  bool _shouldShowErrorAtIndex(int index) {
    return _hasErrors() && index == departments.length;
  }

  Widget _buildViewWhenThereAreNoResults() {
    if (provider.didReachListEnd) {
      return ErrorListTile(
          'There are no departments to show. Tap here to reload.');
    } else {
      return FilterLoaderListTile();
    }
  }

  //MARK: Util functions

  void reset() {
    provider.reset();
    _resetErrors();
    departments.clear();
    view.reloadData();
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }
}
