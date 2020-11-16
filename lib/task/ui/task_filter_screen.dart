import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/filter_app_bar.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/constants/app_years.dart';

class TaskFilterScreen extends StatefulWidget {
  @override
  _TaskFilterScreenState createState() => _TaskFilterScreenState();
}

class _TaskFilterScreenState extends State<TaskFilterScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int _selectedYear = 0;
    int _selectedDepartment = 2;
    int _selectedCategory = 4;
    int _selectedEmployee = 1;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: FilterAppBar(
        onBackPressed: () {
          print('back');
          Navigator.pop(context);
        },
        onResetFiltersPressed: () {},
        onDoFilterPressed: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: new ClampingScrollPhysics(),
          child: Column(
            children: [
              _buildFilterSection('Years', AppYears.years().map((y) => '$y').toList(), _selectedYear),
              _buildFilterSection(
                  'Department',
                  ['Product Research and Development', 'Finance', 'HR', 'Development', 'IT', 'more..'],
                  _selectedDepartment),
              _buildFilterSection('Category',
                  ['UX/UI', 'Design', 'Transportation', 'Catering', 'PHP', 'Mobile', 'more..'], _selectedCategory),
              _buildFilterSection('Employee', ['Jaseel Kiliyan', 'jaseel'], _selectedEmployee),
            ],
          ),
        ),
      ),
    );
  }

  Column _buildFilterSection(String _sectionName, List<String> _allButtons, int _selectedPosition) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            alignment: AlignmentDirectional.topStart,
            margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 15.0, bottom: 10.0),
            child: Text(_sectionName, style: TextStyle(color: Colors.black, fontSize: 14))),
        Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0),
          child: Wrap(
              spacing: 10.0, // gap between lines
              children: List.generate(_allButtons.length, (index) {
                return RaisedButton(
                  onPressed: () {},
                  child: Text(_allButtons[index]),
                  textColor: index == _selectedPosition ? AppColors.defaultColor : AppColors.blackColor,
                  shape: RoundedRectangleBorder(
                      side: BorderSide(
                          color: index == _selectedPosition
                              ? AppColors.defaultColor
                              : AppColors.filtersBackgroundGreyColor,
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
}
