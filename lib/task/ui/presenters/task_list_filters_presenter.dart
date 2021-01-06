import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/task_department.dart';
import 'package:wallpost/task/entities/task_category.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';
import 'package:wallpost/task/services/task_category_list_provider.dart';
import 'package:wallpost/task/services/task_department_list_provider.dart';
import 'package:wallpost/task/services/task_employee_list_provider.dart';

abstract class DepartmentsWrapView {
  void reloadData();

  void resetAndReloadData();
}

class TaskListFiltersPresenter {
  final DepartmentsWrapView view;
  final TaskDepartmentListProvider departmentListProvider;
  final TaskCategoryListProvider categoryListProvider;
  final TaskEmployeeListProvider employeeListProvider;
  List<TaskDepartment> _departments = [];
  List<TaskCategory> _categories = [];
  List<TaskEmployee> _assignees = [];

  TaskListFilters _filters;

  TaskListFiltersPresenter(this.view, this._filters)
      : departmentListProvider = TaskDepartmentListProvider(),
        categoryListProvider = TaskCategoryListProvider(),
        employeeListProvider = TaskEmployeeListProvider.subordinatesProvider();

  Future<void> loadDepartments() async {
    if (_filters.departments.isNotEmpty) {
      _departments.addAll(_filters.departments);
      view.reloadData();
    } else {
      if (departmentListProvider.isLoading || departmentListProvider.didReachListEnd) return null;

      try {
        var departmentList = await departmentListProvider.getNext();
        _departments.addAll(departmentList);
        view.reloadData();
        loadCategories();
      } on WPException catch (_) {
        //fail silently as this is not a critical error
        view.reloadData();
      }
    }
  }

  Future<void> loadCategories() async {
    if (_filters.categories.isNotEmpty) {
      _categories.addAll(_filters.categories);
      view.reloadData();
    } else {
      if (categoryListProvider.isLoading || categoryListProvider.didReachListEnd) return null;

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

  Future<void> loadAssignees() async {
    if (_filters.assignees.isNotEmpty) {
      _assignees.addAll(_filters.assignees);
      view.reloadData();
    } else {
      if (employeeListProvider.isLoading || employeeListProvider.didReachListEnd) return null;

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
    _filters.reset();
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

  void updateSelectedDepartments(List<TaskDepartment> departments) {
    _departments.clear();
    _departments.addAll(departments);
    _filters.departments.clear();
    _filters.departments.addAll(departments);
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

  void updateSelectedCategories(List<TaskCategory> categories) {
    _categories.clear();
    _categories.addAll(categories);
    _filters.categories.clear();
    _filters.categories.addAll(categories);
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

  void updateSelectedAssignees(List<TaskEmployee> assignees) {
    _assignees.clear();
    _assignees.addAll(assignees);
    _filters.assignees.clear();
    _filters.assignees.addAll(assignees);
    view.reloadData();
  }

  //MARK: Function to reset the filters

  void resetFilters() {
    _filters.reset();
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
