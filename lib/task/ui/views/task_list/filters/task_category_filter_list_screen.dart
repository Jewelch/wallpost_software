// @dart=2.9

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/filter_views/multi_select_filters_list.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/task_category.dart';
import 'package:wallpost/task/entities/task_list_filters.dart';
import 'package:wallpost/task/services/task_category_list_provider.dart';

class TaskCategoryFilterListScreen extends StatefulWidget {
  final TaskListFilters _filters;

  TaskCategoryFilterListScreen(this._filters);

  @override
  _TaskCategoryFilterListScreenState createState() => _TaskCategoryFilterListScreenState();
}

class _TaskCategoryFilterListScreenState extends State<TaskCategoryFilterListScreen> {
  final TaskCategoryListProvider _provider = TaskCategoryListProvider();
  final List<TaskCategory> _categories = [];
  final List<TaskCategory> _selectedCategories = [];
  var _searchText = '';
  bool _showMessage = false;
  String _message;

  @override
  void initState() {
    _selectedCategories.addAll(widget._filters.categories);
    _getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: MultiSelectFilterList(
            screenTitle: 'Select Categories',
            items: _categories.map((e) => e.name).toList(),
            selectedItems: _selectedCategories.map((e) => e.name).toList(),
            searchBarHint: 'Search by category name',
            showMessage: _showMessage,
            message: _message,
            showLoaderAtEnd: _provider.didReachListEnd ? false : true,
            onSearchTextChanged: (searchText) {
              _provider.reset();
              _categories.clear();
              _searchText = searchText;
              _getCategories();
            },
            onRefresh: () {
              setState(() => _categories.clear());
              _provider.reset();
              _getCategories();
            },
            onRetry: () {
              setState(() => _getCategories());
            },
            didReachEndOfList: () {
              _getCategories();
            },
            onFilterSelected: (title) {
              setState(() {
                _selectedCategories.add(_categories.firstWhere((e) => e.name == title));
              });
            },
            onFilterDeselected: (title) {
              setState(() {
                _selectedCategories.removeWhere((e) => e.name == title);
              });
            },
            onFilterSelectionComplete: () {
              widget._filters.categories.clear();
              widget._filters.categories.addAll(_selectedCategories);
              Navigator.pop(context, true);
            },
          ),
        ),
      ],
    );
  }

  void _getCategories() async {
    if (_provider.isLoading) return;

    setState(() => _showMessage = false);
    try {
      var categoryList = await _provider.getNext(searchText: _searchText);
      setState(() {
        _categories.addAll(categoryList);
        if (_categories.length == 0) {
          _showMessage = true;
          _message = 'There are no categories to show.';
        }
      });
    } on WPException catch (error) {
      setState(() {
        _showMessage = true;
        _message = error.userReadableMessage;
      });
    }
  }
}
