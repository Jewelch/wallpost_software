import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval/ui/views/attendance_adjustment_rejection_all_alert.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/ui/presenters/attendance_adjustment_approval_list_presenter.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/ui/view_contracts/attendance_adjustment_approval_list_view.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/ui/views/attendance_adjustment_approval_list_app_bar.dart';
import 'package:wallpost/attendance/attendance_adjustment_approval_list/ui/views/attendance_adjustment_approval_list_item_card.dart';

import '../../../../_common_widgets/buttons/rounded_action_button.dart';
import '../../../attendance_adjustment_approval/ui/views/attendance_adjustment_approval_all_alert.dart';
import '../models/attendance_adjustment_approval_list_item_view_type.dart';
import 'attendance_adjustment_approval_list_loader.dart';

class AttendanceAdjustmentApprovalListScreen extends StatefulWidget {
  final String companyId;

  AttendanceAdjustmentApprovalListScreen({required this.companyId});

  @override
  State<AttendanceAdjustmentApprovalListScreen> createState() => _AttendanceAdjustmentApprovalListScreenState();
}

class _AttendanceAdjustmentApprovalListScreenState extends State<AttendanceAdjustmentApprovalListScreen>
    implements AttendanceAdjustmentApprovalListView {
  late AttendanceAdjustmentApprovalListPresenter _listPresenter;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier(defaultValue: 0);
  final _scrollController = ScrollController();
  final int viewTypeLoader = 1;
  final int viewTypeError = 2;
  final int viewTypeNoItems = 3;
  final int viewTypeList = 4;

  @override
  void initState() {
    _listPresenter = AttendanceAdjustmentApprovalListPresenter(widget.companyId, this);
    _loadData();
    _setupScrollDownToLoadMoreItems();
    super.initState();
  }

  void _loadData() async {
    await _listPresenter.getNext();
    _listPresenter.initiateMultipleSelection();
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
    return WillPopScope(
      onWillPop: () {
        _dismiss();
        return Future.value(false);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
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
      ),
    );
  }

  Widget _buildLoaderView() {
    return AttendanceAdjustmentApprovalListLoader();
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
    return Container(
      color: AppColors.screenBackgroundColor2,
      child: Column(
        children: [
          AttendanceAdjustmentApprovalListAppBar(
            noOfSelectedItems: _listPresenter.getCountOfSelectedItems(),
            isAllItemAreSelected: _listPresenter.areAllItemsSelected(),
            isMultipleSelectionInProgress: _listPresenter.isSelectionInProgress,
            onInitiateMultipleSelectionButtonPressed: () => _listPresenter.initiateMultipleSelection(),
            onEndMultipleSelectionButtonPressed: () => _listPresenter.endMultipleSelection(),
            onSelectAllButtonPress: () => _listPresenter.selectAll(),
            onUnselectAllButtonPress: () => _listPresenter.unselectAll(),
            onBackButtonPress: () => _dismiss(),
          ),
          SizedBox(height: 20),
          Expanded(child: _listView()),
          _listPresenter.isSelectionInProgress ? _approveAndRejectActionButton() : _approveAllAndRejectAllActionButton()
        ],
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
            case AttendanceAdjustmentApprovalListItemViewType.ListItem:
              return _listItem(index);
            case AttendanceAdjustmentApprovalListItemViewType.Loader:
              return _listLoader();
            case AttendanceAdjustmentApprovalListItemViewType.ErrorMessage:
              return _errorListTile();
            case AttendanceAdjustmentApprovalListItemViewType.EmptySpace:
              return Container(height: 150);
          }
        },
      ),
    );
  }

  Widget _listItem(index) {
    return AttendanceAdjustmentApprovalListCard(
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

  Widget _approveAndRejectActionButton() {
    if (_listPresenter.getCountOfSelectedItems() > 0)
      return Container(
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Expanded(
              child: RoundedRectangleActionButton(
                title: "Approve",
                icon: Icon(Icons.check, size: 18, color: Colors.white),
                backgroundColor: AppColors.green,
                isIconLeftAligned: false,
                height: 44,
                borderRadiusCircular: 16,
                onPressed: () => _approveSelectedItems(),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: RoundedRectangleActionButton(
                title: "Reject",
                icon: Icon(Icons.close, size: 18, color: Colors.white),
                backgroundColor: AppColors.red,
                isIconLeftAligned: false,
                height: 44,
                borderRadiusCircular: 16,
                onPressed: () => _rejectSelectedItems(),
              ),
            ),
          ],
        ),
      );
    return Container();
  }

  Widget _approveAllAndRejectAllActionButton() {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: RoundedRectangleActionButton(
              title: "Approve All",
              icon: Icon(Icons.check, size: 18, color: Colors.white),
              backgroundColor: AppColors.green,
              isIconLeftAligned: false,
              height: 44,
              borderRadiusCircular: 16,
              onPressed: () => _approveAll(),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: RoundedRectangleActionButton(
              title: "Reject All",
              icon: Icon(Icons.close, size: 18, color: Colors.white),
              backgroundColor: AppColors.red,
              isIconLeftAligned: false,
              height: 44,
              borderRadiusCircular: 16,
              onPressed: () => _rejectAll(),
            ),
          ),
        ],
      ),
    );
  }

  //MARK: mass approve function

  void _approveAll() async {
    var didApprove = await showDialog(
      context: context,
      builder: (_) => AttendanceAdjustmentApprovalAllAlert(
        noOfSelectedItems: _listPresenter.getCountOfAllItems(),
        attendanceAdjustmentIds: _listPresenter.getAllIds(),
        companyId: _listPresenter.getItemAtIndex(0).companyId,
      ),
    );
    if (didApprove) _listPresenter.onDidProcessApprovalOrRejection(didApprove, _listPresenter.getAllIds());
  }

  //MARK: mass reject function

  void _rejectAll() async {
    var didRejected = await showDialog(
      context: context,
      builder: (_) => AttendanceAdjustmentRejectionAllAlert(
        noOfSelectedItems: _listPresenter.getCountOfAllItems(),
        attendanceAdjustmentIds: _listPresenter.getAllIds(),
        companyId: _listPresenter.getItemAtIndex(0).companyId,
      ),
    );
    if (didRejected) _listPresenter.onDidProcessApprovalOrRejection(didRejected, _listPresenter.getAllIds());
  }

  //MARK: approve selected items function

  void _approveSelectedItems() async {
    var didApprove = await showDialog(
      context: context,
      builder: (_) => AttendanceAdjustmentApprovalAllAlert(
        noOfSelectedItems: _listPresenter.getCountOfSelectedItems(),
        attendanceAdjustmentIds: _listPresenter.getSelectedItemIds(),
        companyId: _listPresenter.getItemAtIndex(0).companyId,
      ),
    );

    if (didApprove) _listPresenter.onDidProcessApprovalOrRejection(didApprove, _listPresenter.getSelectedItemIds());
  }

  //MARK:  reject selected  function

  void _rejectSelectedItems() async {
    var didReject = await showDialog(
      context: context,
      builder: (_) => AttendanceAdjustmentRejectionAllAlert(
        noOfSelectedItems: _listPresenter.getCountOfSelectedItems(),
        attendanceAdjustmentIds: _listPresenter.getSelectedItemIds(),
        companyId: _listPresenter.getItemAtIndex(0).companyId,
      ),
    );
    if (didReject) _listPresenter.onDidProcessApprovalOrRejection(didReject, _listPresenter.getSelectedItemIds());
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
  void onDidProcessAllApprovals() {
    _dismiss();
  }

  //MARK: Function to dismiss the screen

  void _dismiss() {
    Navigator.pop(context, _listPresenter.numberOfApprovalsProcessed);
  }

  @override
  void onDidEndMultipleSelection() {
    _viewTypeNotifier.notify(viewTypeList);
  }

  @override
  void onDidInitiateMultipleSelection() {
    _viewTypeNotifier.notify(viewTypeList);
  }
}
