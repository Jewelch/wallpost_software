import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/_list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/_list_view/loader_list_tile.dart';
import 'package:wallpost/_common_widgets/chips/custom_chip.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/task/entities/task_category.dart';
import 'package:wallpost/task/services/task_categories_list_provider.dart';
import 'package:wallpost/task/ui/views/categories_list/categories_list_tile.dart';

abstract class CategoriesListView {
  void reloadData();

  void onCategoryAdded();

  void onCategoryRemoved();
}

class CategoriesListPresenter {
  final CategoriesListView _view;
  final TaskCategoriesListProvider _provider;
  List<TaskCategory> _categories = [];
  List<TaskCategory> _selectedCategories = [];
  String _errorMessage;
  String _searchText;

  CategoriesListPresenter(this._view) : _provider = TaskCategoriesListProvider();

  Future<void> loadNextListOfCategories(String searchText) async {
    if (_provider.isLoading || _provider.didReachListEnd) return null;

    _searchText = searchText;
    _resetErrors();

    try {
      var categoriesList = await _provider.getNext(searchText: _searchText);
      _categories.addAll(categoriesList);
      _view.reloadData();
    } on WPException catch (e) {
      _errorMessage = e.userReadableMessage;
      _view.reloadData();
    }
  }

  //MARK: Functions to get category list count and views

  int getNumberOfCategories() {
    if (_hasErrors()) return _categories.length + 1;

    if (_categories.isEmpty) return 1;

    if (_provider.didReachListEnd) {
      return _categories.length;
    } else {
      return _categories.length + 1;
    }
  }

  Widget getCategoryViewForIndex(int index) {
    if (_shouldShowErrorAtIndex(index)) return _buildErrorView(_errorMessage);

    if (_categories.isEmpty) return _buildViewWhenThereAreNoResults();

    if (index < _categories.length) {
      return _buildCategoryViewForIndex(index);
    } else {
      return LoaderListTile();
    }
  }

  bool _shouldShowErrorAtIndex(int index) {
    return _hasErrors() && index == _categories.length;
  }

  Widget _buildErrorView(String errorMessage) {
    return ErrorListTile(
      '$errorMessage Tap here to reload.',
      onTap: () {
        loadNextListOfCategories(_searchText);
        _view.reloadData();
      },
    );
  }

  Widget _buildViewWhenThereAreNoResults() {
    if (_provider.didReachListEnd) {
      return ErrorListTile(
        'There are no categories to show. Tap here to reload.',
        onTap: () {
          _provider.reset();
          loadNextListOfCategories(_searchText);
          _view.reloadData();
        },
      );
    } else {
      return LoaderListTile();
    }
  }

  Widget _buildCategoryViewForIndex(int index) {
    return CategoryListTile(
      isCategorySelected(_categories[index]),
      _categories[index],
      onCategoryListTileTap: () {
        if (isCategorySelected(_categories[index])) {
          _selectedCategories.removeWhere((selectedCategory) => selectedCategory.name == _categories[index].name);
          _view.onCategoryRemoved();
        } else {
          _selectedCategories.add(_categories[index]);
          _view.onCategoryAdded();
        }
      },
    );
  }

  //MARK: Functions to get selected category count and views

  List<TaskCategory> getSelectedCategoriesList() {
    return _selectedCategories;
  }

  int getNumberOfSelectedCategories() {
    return _selectedCategories.length;
  }

  Widget getSelectedCategoryViewForIndex(int index) {
    return CustomChip(
      title: Text(_selectedCategories[index].name),
      backgroundColor: AppColors.primaryContrastColor,
      shape: CustomChipShape.capsule,
      icon: SvgPicture.asset(
        'assets/icons/close_icon.svg',
        width: 12,
        height: 12,
        color: Colors.black,
      ),
      onPressed: () {
        _selectedCategories.removeAt(index);
        _view.onCategoryRemoved();
      },
    );
  }

  //MARK: Util functions

  void reset() {
    _categories.clear();
    _provider.reset();
    _resetErrors();
    _view.reloadData();
  }

  void resetFilter() {
    _selectedCategories.clear();
    _view.reloadData();
  }

  void _resetErrors() {
    _errorMessage = null;
  }

  bool _hasErrors() {
    return _errorMessage != null;
  }

  bool isCategorySelected(TaskCategory category) {
    for (TaskCategory selectedCategory in _selectedCategories) {
      if (selectedCategory.name == category.name) return true;
    }

    return false;
  }
}
