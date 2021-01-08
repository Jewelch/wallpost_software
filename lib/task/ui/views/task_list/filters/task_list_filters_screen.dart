import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_check_mark_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_close_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filter_chips.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';
import 'package:wallpost/task/ui/presenters/task_list_filters_presenter.dart';

import 'task_assignee_filter_list_screen.dart';
import 'task_category_filter_list_screen.dart';
import 'task_department_filter_list_screen.dart';

class TaskListFiltersScreen extends StatefulWidget {
  final TaskListFilters _filters;

  TaskListFiltersScreen(this._filters);

  @override
  _TaskListFiltersScreenState createState() => _TaskListFiltersScreenState(_filters);
}

class _TaskListFiltersScreenState extends State<TaskListFiltersScreen> implements DepartmentsWrapView {
  TaskListFiltersPresenter _presenter;
  TaskListFilters _filters;

  _TaskListFiltersScreenState(this._filters);

  @override
  void initState() {
    _presenter = TaskListFiltersPresenter(this, _filters);
    _presenter.loadDepartments();
    _presenter.loadCategories();
    _presenter.loadAssignees();
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

  PreferredSizeWidget _buildAppBar() {
    return SimpleAppBar(
      title: 'Filters',
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
          onPressed: () => _presenter.resetFilters(),
        ),
        CircularCheckMarkButton(
          iconColor: AppColors.defaultColor,
          color: Colors.transparent,
          onPressed: () {},
        ),
      ],
    );
  }

  Column _buildYearSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Year', style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        SizedBox(height: 8),
        MultiSelectFilterChips(
          titles: _presenter.getYears().map((year) => '$year').toList(),
          selectedIndices: [_presenter.getSelectedYearIndex()],
          allowMultipleSelection: false,
          onItemSelected: (index) => _presenter.selectYearAtIndex(index),
          onItemDeselected: (_) => _presenter.resetYearFilter(),
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Column _buildDepartmentSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Department', style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        SizedBox(height: 8),
        _presenter.isLoadingDepartments()
            ? Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()))
            : MultiSelectFilterChips(
                titles: _presenter.getDepartments().map((e) => e.name).toList(),
                selectedIndices: _presenter.getSelectedDepartmentIndices(),
                allowMultipleSelection: true,
                showTrailingButton: true,
                trailingButtonTitle: 'More',
                onTrailingButtonPressed: () => goToDepartmentFilterList(),
                onItemSelected: (index) => _presenter.selectDepartmentAtIndex(index),
                onItemDeselected: (index) => _presenter.deselectDepartmentAtIndex(index),
              ),
        SizedBox(height: 12),
      ],
    );
  }

  void goToDepartmentFilterList() async {
    var didSelectFilters = await ScreenPresenter.present(TaskDepartmentFilterListScreen(_filters), context) as bool;
    if (didSelectFilters != null && didSelectFilters == true) {
      _presenter.loadDepartments();
    }
  }

  Column _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Category', style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        SizedBox(height: 8),
        _presenter.isLoadingCategories()
            ? Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()))
            : MultiSelectFilterChips(
                titles: _presenter.getCategories().map((e) => e.name).toList(),
                selectedIndices: _presenter.getSelectedCategoryIndices(),
                allowMultipleSelection: true,
                showTrailingButton: true,
                trailingButtonTitle: 'More',
                onTrailingButtonPressed: () => goToCategoryFilterList(),
                onItemSelected: (index) => _presenter.selectCategoryAtIndex(index),
                onItemDeselected: (index) => _presenter.deselectCategoryAtIndex(index),
              ),
        SizedBox(height: 12),
      ],
    );
  }

  void goToCategoryFilterList() async {
    var didSelectFilters = await ScreenPresenter.present(TaskCategoryFilterListScreen(_filters), context) as bool;
    if (didSelectFilters != null && didSelectFilters == true) {
      _presenter.loadCategories();
    }
  }

  Column _buildEmployeesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Employee', style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        SizedBox(height: 8),
        _presenter.isLoadingEmployees()
            ? Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()))
            : MultiSelectFilterChips(
                titles: _presenter.getAssignees().map((e) => e.fullName).toList(),
                selectedIndices: _presenter.getSelectedAssigneeIndices(),
                allowMultipleSelection: true,
                showTrailingButton: true,
                trailingButtonTitle: 'More',
                onTrailingButtonPressed: () => goToEmployeeFilterList(),
                onItemSelected: (index) => _presenter.selectAssigneeAtIndex(index),
                onItemDeselected: (index) => _presenter.deselectAssigneeAtIndex(index),
              ),
        SizedBox(height: 12),
      ],
    );
  }

  void goToEmployeeFilterList() async {
    var didSelectFilters = await ScreenPresenter.present(TaskAssigneeFilterListScreen(_filters), context) as bool;
    if (didSelectFilters != null && didSelectFilters == true) {
      _presenter.loadAssignees();
    }
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }

  @override
  void resetAndReloadData() {
    _presenter.loadDepartments();
    _presenter.loadCategories();
    _presenter.loadAssignees();
    if (this.mounted) setState(() {});
  }
}
