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
  final List<TaskCategory> _categories = [];
  final TaskCategoryListProvider _provider = TaskCategoryListProvider();
  final _filterListController = MultiSelectFilterListController();

  @override
  void initState() {
    getCategories();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiSelectFilterList(
      screenTitle: 'Select Category',
      items: [],
      selectedItems: widget._filters.categories.map((e) => e.name).toList(),
      searchBarHint: 'Search by category name',
      noItemsMessage: 'There are no categories to show.',
      controller: _filterListController,
      onRefresh: () {
        _provider.reset();
        _categories.clear();
        getCategories();
      },
      onRetry: () {
        getCategories();
      },
      didReachEndOfList: () {
        getCategories();
      },
      onSearchTextChanged: (_) {
        _provider.reset();
        _categories.clear();
        getCategories();
      },
      onFiltersSelectionComplete: () {
        var selectedIndices = _filterListController.getSelectedIndices();
        List<TaskCategory> selectedCategories = [];
        for (int index in selectedIndices) {
          selectedCategories.add(_categories[index]);
        }
        Navigator.pop(context, selectedCategories);
      },
    );
  }

  void getCategories() async {
    if (_provider.isLoading) return;

    try {
      var categoryList = await _provider.getNext(searchText: _filterListController.getSearchText());
      _categories.addAll(categoryList);
      _filterListController.addItems(categoryList.map((e) => e.name).toList());
      if(_provider.didReachListEnd) _filterListController.reachedListEnd();
    } on WPException catch (e) {
      _filterListController.showError(e.userReadableMessage);
    }
  }
}
