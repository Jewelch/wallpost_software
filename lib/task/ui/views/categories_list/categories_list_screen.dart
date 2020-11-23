import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/filter_app_bar.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar.dart';
import 'package:wallpost/task/ui/presenters/categories_list_presenter.dart';

class CategoriesListScreen extends StatefulWidget {
  @override
  _CategoriesListScreenState createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen>
    implements CategoriesListView {
  var _searchBarController = TextEditingController();
  ScrollController _scrollController;
  CategoriesListPresenter _presenter;

  @override
  void initState() {
    _scrollController = ScrollController();
    _presenter = CategoriesListPresenter(this);
    _presenter.loadNextListOfCategories();
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        _presenter.loadNextListOfCategories();
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
                _presenter.loadNextListOfCategories();
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
