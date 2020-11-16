import 'package:flutter/material.dart';
import 'package:wallpost/task/ui/presenters/departments_list_presenter.dart';

class DepartmentsListScreen extends StatefulWidget {
  @override
  _DepartmentsListScreenState createState() => _DepartmentsListScreenState();
}

class _DepartmentsListScreenState extends State<DepartmentsListScreen> implements DepartmentsListView {
  var _searchBarController = TextEditingController();
  ScrollController _scrollController;
  DepartmentsListPresenter _presenter;

  @override
  void initState() {
    _scrollController = ScrollController();
    _presenter = DepartmentsListPresenter(this);
    _presenter.loadNextListOfDepartments();
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _presenter.loadNextListOfDepartments();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
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