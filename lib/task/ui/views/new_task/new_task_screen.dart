import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_check_mark_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_close_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/multi_select_filter_chips.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/task/entities/department.dart';
import 'package:wallpost/task/entities/task_category.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';
import 'package:wallpost/task/ui/presenters/task_filter_presenter.dart';

class CreateTaskScreen extends StatefulWidget {
  @override
  _CreateTaskScreenState createState() => _CreateTaskScreenState();
}

class _CreateTaskScreenState extends State<CreateTaskScreen>
    implements DepartmentsWrapView {
  TaskFilterPresenter _presenter;
  List<Department> filteredDepartments;
  bool isFromDepartmentFilter = false;
  List<TaskCategory> filteredCategories;
  bool isFromCategoryFilter = false;
  List<TaskEmployee> filteredEmployees;
  bool isFromEmployeeFilter = false;

  var _departmentsFilterController = MultiSelectFilterChipsController();
  var _categoriesFilterController = MultiSelectFilterChipsController();
  var _employeesFilterController = MultiSelectFilterChipsController();

  TasksListFilters _filters;

  @override
  void initState() {
    _presenter = TaskFilterPresenter(this);
    isFromDepartmentFilter
        ? _presenter.loadFilteredDepartments(filteredDepartments)
        : _presenter.loadDepartments();
    _presenter.loadCategories();
    _presenter.loadEmployees();
    super.initState();
  }

  _resetFilters() {
    _filters.resetDateFilter();
    _presenter.loadDepartments();
    _presenter.loadCategories();
    _presenter.loadEmployees();
  }

  @override
  Widget build(BuildContext context) {
    _filters = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: new ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildDepartmentSection()),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildCategoriesSection()),
              Divider(height: 1),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildEmployeesSection()),
            ],
          ),
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return SimpleAppBar(
      title: 'Create Task',
      leadingButtons: [
        CircularCloseButton(
          iconColor: AppColors.defaultColor,
          color: Colors.transparent,
          onPressed: () => Navigator.pop(context),
        )
      ],
      trailingButtons: [
        CircularIconButton(
          iconName: 'assets/icons/reset_icon.svg',
          iconSize: 18,
          iconColor: AppColors.defaultColor,
          color: Colors.transparent,
          onPressed: () => setState(() => _resetFilters()),
        ),
        CircularCheckMarkButton(
          iconColor: AppColors.defaultColor,
          color: Colors.transparent,
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }

  Column _buildDepartmentSection() {
    var departmentTitles = isFromDepartmentFilter
        ? filteredDepartments.map((e) => e.name).toList()
        : _presenter.departments.map((e) => e.name).toList();
    if (departmentTitles.isNotEmpty && !isFromDepartmentFilter) {
      departmentTitles = departmentTitles.sublist(
          0, departmentTitles.length > 8 ? 8 : departmentTitles.length);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Department',
            style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        SizedBox(height: 8),
        _presenter.isLoadingDepartments()
            ? Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()))
            : MultiSelectFilterChips(
                titles: departmentTitles,
                selectedIndices: [],
                allowMultipleSelection: true,
                allIndexesSelected: isFromDepartmentFilter,
                controller: _departmentsFilterController,
                showTrailingButton: true,
                trailingButtonTitle: 'More',
                onTrailingButtonPressed: () {
                  goToDepartmentsFilter();
                },
                onItemSelected: (index) {
                  //use the index and store the dept entity in a list
                  //or
                  print(_departmentsFilterController.getSelectedIndices());
                },
              ),
        SizedBox(height: 12),
      ],
    );
  }

  void goToDepartmentsFilter() async {
    final selectedDepartments =
        await Navigator.pushNamed(context, RouteNames.departmentsListScreen);

    filteredDepartments = selectedDepartments;
    isFromDepartmentFilter = true;
    _presenter.loadFilteredDepartments(filteredDepartments);
  }

  Column _buildCategoriesSection() {
    var categoryTitles = isFromCategoryFilter
        ? filteredCategories.map((e) => e.name).toList()
        : _presenter.categories.map((e) => e.name).toList();
    if (categoryTitles.isNotEmpty && !isFromCategoryFilter) {
      categoryTitles = categoryTitles.sublist(
          0, categoryTitles.length > 8 ? 8 : categoryTitles.length);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Category',
            style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        SizedBox(height: 8),
        _presenter.isLoadingCategories()
            ? Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()))
            : MultiSelectFilterChips(
                titles: categoryTitles,
                selectedIndices: [],
                allowMultipleSelection: true,
                allIndexesSelected: isFromCategoryFilter,
                controller: _categoriesFilterController,
                showTrailingButton: true,
                trailingButtonTitle: 'More',
                onTrailingButtonPressed: () {
                  goToCategoriesFilter();
                },
              ),
        SizedBox(height: 12),
      ],
    );
  }

  void goToCategoriesFilter() async {
    final selectedCategories =
        await Navigator.pushNamed(context, RouteNames.taskCategoryListScreen);

    filteredCategories = selectedCategories;
    isFromCategoryFilter = true;
    _presenter.loadFilteredCategories(filteredCategories);
  }

  Column _buildEmployeesSection() {
    var employeeTitles = isFromEmployeeFilter
        ? filteredEmployees.map((e) => e.fullName).toList()
        : _presenter.employees.map((e) => e.fullName).toList();
    if (employeeTitles.isNotEmpty && !isFromEmployeeFilter) {
      employeeTitles = employeeTitles.sublist(
          0, employeeTitles.length > 8 ? 8 : employeeTitles.length);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Employee',
            style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        SizedBox(height: 8),
        _presenter.isLoadingEmployees()
            ? Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()))
            : MultiSelectFilterChips(
                titles: employeeTitles,
                selectedIndices: [],
                allowMultipleSelection: true,
                allIndexesSelected: isFromEmployeeFilter,
                controller: _employeesFilterController,
                showTrailingButton: true,
                trailingButtonTitle: 'More',
                onTrailingButtonPressed: () {
                  goToEmployeesFilter();
                },
              ),
        SizedBox(height: 12),
      ],
    );
  }

  void goToEmployeesFilter() async {
    final selectedEmployees =
        await Navigator.pushNamed(context, RouteNames.taskEmployeeListScreen);

    filteredEmployees = selectedEmployees;
    isFromEmployeeFilter = true;
    _presenter.loadFilteredEmployees(filteredEmployees);
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }

  List<Department> _getSelectedDepartments() {
    List<Department> _selectedDepartments = List<Department>();
    List<int> _selectedDepartmentIndexes =
        _departmentsFilterController.getSelectedIndices();
    for (var i = 0; i < _selectedDepartmentIndexes.length; i++) {
      _selectedDepartments
          .add(_presenter.departments[_selectedDepartmentIndexes[i]]);
    }
    return _selectedDepartments;
  }

  List<TaskCategory> _getSelectedCategories() {
    List<TaskCategory> _selectedCategories = List<TaskCategory>();
    List<int> _selectedCategoriesIndexes =
        _categoriesFilterController.getSelectedIndices();
    for (var i = 0; i < _selectedCategoriesIndexes.length; i++) {
      _selectedCategories
          .add(_presenter.categories[_selectedCategoriesIndexes[i]]);
    }
    return _selectedCategories;
  }

  List<TaskEmployee> _getSelectedEmployees() {
    List<TaskEmployee> _selectedEmployees = List<TaskEmployee>();
    List<int> _selectedEmployeesIndexes =
        _employeesFilterController.getSelectedIndices();
    for (var i = 0; i < _selectedEmployeesIndexes.length; i++) {
      _selectedEmployees
          .add(_presenter.employees[_selectedEmployeesIndexes[i]]);
    }
    return _selectedEmployees;
  }
}
