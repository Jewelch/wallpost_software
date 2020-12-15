import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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

class _LeaveListFilterScreenState extends State<LeaveListFilterScreen>
    implements LeaveListView {
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
      appBar: AppBar(
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
                    onPressed: () => {_updateAllSelectedFilters()},
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
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCategoryList(),
            Divider(),
            _buildLeaveTypeList(),
            Divider(),
            _buildEmployeeList()
          ],
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
            ? Center(
                child: SizedBox(
                    width: 30, height: 30, child: CircularProgressIndicator()))
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
        await Navigator.pushNamed(context, RouteNames.leaveEmployeeListScreen);

    filteredEmployees = selectedEmployees;
    isFromEmployeeFilter = true;
    _presenter.loadFilteredEmployees(filteredEmployees);
  }

  void _updateAllSelectedFilters() {
    //use after selection
    //move to parent page
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }
}
