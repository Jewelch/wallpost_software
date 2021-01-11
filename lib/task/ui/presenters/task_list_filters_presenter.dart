import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/task_category.dart';
import 'package:wallpost/task/entities/task_department.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';
import 'package:wallpost/task/services/task_category_list_provider.dart';
import 'package:wallpost/task/services/task_department_list_provider.dart';
import 'package:wallpost/task/services/task_employee_list_provider.dart';

abstract class TaskListFiltersView {
  void reloadData();

  void resetAndReloadData();
}

class TaskListFiltersPresenter {
  final TaskListFiltersView view;
  TaskListFilters _filters;
  final TaskDepartmentListProvider departmentListProvider;
  final TaskCategoryListProvider categoryListProvider;
  final TaskEmployeeListProvider employeeListProvider;
  List<TaskDepartment> _departments = [];
  List<TaskCategory> _categories = [];
  List<TaskEmployee> _assignees = [];

  TaskListFiltersPresenter(this.view, this._filters)
      : departmentListProvider = TaskDepartmentListProvider(),
        categoryListProvider = TaskCategoryListProvider(),
        employeeListProvider = TaskEmployeeListProvider.subordinatesProvider();

  void loadDepartments() async {
    if (_filters.departments.isNotEmpty) {
      _departments.clear();
      _departments.addAll(_filters.departments);
      view.reloadData();
    } else {
      if (_departments.isNotEmpty) {
        view.reloadData();
        return;
      }

      if (departmentListProvider.isLoading) return;

      try {
        var departmentList = await departmentListProvider.getNext();
        _departments.addAll(departmentList);
        view.reloadData();
      } on WPException catch (_) {
        //fail silently as this is not a critical error
        view.reloadData();
      }
    }
  }

  void loadCategories() async {
    if (_filters.categories.isNotEmpty) {
      _categories.clear();
      _categories.addAll(_filters.categories);
      view.reloadData();
    } else {
      if (_categories.isNotEmpty) {
        view.reloadData();
        return;
      }

      if (categoryListProvider.isLoading) return;

      try {
        var categoryList = await categoryListProvider.getNext();
        _categories.addAll(categoryList);
        view.reloadData();
      } on WPException catch (_) {
        //fail silently as this is not a critical error
        view.reloadData();
      }
    }
  }

  void loadAssignees() async {
    if (_filters.assignees.isNotEmpty) {
      _assignees.clear();
      _assignees.addAll(_filters.assignees);
      view.reloadData();
    } else {
      if (_assignees.isNotEmpty) {
        view.reloadData();
        return;
      }

      if (employeeListProvider.isLoading) return;

      try {
        var employeeList = await employeeListProvider.getNext();
        _assignees.addAll(employeeList);
        view.reloadData();
      } on WPException catch (_) {
        //fail silently as this is not a critical error
        view.reloadData();
      }
    }
  }

  //MARK: Functions to get, select, and reset year filter

  List<int> getYears() {
    return AppYears.years();
  }

  int getSelectedYearIndex() {
    return getYears().indexOf(_filters.year);
  }

  void selectYearAtIndex(int index) {
    _filters.year = getYears()[index];
  }

  void resetYearFilter() {
    _filters.resetYearFilter();
    view.reloadData();
  }

  //MARK: Functions to get, select, and deselect departments

  List<TaskDepartment> getDepartments() {
    return _departments;
  }

  List<int> getSelectedDepartmentIndices() {
    List<int> indices = [];
    for (TaskDepartment d in _filters.departments) {
      indices.add(_departments.indexOf(d));
    }
    return indices;
  }

  void selectDepartmentAtIndex(int index) {
    _filters.departments.add(_departments[index]);
    view.reloadData();
  }

  void deselectDepartmentAtIndex(int index) {
    _filters.departments.remove(_departments[index]);
    view.reloadData();
  }

  //MARK: Functions to get, select, and deselect categories

  List<TaskCategory> getCategories() {
    return _categories;
  }

  List<int> getSelectedCategoryIndices() {
    List<int> indices = [];
    for (TaskCategory c in _filters.categories) {
      indices.add(_categories.indexOf(c));
    }
    return indices;
  }

  void selectCategoryAtIndex(int index) {
    _filters.categories.add(_categories[index]);
    view.reloadData();
  }

  void deselectCategoryAtIndex(int index) {
    _filters.categories.remove(_categories[index]);
    view.reloadData();
  }

  //MARK: Functions to get, select, and deselect assignees

  List<TaskEmployee> getAssignees() {
    return _assignees;
  }

  List<int> getSelectedAssigneeIndices() {
    List<int> indices = [];
    for (TaskEmployee e in _filters.assignees) {
      indices.add(_assignees.indexOf(e));
    }
    return indices;
  }

  void selectAssigneeAtIndex(int index) {
    _filters.assignees.add(_assignees[index]);
    view.reloadData();
  }

  void deselectAssigneeAtIndex(int index) {
    _filters.assignees.remove(_assignees[index]);
    view.reloadData();
  }

  //MARK: Function to reset the filters

  void resetFilters() {
    _filters.resetYearFilter();
    _filters.resetSelectedAssignees();
    _filters.resetSelectedDepartments();
    _filters.resetSelectedCategories();
    departmentListProvider.reset();
    categoryListProvider.reset();
    employeeListProvider.reset();
    _departments.clear();
    _categories.clear();
    _assignees.clear();
    view.resetAndReloadData();
  }

  //MARK: Util functions

  bool isLoadingDepartments() {
    return departmentListProvider.isLoading;
  }

  bool isLoadingCategories() {
    return categoryListProvider.isLoading;
  }

  bool isLoadingEmployees() {
    return employeeListProvider.isLoading;
  }
}
