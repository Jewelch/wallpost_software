import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_icon_button.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/task/ui/presenters/categories_list_presenter.dart';

class CategoriesListScreen extends StatefulWidget {
  @override
  _CategoriesListScreenState createState() => _CategoriesListScreenState();
}

class _CategoriesListScreenState extends State<CategoriesListScreen> implements CategoriesListView {
  var _searchBarController = TextEditingController();
  ScrollController _categoriesListScrollController = ScrollController();
  ScrollController _selectedCategoriesListScrollController = ScrollController();
  CategoriesListPresenter _presenter;

  @override
  void initState() {
    _presenter = CategoriesListPresenter(this);
    _presenter.loadNextListOfCategories(_searchBarController.text);
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _categoriesListScrollController.addListener(() {
      if (_categoriesListScrollController.position.pixels == _categoriesListScrollController.position.maxScrollExtent) {
        _presenter.loadNextListOfCategories(_searchBarController.text);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: 'Select Category',
        leadingSpace: 0,
        trailingSpace: 12,
        leading: RoundedBackButton(onPressed: () => Navigator.pop(context)),
        trailing: RoundedIconButton(
          iconName: 'assets/icons/check.svg',
          iconSize: 20,
          iconColor: AppColors.defaultColor,
          color: Colors.white,
          onPressed: () => Navigator.pop(context, _presenter.getSelectedCategoriesList()),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          SearchBar(
            hint: 'Search by category name',
            controller: _searchBarController,
            onSearchTextChanged: (searchText) {
              _presenter.reset();
              _presenter.loadNextListOfCategories(searchText);
            },
          ),
          SizedBox(height: 8),
          SizedBox(
            height: _presenter.getNumberOfSelectedCategories() == 0 ? 0 : 32,
            child: ListView(
              scrollDirection: Axis.horizontal,
              controller: _selectedCategoriesListScrollController,
              children: List.generate(
                _presenter.getNumberOfSelectedCategories(),
                (index) {
                  var edgeInsets = EdgeInsets.only(left: 12);
                  if (index == _presenter.getNumberOfSelectedCategories() - 1)
                    edgeInsets = edgeInsets.copyWith(right: 12);

                  return Padding(
                    padding: edgeInsets,
                    child: _presenter.getSelectedCategoryViewForIndex(index),
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
                _presenter.loadNextListOfCategories(_searchBarController.text);
                return Future.value(null);
              },
              child: ListView.builder(
                controller: _categoriesListScrollController,
                itemCount: _presenter.getNumberOfCategories(),
                itemBuilder: (context, index) {
                  return _presenter.getCategoryViewForIndex(index);
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
  void onCategoryAdded() {
    if (this.mounted) setState(() {});

    Future.delayed(Duration(milliseconds: 200)).then((value) {
      _selectedCategoriesListScrollController.animateTo(
          _selectedCategoriesListScrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut);
    });
  }

  @override
  void onCategoryRemoved() {
    if (this.mounted) setState(() {});
  }
}
