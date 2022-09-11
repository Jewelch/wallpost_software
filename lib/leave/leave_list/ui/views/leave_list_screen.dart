import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/filter_views/dropdown_filter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/leave/leave_list/entities/leave_list_item.dart';

import '../../../../_common_widgets/screen_presenter/screen_presenter.dart';
import '../../../leave_detail/ui/views/leave_detail_screen.dart';
import '../models/leave_list_item_view_type.dart';
import '../presenters/leave_list_presenter.dart';
import '../view_contracts/leave_list_view.dart';
import 'leave_list_item_card.dart';
import 'leave_list_loader.dart';

class LeaveListScreen extends StatefulWidget {
  const LeaveListScreen({Key? key}) : super(key: key);

  @override
  _LeaveListScreenState createState() => _LeaveListScreenState();
}

class _LeaveListScreenState extends State<LeaveListScreen> implements LeaveListView {
  late LeaveListPresenter _listPresenter;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier(defaultValue: 0);
  final _scrollController = ScrollController();
  final int viewTypeLoader = 1;
  final int viewTypeError = 2;
  final int viewTypeNoItems = 3;
  final int viewTypeList = 4;

  @override
  void initState() {
    _listPresenter = LeaveListPresenter(this);
    _listPresenter.getNext();
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void _setupScrollDownToLoadMoreItems() {
    _scrollController.addListener(() {
      if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
        _listPresenter.getNext();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: "Leave Requests",
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: ItemNotifiable(
          notifier: _viewTypeNotifier,
          builder: (context, viewType) {
            if (viewType == viewTypeLoader) {
              return _buildLoaderView();
            } else if (viewType == viewTypeError) {
              return _buildErrorView();
            } else if (viewType == viewTypeNoItems) {
              return _buildNoItemsView();
            } else {
              return _dataView();
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
    return Column(
      children: [
        Expanded(
          child: GestureDetector(
            onTap: () => _listPresenter.getNext(),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  _listPresenter.errorMessage,
                  textAlign: TextAlign.center,
                  style: TextStyles.titleTextStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNoItemsView() {
    return Column(
      children: [
        SizedBox(height: 20),
        _approvalStatusFilter(),
        Expanded(
          child: GestureDetector(
            onTap: () => _listPresenter.getNext(),
            child: Center(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  _listPresenter.noItemsMessage,
                  textAlign: TextAlign.center,
                  style: TextStyles.titleTextStyle,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dataView() {
    return Column(
      children: [
        SizedBox(height: 20),
        _approvalStatusFilter(),
        SizedBox(height: 8),
        Expanded(child: _listView()),
      ],
    );
  }

  Widget _approvalStatusFilter() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: DropdownFilter(
        items: _listPresenter.getStatusFilterList(),
        selectedValue: _listPresenter.getSelectedStatusFilter(),
        onDidSelectedItemAtIndex: (index) => _listPresenter.selectStatusFilterAtIndex(index),
      ),
    );
  }

  Widget _listView() {
    return RefreshIndicator(
      onRefresh: () => _listPresenter.refresh(),
      child: ListView.builder(
        controller: _scrollController,
        physics: AlwaysScrollableScrollPhysics(),
        itemCount: _listPresenter.getNumberOfListItems(),
        itemBuilder: (context, index) {
          switch (_listPresenter.getItemTypeAtIndex(index)) {
            case LeaveListItemViewType.ListItem:
              return _listItem(index);
            case LeaveListItemViewType.Loader:
              return _listLoader();
            case LeaveListItemViewType.ErrorMessage:
              return _errorListTile();
            case LeaveListItemViewType.EmptySpace:
              return Container(height: 150);
          }
        },
      ),
    );
  }

  Widget _listItem(index) {
    return LeaveListItemCard(
      presenter: _listPresenter,
      leaveListItem: _listPresenter.getItemAtIndex(index),
    );
  }

  Widget _listLoader() {
    return Container(
      height: 150,
      child: Center(
        child: SizedBox(width: 30, height: 30, child: CircularProgressIndicator(strokeWidth: 3)),
      ),
    );
  }

  Widget _errorListTile() {
    return GestureDetector(
      onTap: () => _listPresenter.getNext(),
      child: Container(
        height: 100,
        child: Text(_listPresenter.errorMessage),
      ),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(viewTypeLoader);
  }

  @override
  void showErrorMessage() {
    _viewTypeNotifier.notify(viewTypeError);
  }

  @override
  void showNoItemsMessage() {
    _viewTypeNotifier.notify(viewTypeNoItems);
  }

  @override
  void updateList() {
    _viewTypeNotifier.notify(viewTypeList);
  }

  @override
  void showLeaveDetail(LeaveListItem leaveListItem) {
    _goToLeaveDetailScreen(leaveListItem);
  }

  void _goToLeaveDetailScreen(LeaveListItem leaveListItem) async {
    var didPerformAction = await ScreenPresenter.present(
      LeaveDetailScreen(
        companyId: leaveListItem.companyId,
        leaveId: leaveListItem.leaveId,
      ),
      context,
    );
    if (didPerformAction == true) _listPresenter.refresh();
  }
}
