import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/filter_app_bar.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar.dart';
import 'package:wallpost/task/entities/department.dart';
import 'package:wallpost/task/ui/presenters/departments_list_presenter.dart';

class DepartmentsListScreen extends StatefulWidget {
  @override
  _DepartmentsListScreenState createState() => _DepartmentsListScreenState();
}

class _DepartmentsListScreenState extends State<DepartmentsListScreen>
    implements DepartmentsListView, SelectedDepartmentsListView {
  var _searchBarController = TextEditingController();
  ScrollController _scrollController;
  DepartmentsListPresenter _presenter;

  @override
  void initState() {
    _scrollController = ScrollController();
    _presenter = DepartmentsListPresenter(this, this);
    _presenter.loadNextListOfDepartments();
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _presenter.loadNextListOfDepartments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: FilterAppBar(
        onBackPressed: () {
          print('back');
          Navigator.pop(context);
        },
        onResetFiltersPressed: () {
          _presenter.resetFilter();
        },
        onDoFilterPressed: () {
          List<Department> SelectedFilterDepartments =
              _presenter.selectedDepartments;
          Navigator.pop(context, SelectedFilterDepartments);
        },
        screenTitle: 'Select Department',
      ),
      body: Column(
        children: [
          SearchBar(
            hint: 'Search by department name',
            onSearchTextChanged: (searchText) {
              _presenter.performFilter(searchText);
            },
          ),
          _presenter.getSelectedFilterSection(),
          Divider(
            height: 1,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                _presenter.reset();
                _presenter.loadNextListOfDepartments();
                return null;
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _presenter.getNumberOfItems(),
                itemBuilder: (context, index) {
                  return _presenter.getViewAtIndex(index);
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
}
