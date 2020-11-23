import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/_list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/_list_view/loader_list_tile.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/department.dart';
import 'package:wallpost/task/entities/task_category.dart';
import 'package:wallpost/task/services/task_categories_list_provider.dart';
import 'package:wallpost/task/ui/views/categories_list/categories_list_tile.dart';

abstract class CategoriesListView {
  void reloadData();
}

class CategoriesListPresenter {
  final CategoriesListView view;
  final TaskCategoriesListProvider provider;
  List<TaskCategory> categories = [];
  String _errorMessage;

  CategoriesListPresenter(this.view) : provider = TaskCategoriesListProvider();

  CategoriesListPresenter.initWith(this.view, this.provider);

  Future<void> loadNextListOfCategories() async {
    if (provider.isLoading || provider.didReachListEnd) return null;

    _resetErrors();
    try {
      var categoriesList = await provider.getNext();
      categories.addAll(categoriesList);
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      view.reloadData();
    }
  }

  Future<List<Department>> getListOfDepartments() async {
    if (provider.isLoading || provider.didReachListEnd) return null;

    _resetErrors();
    try {
      var categoriesList = await provider.getNext();
      view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
    }
  }

  int getNumberOfItems() {
    if (_hasErrors()) return categories.length + 1;

    if (categories.isEmpty) return 1;

    if (provider.didReachListEnd) {
      return categories.length;
    } else {
      return categories.length + 1;
    }
  }

  Widget getViewAtIndex(int index) {
    if (_shouldShowErrorAtIndex(index))
      return ErrorListTile('$_errorMessage\nTap here to reload.');

    if (categories.isEmpty) return _buildViewWhenThereAreNoResults();

    if (index < categories.length) {
      return CategoryListTile(categories[index]);
    } else {
      return LoaderListTile();
    }
  }

  bool _shouldShowErrorAtIndex(int index) {
    return _hasErrors() && index == categories.length;
  }

  Widget _buildViewWhenThereAreNoResults() {
    if (provider.didReachListEnd) {
      return ErrorListTile(
          'There are no categories to show. Tap here to reload.');
    } else {
      return LoaderListTile();
    }
  }

  //MARK: Util functions

  void reset() {
    provider.reset();
    _resetErrors();
    categories.clear();
    view.reloadData();
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }
}
