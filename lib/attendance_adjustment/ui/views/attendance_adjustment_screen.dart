import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/app_bar_divider.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_action_button.dart';
import 'package:wallpost/_common_widgets/buttons/rounded_back_button.dart';
import 'package:wallpost/_common_widgets/form_widgets/login_text_field.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_adjustment_presenter.dart';
import 'package:wallpost/attendance_adjustment/ui/view_contracts/attendance_adjustment_view.dart';
import 'package:wallpost/attendance_adjustment/ui/views/attendance_list_screen.dart';

class AttendanceAdjustmentScreen extends StatefulWidget {
  final AttendanceListItem attendanceListItem;

  const AttendanceAdjustmentScreen({Key? key, required this.attendanceListItem}) : super(key: key);

  @override
  _AttendanceAdjustmentScreenState createState() => _AttendanceAdjustmentScreenState();
}

class _AttendanceAdjustmentScreenState extends State<AttendanceAdjustmentScreen> implements AttendanceAdjustmentView {
  var _reasonErrorNotifier = ItemNotifier<String?>(defaultValue: null);
  var _reasonTextController = TextEditingController();
  var _showLoaderNotifier = ItemNotifier<bool>(defaultValue: false);
  late AttendanceAdjustmentPresenter presenter;
  late Loader loader;

  final Color greyColor = Colors.grey;

  @override
  void initState() {
    loader = Loader(context);
    presenter = AttendanceAdjustmentPresenter(this, widget.attendanceListItem);
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
      body: SafeArea(
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBarDivider(),
              _attendanceInfo(),
              AppBarDivider(),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(16,),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _adjustPunchTime(),
                          _reasonForAdjustment(),
                        ],
                      ),
                      _saveButton(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _attendanceInfo() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.attendanceListItem.getReadableDate(), style: TextStyles.subTitleTextStyleBold),
              Text(presenter.status, style: TextStyles.subTitleTextStyleBold.copyWith(color: presenter.statusColor),),
            ],
          ),
          SizedBox(height: 8,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Punched In', style: TextStyles.subTitleTextStyle.copyWith(color: greyColor),),
              Text('Punched Out', style: TextStyles.subTitleTextStyle.copyWith(color: greyColor),),
            ],
          ),
          SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.attendanceListItem.originalPunchInTime,
                style: TextStyles.subTitleTextStyle.copyWith(color: greyColor),),
              Text(
                widget.attendanceListItem.originalPunchOutTime,
                style: TextStyles.subTitleTextStyle.copyWith(color: greyColor),),
            ],
          )
        ],
      ),
    );
  }

  Widget _adjustPunchTime() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text('Adjust Punch In', style: TextStyles.subTitleTextStyleBold,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: AppColors.textFieldBackgroundColor, elevation: 2),
              onPressed: _pickPunchInTime,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text( "${presenter.getPunchInTime().format(context)}",
                      style: TextStyles.subTitleTextStyle.copyWith(color: greyColor),),
                    Icon(Icons.access_time, color: greyColor,),
                  ],
                ),
              ),
            ),
          ]),
        ),
        SizedBox(width: 20,),
        Expanded(
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
            Text('Adjust Punch Out', style: TextStyles.subTitleTextStyleBold,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                  primary: AppColors.textFieldBackgroundColor, elevation: 2),
              onPressed: _pickPunchOutTime,
              child: Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("${presenter.getPunchOutTime().format(context)}",
                      style: TextStyles.subTitleTextStyle.copyWith(color: greyColor),),
                    Icon(Icons.access_time, color: greyColor,),
                  ],
                ),
              ),
            ),
          ]),
        ),
      ],
    );
  }

  Widget _reasonForAdjustment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(top: 20,bottom: 8),
            child: Text('Reason of adjustment', style: TextStyles.subTitleTextStyleBold,)),
        ItemNotifiable<String?>(
          notifier: _reasonErrorNotifier,
          builder: (context, value) => LoginTextField(
            hint: 'Write your reason here',
            controller: _reasonTextController,
            errorText: value,
            minLines: 3,
            maxLines: 8,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
          ),
         ),
      ],
    );
  }

  Widget _saveButton() {
    return ItemNotifiable<bool>(
      notifier: _showLoaderNotifier,
      builder: (context, showLoader) => RoundedRectangleActionButton(
        title: 'Save',
        backgroundColor: AppColors.successColor,
        onPressed: () => _submitAdjustment(),
        showLoader: showLoader,
      ),
    );
  }

  void _pickPunchInTime() async {
    TimeOfDay? adjustedTime = await showTimePicker(context: context, initialTime: presenter.getPunchInTime());
    if (adjustedTime != null) {
      presenter.adjustPunchInTime(adjustedTime);
    }
  }

  void _pickPunchOutTime() async {
    TimeOfDay? adjustedTime = await showTimePicker(context: context, initialTime: presenter.getPunchOutTime());
    if (adjustedTime != null) {
      presenter.adjustPunchOutTime(adjustedTime);
    }
  }

  void _submitAdjustment() {
    presenter.submitAdjustment(_reasonTextController.text);
  }

  @override
  void showLoader() {
    _showLoaderNotifier.notify(true);
  }

  @override
  void hideLoader() {
    _showLoaderNotifier.notify(false);
  }

  @override
  void clearError() {
    _reasonErrorNotifier.notify("");
  }

  @override
  void notifyInvalidReason(String message) {
    _reasonErrorNotifier.notify(message);
  }

  @override
  void notifyInvalidAdjustedStatus(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void onGetAdjustedStatusFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void onAdjustAttendanceSuccess(String title, String message) {
    Alert.showSimpleAlert(
        context: context, title: title, message: message, onPressed: () => ScreenPresenter.present(AttendanceListScreen(), context));
  }

  @override
  void onAdjustAttendanceFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void onDidLoadAdjustedStatus() {
    setState(() {});
  }
}
