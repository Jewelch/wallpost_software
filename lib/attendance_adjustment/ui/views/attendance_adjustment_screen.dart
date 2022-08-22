import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/app_bars/app_bar_divider.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/form_text_field.dart';
import 'package:wallpost/_common_widgets/keyboard_dismisser/on_tap_keyboard_dismisser.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_adjustment_presenter.dart';
import 'package:wallpost/attendance_adjustment/ui/view_contracts/attendance_adjustment_view.dart';

import '../../../_common_widgets/alert/alert.dart';

class AttendanceAdjustmentScreen extends StatefulWidget {
  final AttendanceListItem attendanceListItem;

  const AttendanceAdjustmentScreen({Key? key, required this.attendanceListItem}) : super(key: key);

  @override
  _AttendanceAdjustmentScreenState createState() => _AttendanceAdjustmentScreenState();
}

class _AttendanceAdjustmentScreenState extends State<AttendanceAdjustmentScreen> implements AttendanceAdjustmentView {
  late AttendanceAdjustmentPresenter _presenter;
  late TextEditingController _reasonTextController;

  @override
  void initState() {
    _presenter = AttendanceAdjustmentPresenter(this, widget.attendanceListItem);
    _reasonTextController = TextEditingController(text: _presenter.getReason());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      appBar: SimpleAppBar(
        title: 'Adjust Attendance',
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: OnTapKeyboardDismisser(
        child: SafeArea(
          child: AbsorbPointer(
            absorbing: _presenter.shouldDisableFormEntry(),
            child: _form(),
          ),
        ),
      ),
    );
  }

  Widget _form() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppBarDivider(),
        SizedBox(height: 20),
        _attendanceInfo(),
        SizedBox(height: 20),
        AppBarDivider(),
        SizedBox(height: 30),
        _adjustedTimeFields(),
        SizedBox(height: 30),
        _reasonForAdjustment(),
        Expanded(child: Container()),
        _saveButton(),
        SizedBox(height: 20),
      ],
    );
  }

  Widget _attendanceInfo() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_presenter.getAttendanceDate(), style: TextStyles.titleTextStyleBold),
              if (_presenter.isLoadingAdjustedStatus())
                SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    backgroundColor: AppColors.green,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
                  ),
                ),
              if (!_presenter.isLoadingAdjustedStatus())
                Text(
                  _presenter.getAdjustedStatus(),
                  style: TextStyles.titleTextStyleBold.copyWith(
                    color: _presenter.getAdjustedStatusColor(),
                  ),
                )
            ],
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Punch In Time', style: TextStyles.subTitleTextStyle),
              Text('Punch Out Time', style: TextStyles.subTitleTextStyle),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_presenter.getPunchInTimeString(), style: TextStyles.titleTextStyle),
              Text(_presenter.getPunchOutTimeString(), style: TextStyles.titleTextStyle),
            ],
          ),
          if (_presenter.getApprovalInfo().isNotEmpty) SizedBox(height: 20),
          if (_presenter.getApprovalInfo().isNotEmpty)
            Text(
              _presenter.getApprovalInfo(),
              style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.red),
            ),
        ],
      ),
    );
  }

  Widget _adjustedTimeFields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            SizedBox(width: 12),
            _buildAdjustedTimeField(
              title: 'Adjust Punch In',
              time: _presenter.getAdjustedPunchInTimeString(),
              onTap: _pickPunchInTime,
            ),
            SizedBox(width: 20),
            _buildAdjustedTimeField(
              title: 'Adjust Punch Out',
              time: _presenter.getAdjustedPunchOutTimeString(),
              onTap: _pickPunchOutTime,
            ),
            SizedBox(width: 12),
          ],
        ),
        SizedBox(height: 6),
        if (_presenter.getAdjustedTimeError() != null)
          Text(
            "      ${_presenter.getAdjustedTimeError()}",
            style: TextStyles.subTitleTextStyle.copyWith(color: AppColors.red),
          ),
      ],
    );
  }

  Widget _buildAdjustedTimeField({
    required String title,
    required String time,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: TextStyles.titleTextStyleBold),
        SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.textFieldBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            padding: EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(time, style: TextStyles.titleTextStyle.copyWith()),
                Icon(Icons.access_time, size: 22),
              ],
            ),
          ),
        ),
      ]),
    );
  }

  void _pickPunchInTime() async {
    TimeOfDay? adjustedTime = await showTimePicker(
      context: context,
      initialTime: _presenter.adjustedPunchInTime,
    );

    if (adjustedTime != null) _presenter.loadAdjustedStatus(adjustedPunchInTime: adjustedTime);
  }

  void _pickPunchOutTime() async {
    TimeOfDay? adjustedTime = await showTimePicker(
      context: context,
      initialTime: _presenter.adjustedPunchOutTime,
    );

    if (adjustedTime != null) _presenter.loadAdjustedStatus(adjustedPunchOutTime: adjustedTime);
  }

  Widget _reasonForAdjustment() {
    return Padding(
      padding: const EdgeInsets.only(left: 12, right: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Reason of adjustment', style: TextStyles.titleTextStyleBold),
          SizedBox(height: 8),
          FormTextField(
            hint: 'Write your reason here',
            controller: _reasonTextController,
            errorText: _presenter.getReasonError(),
            minLines: 3,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
          )
        ],
      ),
    );
  }

  Widget _saveButton() {
    return Container(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: RoundedRectangleActionButton(
        title: 'Save',
        disabled: _presenter.shouldDisableFormEntry(),
        backgroundColor: AppColors.green,
        onPressed: () => _presenter.submitAdjustment(_reasonTextController.text),
        showLoader: _presenter.isSubmittingAdjustment(),
      ),
    );
  }

  //MARK: View functions

  @override
  void showAdjustedStatusLoader() {
    setState(() {});
  }

  @override
  void updateAdjustedPunchInAndOutTime() {
    setState(() {});
  }

  @override
  void onDidFailToLoadAdjustedStatus(String title, String message) {
    setState(() {});
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void onDidLoadAdjustedStatus() {
    setState(() {});
  }

  @override
  void notifyNoAdjustmentMade() {
    setState(() {});
  }

  @override
  void notifyInvalidReason() {
    setState(() {});
  }

  @override
  void clearAdjustedTimeInputError() {
    setState(() {});
  }

  @override
  void clearReasonInputError() {
    setState(() {});
  }

  @override
  void showFormSubmissionLoader() {
    setState(() {});
  }

  @override
  void onDidFailToAdjustAttendance(String title, String message) {
    setState(() {});
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void onDidAdjustAttendanceSuccessfully(String title, String message) {
    setState(() {});
    Alert.showSimpleAlert(
      context: context,
      title: title,
      message: message,
      onPressed: () => Navigator.pop(context, true),
    );
  }
}
