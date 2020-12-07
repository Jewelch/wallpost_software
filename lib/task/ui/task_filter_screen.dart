import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:wallpost/_common_widgets/form_widgets/multi_select_filter_chips.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/task/entities/department.dart';
import 'package:wallpost/task/entities/task_category.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';
import 'package:wallpost/task/ui/presenters/task_filter_presenter.dart';

class TaskFilterScreen extends StatefulWidget {
  @override
  _TaskFilterScreenState createState() => _TaskFilterScreenState();
}

class _TaskFilterScreenState extends State<TaskFilterScreen>
    implements DepartmentsWrapView {
  TaskFilterPresenter _presenter;
  List<Department> filteredDepartments;
  bool isFromDepartmentFilter = false;
  List<TaskCategory> filteredCategories;
  bool isFromCategoryFilter = false;
  List<TaskEmployee> filteredEmployees;
  bool isFromEmployeeFilter = false;

  var _yearsFilterController = MultiSelectFilterChipsController();
  var _departmentsFilterController = MultiSelectFilterChipsController();
  var _categoriesFilterController = MultiSelectFilterChipsController();
  var _employeesFilterController = MultiSelectFilterChipsController();

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: new ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: _buildYearSection()),
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

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      titleSpacing: 0,
      brightness: Brightness.light,
      backgroundColor: Colors.white,
      elevation: 0.0,
      automaticallyImplyLeading: false,
      title: Column(
        children: [
          Row(
            children: [
              SizedBox(
                child: IconButton(
                  icon: SvgPicture.asset('assets/icons/delete_icon.svg',
                      width: 42, height: 23),
                  onPressed: () => {Navigator.pop(context)},
                ),
              ),
              Expanded(
                child: Container(
                  height: 32,
                  width: double.infinity,
                  child: Row(
                    children: [
                      SizedBox(width: 8),
                      Expanded(
                        child: Container(
                          child: Center(
                            child: Text('Filters',
                                style: TextStyle(
                                    color: Colors.black, fontSize: 18)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                child: IconButton(
                  icon: SvgPicture.asset('assets/icons/reset_icon.svg',
                      width: 42, height: 23),
                  onPressed: () => {},
                ),
              ),
              SizedBox(
                child: IconButton(
                  icon: SvgPicture.asset(
                    'assets/icons/check.svg',
                    width: 42,
                    height: 23,
                    color: AppColors.defaultColor,
                  ),
                  onPressed: () => {
                    _updateAllSelectedFilters(),
                    Navigator.pop(context, true)
                  },
                ),
              ),
            ],
          ),
          Divider(
            height: 4,
            color: AppColors.blackColor,
          ),
        ],
      ),
    );
  }

  Column _buildYearSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Year', style: TextStyle(color: Colors.black, fontSize: 14)),
        SizedBox(height: 8),
        MultiSelectFilterChips(
          titles: AppYears.years().map((e) => '$e').toList(),
          selectedIndices: [0],
          controller: _yearsFilterController,
          allowMultipleSelection: false,
        ),
        SizedBox(height: 12),
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
        Text('Department', style: TextStyle(color: Colors.black, fontSize: 14)),
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
        Text('Category', style: TextStyle(color: Colors.black, fontSize: 14)),
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
        Text('Employee', style: TextStyle(color: Colors.black, fontSize: 14)),
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

  void _updateAllSelectedFilters() {
    TasksListFilters _tasksListFilter = TasksListFilters();

    _tasksListFilter.year =
        AppYears.years()[_yearsFilterController.getSelectedIndices()[0]];

    _tasksListFilter.departments.addAll(isFromDepartmentFilter
        ? filteredDepartments
        : _getSelectedDepartments());

    _tasksListFilter.categories.addAll(
        isFromCategoryFilter ? filteredCategories : _getSelectedCategories());

    _tasksListFilter.assignees.addAll(
        isFromEmployeeFilter ? filteredEmployees : _getSelectedEmployees());
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
