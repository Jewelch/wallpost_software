import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/department.dart';
import 'package:wallpost/task/entities/task_category.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/services/departments_list_provider.dart';
import 'package:wallpost/task/services/task_categories_list_provider.dart';
import 'package:wallpost/task/services/task_employees_list_provider.dart';

abstract class DepartmentsWrapView {
  void reloadData();
}

class TaskFilterPresenter {
  final DepartmentsWrapView view;
  final DepartmentsListProvider departmentsListProvider;
  final TaskCategoriesListProvider categoriesListProvider;
  final TaskEmployeesListProvider employeesListProvider;
  List<Department> departments = [];
  List<TaskCategory> categories = [];
  List<TaskEmployee> employees = [];

  TaskFilterPresenter(this.view)
      : departmentsListProvider = DepartmentsListProvider(),
        categoriesListProvider = TaskCategoriesListProvider(),
        employeesListProvider =
            TaskEmployeesListProvider.subordinatesProvider();

  Future<void> loadDepartments() async {
    if (departmentsListProvider.isLoading ||
        departmentsListProvider.didReachListEnd) return null;

    try {
      var departmentsList = await departmentsListProvider.getNext();
      departments.addAll(departmentsList);
      view.reloadData();
      loadCategories();
    } on WPException catch (_) {
      //fail silently as this is not a critical error
      view.reloadData();
    }
  }

  void loadFilteredDepartments(List<Department> departmentsList) {
    departments.clear();
    departments.addAll(departmentsList);
    view.reloadData();
  }

  Future<void> loadCategories() async {
    if (categoriesListProvider.isLoading ||
        categoriesListProvider.didReachListEnd) return null;

    try {
      var categoriesList = await categoriesListProvider.getNext();
      categories.addAll(categoriesList);
      view.reloadData();
    } on WPException catch (_) {
      //fail silently as this is not a critical error
      view.reloadData();
    }
  }

  Future<void> loadEmployees() async {
    if (employeesListProvider.isLoading ||
        employeesListProvider.didReachListEnd) return null;

    try {
      var employeesList = await employeesListProvider.getNext();
      employees.addAll(employeesList);
      view.reloadData();
    } on WPException catch (_) {
      //fail silently as this is not a critical error
      view.reloadData();
    }
  }

  //MARK: Util functions

  bool isLoadingDepartments() {
    return departmentsListProvider.isLoading;
  }

  bool isLoadingCategories() {
    return categoriesListProvider.isLoading;
  }

  bool isLoadingEmployees() {
    return employeesListProvider.isLoading;
  }
}
