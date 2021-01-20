import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/filter_views/custom_filter_chip.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

/*

  make this like the text editing controller -
  the intial titles will be provided in the controller constructor
  rather than pass it in the

  als0 - remoevAllitems fnction - do setstate and see if it works or not
 */
class SelectedFiltersViewController {
  List<String> _titles = [];
  _SelectedFiltersViewState _state;

  bool get _isAttached => _state != null;

  SelectedFiltersViewController({List<String> titles = const []}) {
    this._titles.addAll(titles);
  }

  void dispose() => _state = null;

  void addState(_SelectedFiltersViewState state) {
    _state = state;
  }

  void addItem(String title) {
    assert(_isAttached, 'State not attached');
    _state._addItem(title);
    _titles.add(title);
  }

  void removeItemAtIndex(int index) {
    assert(_isAttached, 'State not attached');
    if (index >= _titles.length) return;

    var itemToRemove = _titles[index];
    _state._removeItemAtIndex(index, itemToRemove);
    _titles.removeAt(index);
  }

  void replaceAllItems(List<String> titles) {
    if (_isAttached) _state._removeAllItems();
    this._titles.clear();
    this._titles.addAll(titles);
    if (_isAttached) _state._addAllItems();
  }
}

class SelectedFiltersView extends StatefulWidget {
  final Function(int) onItemPressed;
  final SelectedFiltersViewController controller;

  SelectedFiltersView({this.onItemPressed, this.controller});

  @override
  _SelectedFiltersViewState createState() => _SelectedFiltersViewState(controller);
}

class _SelectedFiltersViewState extends State<SelectedFiltersView> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final _scrollController = ScrollController();
  SelectedFiltersViewController _controller;

  _SelectedFiltersViewState(this._controller) {
    assert(_controller != null, 'please add a controller');
    _controller.addState(this);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Expanded(
          child: Container(
            height: 40,
            child: AnimatedList(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              key: listKey,
              initialItemCount: _controller._titles.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(context, _controller._titles[index], animation, onPressed: () {
                  widget.onItemPressed(index);
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildItem(BuildContext context, String title, animation, {VoidCallback onPressed}) {
    return ScaleTransition(
      scale: animation,
      child: Padding(
        padding: EdgeInsets.only(left: 12),
        child: CustomFilterChip(
          title: Text(title),
          backgroundColor: AppColors.primaryContrastColor,
          shape: CustomFilterChipShape.capsule,
          icon: SvgPicture.asset(
            'assets/icons/close_icon.svg',
            width: 12,
            height: 12,
            color: Colors.black,
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }

  //MARK: Functions to  add and remove an item

  void _addItem(String title) {
    listKey.currentState.insertItem(_controller._titles.length, duration: const Duration(milliseconds: 200));
    Timer(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _removeItemAtIndex(int index, String removedItemTitle) {
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(context, removedItemTitle, animation, onPressed: () {});
    };
    listKey.currentState.removeItem(index, builder);
  }

  void _removeAllItems() {
    for (int i = 0; i < _controller._titles.length; i++) {
      AnimatedListRemovedItemBuilder builder = (context, animation) {
        return Container();
      };
      listKey.currentState.removeItem(0, builder);
    }
  }

  void _addAllItems() {
    for (int i = 0; i < _controller._titles.length; i++) {
      listKey.currentState.insertItem(i);
    }
  }
}
