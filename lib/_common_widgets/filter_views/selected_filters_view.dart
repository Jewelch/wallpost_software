import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:wallpost/_common_widgets/filter_views/custom_filter_chip.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';

class SelectedFiltersViewController {
  _SelectedFiltersViewState _state;

  bool get _isAttached => _state != null;

  void dispose() => _state = null;

  void addState(_SelectedFiltersViewState state) {
    _state = state;
  }

  void addItem(String title) {
    assert(_isAttached, 'State not attached');
    _state._addItem(title);
  }

  void removeItemAtIndex(int index) {
    assert(_isAttached, 'State not attached');
    _state._removeItemAtIndex(index);
  }
}

class SelectedFiltersView extends StatefulWidget {
  final List<String> titles;
  final Function(int) onItemPressed;
  final SelectedFiltersViewController controller;

  SelectedFiltersView({List<String> titles, this.onItemPressed, this.controller})
      : this.titles = [...titles]; //creating a copy of the list;

  @override
  _SelectedFiltersViewState createState() => _SelectedFiltersViewState(titles, controller);
}

class _SelectedFiltersViewState extends State<SelectedFiltersView> {
  final GlobalKey<AnimatedListState> listKey = GlobalKey<AnimatedListState>();
  final _scrollController = ScrollController();
  List<String> _titles;
  SelectedFiltersViewController _controller;

  _SelectedFiltersViewState(this._titles, this._controller) {
    if (_controller != null) _controller.addState(this);
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
              initialItemCount: _titles.length,
              itemBuilder: (context, index, animation) {
                return _buildItem(context, _titles[index], animation, onPressed: () {
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
    listKey.currentState.insertItem(_titles.length, duration: const Duration(milliseconds: 200));
    _titles.add(title);
    Timer(Duration(milliseconds: 300), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeOut,
      );
    });
  }

  void _removeItemAtIndex(int index) {
    if (index >= _titles.length) return;

    var removedItem = _titles.removeAt(index);
    AnimatedListRemovedItemBuilder builder = (context, animation) {
      return _buildItem(context, removedItem, animation, onPressed: () {});
    };
    listKey.currentState.removeItem(index, builder);
  }
}
