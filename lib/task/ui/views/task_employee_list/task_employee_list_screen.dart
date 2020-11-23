import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/filter_app_bar.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar.dart';
import 'package:wallpost/task/ui/presenters/task_employees_list_presenter.dart';

class EmployeeListScreen extends StatefulWidget {
  @override
  _EmployeeListScreenState createState() => _EmployeeListScreenState();
}

class _EmployeeListScreenState extends State<EmployeeListScreen>
    implements EmployeeListView {
  var _searchBarController = TextEditingController();
  ScrollController _scrollController;
  EmployeeListPresenter _presenter;

  @override
  void initState() {
    _scrollController = ScrollController();
    _presenter = EmployeeListPresenter(this);
    _presenter.loadNextListOfEmployee();
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _presenter.loadNextListOfEmployee();
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
        onResetFiltersPressed: () {},
        onDoFilterPressed: () {
          Navigator.pop(context);
        },
        screenTitle: 'Select Category',
      ),
      body: Column(
        children: [
          SearchBar(
            hint: 'Search by category name',
            onSearchTextChanged: (searchText) {
              //TODO: filter by search text
            },
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                _presenter.reset();
                _presenter.loadNextListOfEmployee();
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
