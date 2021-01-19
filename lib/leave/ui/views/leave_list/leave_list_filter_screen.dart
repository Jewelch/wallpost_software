import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_check_mark_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_close_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filter_chips.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/leave/entities/leave_list_filters.dart';
import 'package:wallpost/leave/ui/presenters/leave_list_filters_presenter.dart';
import 'package:wallpost/leave/ui/views/leave_employee_list/leave_employee_list_filter_screen.dart';

class LeaveListFilterScreen extends StatefulWidget {
  final LeaveListFilters _filters;

  LeaveListFilterScreen(this._filters);

  @override
  _LeaveListFilterScreenState createState() => _LeaveListFilterScreenState(_filters);
}

class _LeaveListFilterScreenState extends State<LeaveListFilterScreen> implements LeaveListFiltersView {
  LeaveListFilterPresenter _presenter;
  LeaveListFilters _filters;

  _LeaveListFilterScreenState(this._filters);

  @override
  void initState() {
    _presenter = LeaveListFilterPresenter(this, _filters);
    _presenter.loadLeaveType();
    _presenter.loadEmployees();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
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
            onPressed: () => Navigator.pop(context, _filters),
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: new ClampingScrollPhysics(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildCategoryView(),
              Divider(),
              _buildLeaveTypeView(),
              Divider(),
              _buildEmployeeView(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Category', style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        SizedBox(height: 8),
        MultiSelectFilterChips(
          titles: _presenter.getDurations(),
          selectedIndices: [_presenter.getSelectedDurationIndex()],
          allowMultipleSelection: false,
          onItemSelected: (selectedIndex) {
            if (selectedIndex == 0) {
              _presenter.showAllLeaves();
            } else if (selectedIndex == 1) {
              _presenter.showCurrentLeaves();
            } else {
              _presenter.showLeaveHistory();
            }
          },
          onItemDeselected: (selectedIndex) {
            _presenter.showAllLeaves();
            setState(() {});
          },
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildLeaveTypeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Leave Type', style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black)),
        SizedBox(height: 8),
        _presenter.isLoadingLeaveTypes()
            ? Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()))
            : MultiSelectFilterChips(
                titles: _presenter.getLeaveType().map((e) => e.name).toList(),
                selectedIndices: [_presenter.getSelectedLeaveTypeIndex()],
                allowMultipleSelection: true,
                onItemSelected: (index) => _presenter.selectLeaveTypeAtIndex(index),
                onItemDeselected: (index) => _presenter.deselectLeaveTypeAtIndex(index),
              ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildEmployeeView() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text(
          'Employee',
          style: TextStyles.subTitleTextStyle.copyWith(color: Colors.black),
        ),
        SizedBox(height: 8),
        _presenter.isLoadingEmployees()
            ? Center(
                child: SizedBox(
                  width: 30,
                  height: 30,
                  child: CircularProgressIndicator(),
                ),
              )
            : MultiSelectFilterChips(
                titles: _presenter.getApplicant().map((e) => e.fullName).toList(),
                selectedIndices: _presenter.getSelectedApplicantIndices(),
                allowMultipleSelection: true,
                showTrailingButton: true,
                trailingButtonTitle: 'More',
                onTrailingButtonPressed: () => goToEmployeesFilterList(),
                onItemSelected: (index) => _presenter.selectApplicantAtIndex(index),
                onItemDeselected: (index) => _presenter.deselectApplicantAtIndex(index),
              ),
        SizedBox(height: 12),
      ],
    );
  }

  void goToEmployeesFilterList() async {
    var didSelectApplicants = await ScreenPresenter.present(LeaveEmployeeListFilterScreen(_filters), context) as bool;
    if (didSelectApplicants != null && didSelectApplicants == true) {
      _presenter.loadEmployees();
    }
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }

  @override
  void resetAndReloadData() {
    _presenter.loadEmployees();
    _presenter.loadLeaveType();
    if (this.mounted) setState(() {});
  }
}
