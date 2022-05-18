
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
  var _statusLoaderNotifier = ItemNotifier<bool>(defaultValue: false);
  late AttendanceAdjustmentPresenter presenter;
  late Loader loader;

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
                child: ItemNotifiable<bool>(
                  notifier: _statusLoaderNotifier,
                  builder: (context, value) =>IgnorePointer(
                    ignoring: value ?  true: false,
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
      padding: EdgeInsets.symmetric(horizontal: 16,vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.attendanceListItem.getReadableDate(), style: TextStyles.titleTextStyleBold),
              ItemNotifiable<bool>(
                        notifier: _statusLoaderNotifier,
                        builder: (context, value) =>
                            value ? SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                backgroundColor: AppColors.greenButtonColor,
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
                              ),
                            )
                                :Text(presenter.status, style: TextStyles.titleTextStyleBold.copyWith(color: presenter.statusColor),),
                       ),
            ],
          ),
          SizedBox(height: 12,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Punched In', style: TextStyles.titleTextStyle.copyWith(color: AppColors.textGrey),),
              Text('Punched Out', style: TextStyles.titleTextStyle.copyWith(color: AppColors.textGrey),),
            ],
          ),
          SizedBox(height: 4,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(widget.attendanceListItem.originalPunchInTime,
                style: TextStyles.titleTextStyle.copyWith(color: AppColors.textGrey),),
              Text(
                widget.attendanceListItem.originalPunchOutTime,
                style: TextStyles.titleTextStyle.copyWith(color: AppColors.textGrey),),
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
        _buildPickAttendanceTime(
          title: 'Adjust Punch In',
          time: "${presenter.getPunchInTime().format(context)}",
          onTap: _pickPunchInTime,
        ),
        SizedBox(width: 20,),
        _buildPickAttendanceTime(
            title:'Adjust Punch Out',
            time: "${presenter.getPunchOutTime().format(context)}",
            onTap: _pickPunchOutTime
        ),
      ],
    );
  }

  Widget _buildPickAttendanceTime({
    String? title,
    VoidCallback? onTap,
    String? time,
  }) {
    return Expanded(
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title!, style: TextStyles.titleTextStyleBold,),
            SizedBox(height: 4,),
            InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.all(Radius.circular(10,)),
                ),
                padding: EdgeInsets.all(12,),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(time!,
                      style: TextStyles.titleTextStyle.copyWith(color: AppColors.textGrey),),
                    Icon(Icons.access_time, size: 22, color: AppColors.textGrey,),
                  ],
                ),
              ),
            ),
          ]),
    );
  }

  Widget _reasonForAdjustment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(top: 16,bottom: 8),
            child: Text('Reason of adjustment', style: TextStyles.titleTextStyleBold,)),
        ItemNotifiable<String?>(
          notifier: _reasonErrorNotifier,
          builder: (context, value) => LoginTextField(
            hint: 'Write your reason here',
            controller: _reasonTextController,
            errorText: value,
            fillColor: AppColors.greyColor,
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
      builder: (context, showLoader) => Container(
        height: 40,
        child: RoundedRectangleActionButton(
          title: 'Save',
          backgroundColor: AppColors.greenButtonColor,
          onPressed: () => _submitAdjustment(),
          showLoader: showLoader,
        ),
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
  void showStatusLoader() {
    _statusLoaderNotifier.notify(true);
  }

  @override
  void hideStatusLoader() {
    _statusLoaderNotifier.notify(false);
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
