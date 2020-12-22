import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/multi_select_filter_chips.dart';
import 'package:wallpost/_routing/route_names.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/leave/entities/leave_employee.dart';
import 'package:wallpost/leave/entities/leave_type.dart';
import 'package:wallpost/leave/ui/presenters/leave_list_filter_presenter.dart';

class LeaveListFilterScreen extends StatefulWidget {
  @override
  _LeaveListFilterScreenState createState() => _LeaveListFilterScreenState();
}

class _LeaveListFilterScreenState extends State<LeaveListFilterScreen> implements LeaveListView {
  LeaveListFilterPresenter _presenter;
  List<LeaveType> leaveTypes;
  bool isFilteredLeaveType = false;
  List<LeaveEmployee> filteredEmployees;
  bool isFromEmployeeFilter = false;

  var _categoryFilterController = MultiSelectFilterChipsController();
  var _employeesFilterController = MultiSelectFilterChipsController();
  var _leaveTypeFilterController = MultiSelectFilterChipsController();

  @override
  void initState() {
    _presenter = LeaveListFilterPresenter(this);
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
        leadingSpace: 0,
        trailingSpace: 0,
        leading: RoundedIconButton(
          iconName: 'assets/icons/close_icon.svg',
          iconColor: AppColors.defaultColor,
          color: Colors.transparent,
          onPressed: () => Navigator.pop(context),
        ),
        trailing: Row(
          children: [
            RoundedIconButton(
              iconName: 'assets/icons/reset_icon.svg',
              iconColor: AppColors.defaultColor,
              color: Colors.transparent,
              onPressed: () => _resetData(),
            ),
            SizedBox(width: 8),
            RoundedIconButton(
              iconName: 'assets/icons/check.svg',
              iconColor: AppColors.defaultColor,
              color: Colors.transparent,
              onPressed: () => _updateAllSelectedFilters(),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [_buildCategoryList(), Divider(), _buildLeaveTypeList(), Divider(), _buildEmployeeList()],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryList() {
    var _categoryList = ["All", "Current", "History"];
    var selectedCategoryIndex = _categoryList.indexOf("Current");

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Category', style: TextStyle(color: Colors.black, fontSize: 14)),
        SizedBox(height: 8),
        MultiSelectFilterChips(
          titles: _categoryList,
          selectedIndices: [selectedCategoryIndex],
          controller: _categoryFilterController,
          allowMultipleSelection: false,
          onItemSelected: (selectedIndex) => {_categoryList[selectedIndex]},
          onItemDeselected: (selectedIndex) {
            setState(() => {});
          },
        ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildLeaveTypeList() {
    var leaveTypeTitles = isFilteredLeaveType
        ? leaveTypes.map((e) => e.name).toList()
        : _presenter.leaveTypes.map((e) => e.name).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: 12),
        Text('Leave Type', style: TextStyle(color: Colors.black, fontSize: 14)),
        SizedBox(height: 8),
        _presenter.isLoadingLeaveTypes()
            ? Center(child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator()))
            : MultiSelectFilterChips(
                titles: leaveTypeTitles,
                selectedIndices: [],
                allowMultipleSelection: true,
                allIndexesSelected: isFilteredLeaveType,
                controller: _leaveTypeFilterController,
                onItemSelected: (index) {
                  //select item
                },
              ),
        SizedBox(height: 12),
      ],
    );
  }

  Widget _buildEmployeeList() {
    var employeeTitles = isFromEmployeeFilter
        ? filteredEmployees.map((e) => e.fullName).toList()
        : _presenter.employees.map((e) => e.fullName).toList();
    if (employeeTitles.isNotEmpty && !isFromEmployeeFilter) {
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
    final selectedEmployees = await Navigator.pushNamed(context, RouteNames.leaveEmployeeListScreen);

    filteredEmployees = selectedEmployees;
    isFromEmployeeFilter = true;
    _presenter.loadFilteredEmployees(filteredEmployees);
  }

  void _updateAllSelectedFilters() {
    //use after selection
    //move to parent page
  }

  void _resetData() {
    if (this.mounted) setState(() {});
  }

  void setStateIfMounted(VoidCallback callback) {
    if (this.mounted == false) return;
    setState(() => callback());
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }
}
