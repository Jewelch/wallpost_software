import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/leave/ui/models/leave_list_item_type.dart';
import 'package:wallpost/leave/ui/view_contracts/leave_list_view.dart';
import 'package:wallpost/leave/ui/views/leave_list_item_tile.dart';

import '../presenters/leave_list_presenter.dart';
import 'leave_list_loader.dart';

class LeaveListScreen extends StatefulWidget {
  @override
  State<LeaveListScreen> createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> implements LeaveListView {
  late LeaveListPresenter _presenter;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier();
  final _scrollController = ScrollController();
  final int viewTypeLoader = 1;
  final int viewTypeError = 2;
  final int viewTypeLeaveList = 3;

  @override
  void initState() {
    _setupScrollDownToLoadMoreItems();
    _presenter = LeaveListPresenter(this);
    _presenter.getNext();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _presenter.getNext();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ItemNotifiable(
          notifier: _viewTypeNotifier,
          builder: (context, viewType) {
            if (viewType == viewTypeLoader) {
              return _buildLoaderView();
            } else if (viewType == viewTypeError) {
              return _buildErrorView();
            } else {
              return _buildListView();
            }
          },
        ),
      ),
    );
  }

  Widget _buildLoaderView() {
    return LeaveListLoader();
  }

  Widget _buildErrorView() {
    return GestureDetector(
      onTap: () => _presenter.getNext(),
      child: Container(
        height: 100,
        child: Text(_presenter.errorMessage),
      ),
    );
  }

  Widget _buildListView() {
    return Container(
      child: ListView.builder(
        controller: _scrollController,
        physics: BouncingScrollPhysics(),
        itemCount: _presenter.getNumberOfListItems(),
        itemBuilder: (context, index) {
          switch (_presenter.getItemTypeAtIndex(index)) {
            case LeaveListItemType.LeaveListItem:
              return LeaveListItemTile(_presenter.getLeaveListItemAtIndex(index));
            case LeaveListItemType.Loader:
              return Container(
                child: CircularProgressIndicator(),
              );
            case LeaveListItemType.ErrorMessage:
              return GestureDetector(
                onTap: () => _presenter.getNext(),
                child: Container(
                  height: 100,
                  child: Text(_presenter.errorMessage),
                ),
              );
            case LeaveListItemType.EmptySpace:
              return Container();
          }
        },
      ),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(viewTypeLoader);
  }

  @override
  void showErrorMessage(String message) {
    _viewTypeNotifier.notify(viewTypeError);
  }

  @override
  void updateLeaveList() {
    _viewTypeNotifier.notify(viewTypeLeaveList);
  }
}
