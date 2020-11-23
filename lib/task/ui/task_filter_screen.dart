import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/filter_app_bar.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/constants/app_years.dart';
import 'package:wallpost/task/entities/department.dart';
import 'package:wallpost/task/entities/task_category.dart';
import 'package:wallpost/task/entities/task_employee.dart';
import 'package:wallpost/task/ui/presenters/task_filter_presenter.dart';

class TaskFilterScreen extends StatefulWidget {
  @override
  _TaskFilterScreenState createState() => _TaskFilterScreenState();
}

class _TaskFilterScreenState extends State<TaskFilterScreen>
    implements DepartmentsWrapView {
  TaskFilterPresenter _presenter;

  int _selectedYear = -1;
  int _selectedDepartment = 2;
  List<bool> _defaultSelectedDepartments;
  List<bool> _defaultSelectedCategories;
  List<Department> _selectedDepartments;
  List<TaskCategory> _selectedCategories;
  List<TaskEmployee> _selectedEmployees;
  int numberOfDefaultFilterTiles = 8;
  int numberOfDefaultCategoryTiles = 9;

  @override
  void initState() {
    _defaultSelectedDepartments = List.filled(9, false);
    _defaultSelectedCategories =
        List.filled(numberOfDefaultCategoryTiles, false);
    _presenter = TaskFilterPresenter(this);
    _presenter.loadNextListOfDepartments();
    _presenter.loadNextListOfCategories();
    numberOfDefaultCategoryTiles = _presenter.getNumberOfCategoryItems() > 8
        ? 9
        : _presenter.getNumberOfCategoryItems();
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
            _defaultSelectedDepartments = List.filled(9, false);
            _defaultSelectedCategories =
                List.filled(numberOfDefaultCategoryTiles + 1, false);
            _selectedYear = -1;
          });
        },
        onDoFilterPressed: () {
          Navigator.pop(context);
        },
        screenTitle: 'Filter',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: new ClampingScrollPhysics(),
          child: Column(
            children: [
              _buildYearSection('Years',
                  AppYears.years().map((y) => '$y').toList(), _selectedYear),
              _buildDepartmentSection(_selectedDepartment),
              _buildCategoriesSection(_selectedDepartment),
              _buildEmployeeSection(['Jaseel Kiliyan', 'jaseel']),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildEmployeeSection(List<String> _allButtons) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            alignment: AlignmentDirectional.topStart,
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
            child: Text('Employee',
                style: TextStyle(color: Colors.black, fontSize: 14))),
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Wrap(
              spacing: 10.0, // gap between lines
              children: List.generate(_allButtons.length, (index) {
                return RaisedButton(
                  onPressed: () {},
                  child: Text(_allButtons[index]),
                  textColor: AppColors.filtersTextGreyColor,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: AppColors.filtersBackgroundGreyColor,
                          width: .5),
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: AppColors.filtersBackgroundGreyColor,
                );
              })),
        ),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Divider(
            height: 4,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }

  Column _buildYearSection(
      String _sectionName, List<String> _allButtons, int _selectedPosition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            alignment: AlignmentDirectional.topStart,
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
            child: Text(_sectionName,
                style: TextStyle(color: Colors.black, fontSize: 14))),
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Wrap(
            spacing: 10.0, // gap between lines
            children: List.generate(
              _allButtons.length,
              (index) {
                return RaisedButton(
                  onPressed: () {
                    setState(() => _selectedYear = index);
                  },
                  child: Text(_allButtons[index]),
                  textColor: index == _selectedPosition
                      ? AppColors.defaultColor
                      : AppColors.filtersTextGreyColor,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: index == _selectedPosition
                              ? AppColors.defaultColor
                              : AppColors.filtersBackgroundGreyColor,
                          width: .5),
                      borderRadius: new BorderRadius.circular(10.0)),
                  color: AppColors.filtersBackgroundGreyColor,
                );
              },
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Divider(
            height: 4,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }

  Column _buildDepartmentSection(int _selectedPosition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            alignment: AlignmentDirectional.topStart,
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
            child: Text('Department',
                style: TextStyle(color: Colors.black, fontSize: 14))),
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Wrap(
            spacing: 10.0, // gap between lines
            children: List.generate(numberOfDefaultFilterTiles + 1, (index) {
              return RaisedButton(
                onPressed: () {
                  if (8 == index) {
                    Navigator.pushNamed(
                        context, RouteNames.departmentsListScreen);
                  } else {
                    setState(() => _defaultSelectedDepartments[index]
                        ? _defaultSelectedDepartments[index] = false
                        : _defaultSelectedDepartments[index] = true);
                  }
                },
                child: index != null
                    ? _presenter.getDepartmentTextAtIndex(
                        index, numberOfDefaultFilterTiles)
                    : _presenter.getDepartmentTextAtIndex(-1, 0),
                textColor: index != null
                    ? _defaultSelectedDepartments[index]
                        ? AppColors.defaultColor
                        : AppColors.filtersTextGreyColor
                    : '',
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: _defaultSelectedDepartments[index]
                            ? AppColors.defaultColor
                            : AppColors.filtersBackgroundGreyColor,
                        width: .5),
                    borderRadius: new BorderRadius.circular(10.0)),
                color: AppColors.filtersBackgroundGreyColor,
              );
            }),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Divider(
            height: 4,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }

  Column _buildCategoriesSection(int _selectedPosition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            alignment: AlignmentDirectional.topStart,
            margin: EdgeInsets.only(
                left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
            child: Text('Category',
                style: TextStyle(color: Colors.black, fontSize: 14))),
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Wrap(
            spacing: 10.0, // gap between lines
            children: List.generate(numberOfDefaultCategoryTiles + 1, (index) {
              return RaisedButton(
                onPressed: () {
                  if (numberOfDefaultCategoryTiles == index) {
                    Navigator.pushNamed(
                        context, RouteNames.taskCategoryListScreen);
                  } else {
                    setState(() => _defaultSelectedCategories[index]
                        ? _defaultSelectedCategories[index] = false
                        : _defaultSelectedCategories[index] = true);
                  }
                },
                child: index != null
                    ? _presenter.getCategoryTextAtIndex(
                        index, numberOfDefaultFilterTiles)
                    : _presenter.getCategoryTextAtIndex(-1, 0),
                textColor: index != null
                    ? _defaultSelectedCategories[index]
                        ? AppColors.defaultColor
                        : AppColors.filtersTextGreyColor
                    : '',
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                        color: _defaultSelectedCategories[index]
                            ? AppColors.defaultColor
                            : AppColors.filtersBackgroundGreyColor,
                        width: .5),
                    borderRadius: new BorderRadius.circular(10.0)),
                color: AppColors.filtersBackgroundGreyColor,
              );
            }),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 20.0),
          child: Divider(
            height: 4,
            color: AppColors.blackColor,
          ),
        ),
      ],
    );
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }
}
