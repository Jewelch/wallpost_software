import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';

import '../../../../_common_widgets/app_bars/simple_app_bar.dart';
import '../../../../_common_widgets/buttons/rounded_back_button.dart';
import '../../../leave_detail/ui/views/leave_detail_screen.dart';
import '../../entities/leave_approval_list_item.dart';
import '../models/leave_approval_list_item_view_type.dart';
import '../presenters/leave_approval_list_presenter.dart';
import '../view_contracts/leave_approval_list_view.dart';
import 'leave_approval_list_item_card.dart';
import 'leave_approval_list_loader.dart';

class LeaveApprovalListScreen extends StatefulWidget {
  final String companyId;

  LeaveApprovalListScreen({required this.companyId});

  @override
  State<LeaveApprovalListScreen> createState() => _LeaveApprovalListScreenState();
}

class _LeaveApprovalListScreenState extends State<LeaveApprovalListScreen> implements LeaveApprovalListView {
  late LeaveApprovalListPresenter _listPresenter;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier(defaultValue: 0);
  final _scrollController = ScrollController();
  final int viewTypeLoader = 1;
  final int viewTypeError = 2;
  final int viewTypeNoItems = 3;
  final int viewTypeList = 4;

  @override
  void initState() {
    _listPresenter = LeaveApprovalListPresenter(widget.companyId, this);
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
        title: "Leave Approvals",
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
    return LeaveApprovalListLoader();
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
        Expanded(child: _listView()),
      ],
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
            case LeaveApprovalListItemViewType.ListItem:
              return _listItem(index);
            case LeaveApprovalListItemViewType.Loader:
              return _listLoader();
            case LeaveApprovalListItemViewType.ErrorMessage:
              return _errorListTile();
            case LeaveApprovalListItemViewType.EmptySpace:
              return Container(height: 150);
          }
        },
      ),
    );
  }

  Widget _listItem(index) {
    return LeaveApprovalListItemCard(
      listPresenter: _listPresenter,
      approval: _listPresenter.getItemAtIndex(index),
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

  //MARK: Approval list view functions

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
  void showLeaveDetail(LeaveApprovalListItem approval) {
    _goToLeaveDetailScreen(approval);
  }

  void _goToLeaveDetailScreen(LeaveApprovalListItem approval) async {
    var didPerformAction = await ScreenPresenter.present(
      LeaveDetailScreen(
        companyId: approval.companyId,
        leaveId: approval.id,
        isLaunchingDetailScreenForApproval: true,
      ),
      context,
    );
    _listPresenter.onDidProcessApprovalOrRejection(didPerformAction, approval.id);
  }
}
