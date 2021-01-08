import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_back_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_check_mark_button.dart';
import 'package:wallpost/_common_widgets/filter_views/selected_filters_view.dart';
import 'package:wallpost/_common_widgets/list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/list_view/loader_list_tile.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class MultiSelectFilterList extends StatefulWidget {
  final String screenTitle;
  final List<String> items;
  final List<String> selectedItems;
  final bool singleSelection;
  final String searchBarHint;
  final bool hideSearchBar;
  final bool showMessage;
  final String message;
  final bool showLoaderAtEnd;
  final VoidCallback onRefresh;
  final VoidCallback onRetry;
  final VoidCallback didReachEndOfList;
  final Function(String) onSearchTextChanged;
  final Function(String) onFilterSelected;
  final Function(String) onFilterDeselected;
  final VoidCallback onFilterSelectionComplete;

  MultiSelectFilterList({
    this.screenTitle,
    this.items,
    this.selectedItems,
    this.singleSelection = false,
    this.searchBarHint = '',
    this.hideSearchBar = false,
    this.showMessage,
    this.message,
    this.showLoaderAtEnd = true,
    this.onRefresh,
    this.onRetry,
    this.didReachEndOfList,
    this.onSearchTextChanged,
    this.onFilterSelected,
    this.onFilterDeselected,
    this.onFilterSelectionComplete,
  });

  @override
  _MultiSelectFilterListState createState() => _MultiSelectFilterListState();
}

class _MultiSelectFilterListState extends State<MultiSelectFilterList> {
  var _scrollController = ScrollController();
  var _searchBarController = TextEditingController();
  var _selectedFiltersViewController = SelectedFiltersViewController();
  Completer<void> _refreshIndicatorCompleter;
  bool _isRefreshing = false;

  @override
  void initState() {
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        widget.didReachEndOfList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_isRefreshing) _stopRefresh();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: widget.screenTitle,
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
            onPressed: () => widget.onFilterSelectionComplete(),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          if (widget.hideSearchBar == false)
            SearchBar(
              hint: widget.searchBarHint,
              controller: _searchBarController,
              onSearchTextChanged: (searchText) {
                widget.onSearchTextChanged(searchText);
              },
            ),
          if (widget.hideSearchBar == false) SizedBox(height: 8),
          SizedBox(
            height: widget.items.length > 0 && widget.singleSelection == false ? 32 : 0,
            child: SelectedFiltersView(
              controller: _selectedFiltersViewController,
              titles: widget.selectedItems,
              onItemPressed: (index) {
                print(widget.selectedItems);
                var selectedItem = widget.selectedItems[index];
                _deselectItem(selectedItem);
              },
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                widget.onRefresh();
                return _startRefresh();
              },
              child: ListView.builder(
                controller: _scrollController,
                itemCount: _getNumberOfItems(),
                itemBuilder: (context, index) {
                  return _getViewForIndex(index);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  //MARK: Functions to get list item count and view

  int _getNumberOfItems() {
    return widget.items.length + 1; //+1 for the loader and error view
  }

  Widget _getViewForIndex(int index) {
    if (index < widget.items.length) return _buildFilterListTileForIndex(index);

    if (widget.showMessage) {
      return _buildErrorView(widget.message);
    } else {
      if (_isRefreshing || widget.showLoaderAtEnd == false) {
        return Container(height: 200);
      } else {
        return LoaderListTile();
      }
    }
  }

  Widget _buildFilterListTileForIndex(int index) {
    return _MultiSelectFilterListTile(
      isSelected: _isItemAtIndexSelected(index),
      title: widget.items[index],
      onItemSelected: () => _selectItem(widget.items[index]),
      onItemDeselected: () => _deselectItem(widget.items[index]),
    );
  }

  bool _isItemAtIndexSelected(int index) {
    var item = widget.items[index];
    return widget.selectedItems.contains(item);
  }

  Widget _buildErrorView(String errorMessage) {
    return ErrorListTile(
      '$errorMessage Tap here to reload.',
      onTap: () => widget.onRetry(),
    );
  }

  //MARK: Util functions to select and deselect an item

  void _selectItem(String title) {
    if (widget.singleSelection) _selectedFiltersViewController.removeItemAtIndex(0);
    _selectedFiltersViewController.addItem(title);
    widget.onFilterSelected(title);
  }

  void _deselectItem(String title) {
    var indexOfItemToRemove = widget.selectedItems.indexOf(title);
    _selectedFiltersViewController.removeItemAtIndex(indexOfItemToRemove);
    widget.onFilterDeselected(title);
  }

  //MARK: Util functions to start and stop refresh

  Future<void> _startRefresh() {
    _isRefreshing = true;

    //this completer finishes when items are added, or a message is shown
    _refreshIndicatorCompleter = Completer();
    return _refreshIndicatorCompleter.future;
  }

  void _stopRefresh() {
    _isRefreshing = false;
    _refreshIndicatorCompleter.complete(null);
  }
}

class _MultiSelectFilterListTile extends StatelessWidget {
  final bool isSelected;
  final String title;
  final VoidCallback onItemSelected;
  final VoidCallback onItemDeselected;

  _MultiSelectFilterListTile({this.isSelected, this.title, this.onItemSelected, this.onItemDeselected});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FlatButton(
          height: 50,
          child: Container(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              title,
              style: TextStyles.titleTextStyle.copyWith(
                color: isSelected ? AppColors.defaultColor : Colors.black,
              ),
            ),
          ),
          onPressed: () => isSelected ? onItemDeselected() : onItemSelected(),
        ),
        Divider(height: 1),
      ],
    );
  }
}
