import 'dart:async';

import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/_list_view/error_list_tile.dart';
import 'package:wallpost/_common_widgets/_list_view/loader_list_tile.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_back_button.dart';
import 'package:wallpost/_common_widgets/buttons/circular_check_mark_button.dart';
import 'package:wallpost/_common_widgets/filter_views/selected_filters_view.dart';
import 'package:wallpost/_common_widgets/search_bar/search_bar.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class MultiSelectFilterListController {
  _MultiSelectFilterListState _state;

  bool get _isAttached => _state != null;

  void addState(_MultiSelectFilterListState state) {
    _state = state;
  }

  void dispose() => _state = null;

  void addItems(List<String> items) {
    assert(_isAttached, 'State not attached');
    _state._addItems(items);
  }

  void showError(String errorMessage) {
    assert(_isAttached, 'State not attached');
    _state._showError(errorMessage);
  }

  String getSearchText() {
    if (_isAttached == false) return '';

    return _state._searchBarController.text;
  }

  void reachedListEnd() {
    assert(_isAttached, 'State not attached');
    _state._didReachListEnd = true;
  }

  List<int> getSelectedIndices() {
    assert(_isAttached, 'State not attached');
    return _state._getSelectedIndices();
  }
}

class MultiSelectFilterList extends StatefulWidget {
  final String screenTitle;
  final List<String> items;
  final List<String> selectedItems;
  final String searchBarHint;
  final String noItemsMessage;
  final MultiSelectFilterListController controller;
  final VoidCallback onRefresh;
  final VoidCallback onRetry;
  final VoidCallback didReachEndOfList;
  final Function(String) onSearchTextChanged;
  final VoidCallback onFiltersSelectionComplete;

  MultiSelectFilterList({
    this.screenTitle,
    this.items,
    this.selectedItems,
    this.searchBarHint,
    this.noItemsMessage,
    this.controller,
    this.onRefresh,
    this.onRetry,
    this.didReachEndOfList,
    this.onSearchTextChanged,
    this.onFiltersSelectionComplete,
  });

  @override
  _MultiSelectFilterListState createState() => _MultiSelectFilterListState(items, selectedItems, controller);
}

class _MultiSelectFilterListState extends State<MultiSelectFilterList> {
  var _scrollController = ScrollController();
  var _searchBarController = TextEditingController();
  var _selectedFiltersViewController = SelectedFiltersViewController();
  MultiSelectFilterListController _controller;
  List<String> _items = [];
  List<String> _selectedItems;
  Completer<void> _refreshIndicatorCompleter;
  bool _isRefreshing = false;
  bool _didReachListEnd = false;
  String _errorMessage;

  _MultiSelectFilterListState(this._items, List<String> selectedItems, this._controller) {
    _controller.addState(this);
    this._selectedItems = selectedItems ?? [];
  }

  @override
  void initState() {
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        if (_didReachListEnd == false) widget.didReachEndOfList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
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
            onPressed: () => widget.onFiltersSelectionComplete(),
          ),
        ],
      ),
      body: Column(
        children: [
          SizedBox(height: 8),
          SearchBar(
            hint: widget.searchBarHint,
            controller: _searchBarController,
            onSearchTextChanged: (searchText) {
              _clearAll();
              widget.onSearchTextChanged(searchText);
            },
          ),
          SizedBox(height: 8),
          SizedBox(
            height: _selectedItems.length > 0 ? 32 : 0,
            child: SelectedFiltersView(
              controller: _selectedFiltersViewController,
              titles: _selectedItems,
              onItemPressed: (index) {
                _selectedFiltersViewController.removeItemAtIndex(index);

                var itm = _selectedItems[index];
                setState(() {
                  _selectedItems.remove(itm);
                });
              },
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () {
                _clearAll();
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

  //MARK: Functions to get list items count and view

  int _getNumberOfItems() {
    return _items.length + 1; //+1 for the loader and error view
  }

  Widget _getViewForIndex(int index) {
    if (index < _items.length) return _buildFilterListTileForIndex(index);

    if (_errorMessage != null) {
      return _buildErrorView(_errorMessage);
    } else if (_items.length == 0 && _didReachListEnd) {
      return _buildErrorView(widget.noItemsMessage);
    } else {
      if (_didReachListEnd || _isRefreshing) {
        return Container(height: 200);
      } else {
        return LoaderListTile();
      }
    }
  }

  Widget _buildFilterListTileForIndex(int index) {
    return _MultiSelectFilterListTile(
      isSelected: _isItemAtIndexSelected(index),
      title: _items[index],
      onItemSelected: () {
        var selectedItem = _items[index];
        print(_selectedItems);
        _selectedFiltersViewController.addItem(selectedItem);
        print(_selectedItems);
        setState(() {
          print(_selectedItems);
          _selectedItems.add(selectedItem);
          print(_selectedItems);
        });
      },
      onItemDeselected: () {
        var itemToRemove = _items[index];
        var indexOfItemToRemove = _selectedItems.indexOf(itemToRemove);
        _selectedFiltersViewController.removeItemAtIndex(indexOfItemToRemove);
        setState(() => _selectedItems.remove(itemToRemove));
      },
    );
  }

  bool _isItemAtIndexSelected(int index) {
    var item = _items[index];
    return _selectedItems.contains(item);
  }

  Widget _buildErrorView(String errorMessage) {
    return ErrorListTile(
      '$errorMessage Tap here to reload.',
      onTap: () {
        setState(() {
          _didReachListEnd = false;
          _resetError();
        });
        widget.onRetry();
      },
    );
  }

  //MARK: Function to add items

  void _addItems(List<String> items) {
    setState(() {
      _resetError();
      if (_isRefreshing) _stopRefresh();
//      if (items.isEmpty) _didReachListEnd = true;

      _items.addAll(items);

      //manually invoking didReachEndOfList to get the next list of
      //items if there current items list has less than 15 items
      if (items.isNotEmpty && _items.length < 15) widget.didReachEndOfList();
    });
  }

  //MARK: Function to show  error

  void _showError(String errorMessage) {
    setState(() {
      if (_isRefreshing) _stopRefresh();
      _errorMessage = errorMessage;
    });
  }

  //MARK: Function to get the selected indices

  List<int> _getSelectedIndices() {
    List<int> indices = [];

    for (String t in _selectedItems) {
      indices.add(_items.indexOf(t));
    }
    return indices;
  }

  //MARK: Util functions to start and stop refresh

  Future<void> _startRefresh() {
    _isRefreshing = true;

    //this completer finishes when items are added, or an error is shown
    _refreshIndicatorCompleter = Completer();
    return _refreshIndicatorCompleter.future;
  }

  void _stopRefresh() {
    _isRefreshing = false;
    _refreshIndicatorCompleter.complete(null);
  }

  //MARK: Util functions to reset data

  void _clearAll() {
    setState(() {
      _didReachListEnd = false;
      _resetError();
      _items.clear();
    });
  }

  void _resetError() {
    _errorMessage = null;
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
