import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/filter_app_bar.dart';
import 'package:wallpost/_common_widgets/form_widgets/multi_select_filter_chips.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/task/ui/presenters/task_filter_presenter.dart';

class TaskFilterScreen extends StatefulWidget {
  @override
  _TaskFilterScreenState createState() => _TaskFilterScreenState();
}

//TODO: Yahya - Manage selections

class _TaskFilterScreenState extends State<TaskFilterScreen> implements DepartmentsWrapView {
  TaskFilterPresenter _presenter;

//  int _selectedYear = -1;
//  int _selectedDepartment = 2;
//  List<bool> _defaultSelectedDepartments;
//  List<bool> _defaultSelectedCategories;
//  List<Department> _selectedDepartments;
//  List<TaskCategory> _selectedCategories;
//  List<TaskEmployee> _selectedEmployees;
//

  var _departmentsFilterController = MultiSelectFilterChipsController();

  @override
  void initState() {
    _presenter = TaskFilterPresenter(this);
    _presenter.loadDepartments();
    _presenter.loadCategories();
    _presenter.loadEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FilterAppBar(
        onBackPressed: () {
          Navigator.pop(context);
        },
        onResetFiltersPressed: () {
          setState(() {
//            _defaultSelectedDepartments = List.filled(9, false);
//            _defaultSelectedCategories = List.filled(numberOfDefaultCategoryTiles + 1, false);
//            _selectedYear = -1;
          });
        },
        onDoFilterPressed: () {
          Navigator.pop(context);
        },
        screenTitle: 'Filters',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: new ClampingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: _buildYearSection()),
              Divider(height: 1),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: _buildDepartmentSection()),
              Divider(height: 1),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: _buildCategoriesSection()),
              Divider(height: 1),
              Padding(padding: const EdgeInsets.symmetric(horizontal: 12), child: _buildEmployeesSection()),
            ],
          ),
        ),
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
          allowMultipleSelection: false,
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Column _buildDepartmentSection() {
    var departmentTitles = _presenter.departments.map((e) => e.name).toList();
    if (departmentTitles.isNotEmpty) {
      departmentTitles = departmentTitles.sublist(0, departmentTitles.length > 8 ? 8 : departmentTitles.length);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Department', style: TextStyle(color: Colors.black, fontSize: 14)),
        SizedBox(height: 8),
        _presenter.isLoadingDepartments()
            ? Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()))
            : MultiSelectFilterChips(
                titles: departmentTitles,
                selectedIndices: [2, 6],
                allowMultipleSelection: true,
                controller: _departmentsFilterController,
                showTrailingButton: true,
                trailingButtonTitle: 'More',
                onTrailingButtonPressed: () {
                  Navigator.pushNamed(context, RouteNames.departmentsListScreen);
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

  Column _buildCategoriesSection() {
    var categoryTitles = _presenter.categories.map((e) => e.name).toList();
    if (categoryTitles.isNotEmpty) {
      categoryTitles = categoryTitles.sublist(0, categoryTitles.length > 8 ? 8 : categoryTitles.length);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Category', style: TextStyle(color: Colors.black, fontSize: 14)),
        SizedBox(height: 8),
        _presenter.isLoadingCategories()
            ? Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()))
            : MultiSelectFilterChips(
                titles: categoryTitles,
                selectedIndices: [],
                allowMultipleSelection: true,
                showTrailingButton: true,
                trailingButtonTitle: 'More',
                onTrailingButtonPressed: () {
                  Navigator.pushNamed(context, RouteNames.taskCategoryListScreen);
                },
              ),
        SizedBox(height: 12),
      ],
    );
  }

  Column _buildEmployeesSection() {
    var employeeTitles = _presenter.employees.map((e) => e.fullName).toList();
    if (employeeTitles.isNotEmpty) {
      employeeTitles = employeeTitles.sublist(0, employeeTitles.length > 8 ? 8 : employeeTitles.length);
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Employee', style: TextStyle(color: Colors.black, fontSize: 14)),
        SizedBox(height: 8),
        _presenter.isLoadingEmployees()
            ? Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()))
            : MultiSelectFilterChips(
                titles: employeeTitles,
                selectedIndices: [2, 6],
                allowMultipleSelection: true,
                showTrailingButton: true,
                trailingButtonTitle: 'More',
                onTrailingButtonPressed: () {
                  Navigator.pushNamed(context, RouteNames.departmentsListScreen);
                },
              ),
        SizedBox(height: 12),
      ],
    );
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }
}
