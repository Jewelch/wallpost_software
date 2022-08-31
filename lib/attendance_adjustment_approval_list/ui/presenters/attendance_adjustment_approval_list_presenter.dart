import 'dart:ui';

import 'package:intl/intl.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance__core/utils/attendance_status_color.dart';
import 'package:wallpost/attendance_adjustment_approval_list/entities/attendance_adjustment_approval_list_item.dart';

import '../../services/attendance_adjustment_approval_list_provider.dart';
import '../models/attendance_adjustment_approval_list_item_view_type.dart';
import '../view_contracts/attendance_adjustment_approval_list_view.dart';

class AttendanceAdjustmentApprovalListPresenter {
  final AttendanceAdjustmentApprovalListView _view;
  final AttendanceAdjustmentApprovalListProvider _approvalListProvider;
  final List<AttendanceAdjustmentApprovalListItem> _approvalItems = [];
  String _errorMessage = "";
  final String _noItemsMessage = "There are no approvals to show.\n\nTap here to reload.";

  AttendanceAdjustmentApprovalListPresenter(String companyId, this._view)
      : _approvalListProvider = AttendanceAdjustmentApprovalListProvider(companyId);

  AttendanceAdjustmentApprovalListPresenter.initWith(this._view, this._approvalListProvider);

  //MARK: Functions to load data

  Future<void> getNext() async {
    if (_approvalListProvider.isLoading) return;
    _isFirstLoad() ? _view.showLoader() : _view.updateList();
    _resetErrors();

    try {
      var newListItems = await _approvalListProvider.getNext();
      _handleResponse(newListItems);
    } on WPException catch (e) {
      _errorMessage = '${e.userReadableMessage}\n\nTap here to reload.';
      _isFirstLoad() ? _view.showErrorMessage() : _view.updateList();
    }
  }

  void _handleResponse(List<AttendanceAdjustmentApprovalListItem> newListItems) {
    _approvalItems.addAll(newListItems);
    _updateList();
  }

  void _updateList() {
    if (_isFirstLoad()) {
      _view.showNoItemsMessage();
    } else {
      _view.updateList();
    }
  }

  void _resetErrors() {
    _errorMessage = "";
  }

  //MARK: Function to refresh the list

  Future<void> refresh() async {
    _approvalItems.clear();
    _approvalListProvider.reset();
    getNext();
  }

  //MARK: Function to check isFirstLoad

  bool _isFirstLoad() {
    return _approvalItems.isEmpty;
  }

  //MARK: Functions to get the list details

  int getNumberOfListItems() {
    if (_approvalItems.isEmpty) return 0;
    return _approvalItems.length + 1;
  }

  AttendanceAdjustmentApprovalListItemViewType getItemTypeAtIndex(int index) {
    if (index < _approvalItems.length) return AttendanceAdjustmentApprovalListItemViewType.ListItem;

    if (_errorMessage.isNotEmpty) return AttendanceAdjustmentApprovalListItemViewType.ErrorMessage;

    if (_approvalListProvider.isLoading || _approvalListProvider.didReachListEnd == false)
      return AttendanceAdjustmentApprovalListItemViewType.Loader;

    return AttendanceAdjustmentApprovalListItemViewType.EmptySpace;
  }

  AttendanceAdjustmentApprovalListItem getItemAtIndex(int index) {
    return _approvalItems[index];
  }

  //MARK: Functions for successful processing of approval or rejection

  Future<void> onDidProcessApprovalOrRejection(dynamic didProcess, String expenseId) async {
    if (didProcess == true) {
      _approvalItems.removeWhere((approval) => approval.id == expenseId);
      _approvalItems.isEmpty ? await refresh() : _updateList();
    }
  }

  //MARK: Getters

  String getEmployeeName(AttendanceAdjustmentApprovalListItem approval) {
    return approval.employeeName;
  }

  String getDate(AttendanceAdjustmentApprovalListItem approval) {
    return DateFormat("dd-MMM-yyyy").format(approval.attendanceDate);
  }

  String getOriginalStatus(AttendanceAdjustmentApprovalListItem approval) {
    if (approval.originalStatus == null) return "";

    return approval.originalStatus!.toReadableString();
  }

  Color? getOriginalStatusColor(AttendanceAdjustmentApprovalListItem approval) {
    if (approval.originalStatus == null) return null;

    return AttendanceStatusColor.getStatusColor(approval.originalStatus!);
  }

  String getAdjustedStatus(AttendanceAdjustmentApprovalListItem approval) {
    if (approval.adjustedStatus == null) return "";

    return approval.adjustedStatus!.toReadableString();
  }

  Color? getAdjustedStatusColor(AttendanceAdjustmentApprovalListItem approval) {
    if (approval.adjustedStatus == null) return null;

    return AttendanceStatusColor.getStatusColor(approval.adjustedStatus!);
  }

  String getOriginalPunchInTime(AttendanceAdjustmentApprovalListItem approval) {
    if (approval.originalPunchInTime == null) return "";

    return DateFormat("hh:mm a").format(approval.originalPunchInTime!);
  }

  String getOriginalPunchOutTime(AttendanceAdjustmentApprovalListItem approval) {
    if (approval.originalPunchOutTime == null) return "";

    return DateFormat("hh:mm a").format(approval.originalPunchOutTime!);
  }

  String getAdjustedPunchInTime(AttendanceAdjustmentApprovalListItem approval) {
    return DateFormat("hh:mm a").format(approval.adjustedPunchInTime);
  }

  String getAdjustedPunchOutTime(AttendanceAdjustmentApprovalListItem approval) {
    return DateFormat("hh:mm a").format(approval.adjustedPunchOutTime);
  }

  String getAdjustmentReason(AttendanceAdjustmentApprovalListItem approval) {
    return approval.adjustmentReason;
  }

  String get errorMessage => _errorMessage;

  String get noItemsMessage => _noItemsMessage;
}
