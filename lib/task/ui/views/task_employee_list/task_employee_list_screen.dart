import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_back_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_check_mark_button.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/task/ui/presenters/task_employees_list_presenter.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen> implements EmployeesListView {
  var _searchBarController = TextEditingController();
  ScrollController _employeesListScrollController = ScrollController();
  ScrollController _selectedEmployeesListScrollController = ScrollController();
  EmployeesListPresenter _presenter;

  @override
  void initState() {
    _presenter = EmployeesListPresenter(this);
    _presenter.loadNextListOfEmployees(_searchBarController.text);
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _employeesListScrollController.addListener(() {
      if (_employeesListScrollController.position.pixels == _employeesListScrollController.position.maxScrollExtent) {
        _presenter.loadNextListOfEmployees(_searchBarController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: 'Select Employee',
        leadingButtons: [
          CircularBackButton(
            iconColor: AppColors.defaultColor,
            color: Colors.transparent,
            onPressed: () => Navigator.pop(context),
          )
        ],
        trailingButtons: [
          CircularCheckMarkButton(
            iconColor: AppColors.defaultColor,
            color: Colors.transparent,
            onPressed: () => Navigator.pop(context, _presenter.getSelectedEmployeesList()),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          SearchBar(
            hint: 'Search by employee name',
            controller: _searchBarController,
            onSearchTextChanged: (searchText) {
              _presenter.reset();
              _presenter.loadNextListOfEmployees(searchText);
            },
          ),
          SizedBox(height: 8),
          SizedBox(
            height: _presenter.getNumberOfSelectedEmployees() == 0 ? 0 : 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _selectedEmployeesListScrollController,
              children: List.generate(
                _presenter.getNumberOfSelectedEmployees(),
                (index) {
                  var edgeInsets = EdgeInsets.only(left: 12);
                  if (index == _presenter.getNumberOfSelectedEmployees() - 1)
                    edgeInsets = edgeInsets.copyWith(right: 12);

                  return Padding(
                    padding: edgeInsets,
                    child: _presenter.getSelectedEmployeeViewForIndex(index),
                  );
                },
              ),
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                _presenter.reset();
                _presenter.loadNextListOfEmployees(_searchBarController.text);
                return Future.value(null);
              },
              child: ListView.builder(
                controller: _employeesListScrollController,
                itemCount: _presenter.getNumberOfEmployees(),
                itemBuilder: (context, index) {
                  return _presenter.getEmployeeViewForIndex(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void reloadData() {
    if (this.mounted) setState(() {});
  }

  @override
  void onEmployeeAdded() {
    if (this.mounted) setState(() {});

    Future.delayed(Duration(milliseconds: 200)).then((value) {
      _selectedEmployeesListScrollController.animateTo(_selectedEmployeesListScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }

  @override
  void onEmployeeRemoved() {
    if (this.mounted) setState(() {});
  }
}
