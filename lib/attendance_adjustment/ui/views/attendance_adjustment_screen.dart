import 'package:flutter/material.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/app_bars/simple_app_bar.dart';
import 'package:wallpost/_common_widgets/buttons/circular_icon_button.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_list_item.dart';
import 'package:wallpost/attendance_adjustment/entities/attendance_status.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_adjustment_presenter.dart';
import 'package:wallpost/attendance_adjustment/ui/presenters/attendance_list_presenter.dart';
import 'package:wallpost/attendance_adjustment/ui/view_contracts/attendance_adjustment_view.dart';

class AttendanceAdjustmentScreen extends StatefulWidget {
  final AttendanceListPresenter attendanceListPresenter;
  final AttendanceListItem attendanceListItem;

  const AttendanceAdjustmentScreen(
      {Key? key,
      required this.attendanceListPresenter,
      required this.attendanceListItem})
      : super(key: key);

  @override
  _AttendanceAdjustmentScreenState createState() =>
      _AttendanceAdjustmentScreenState();
}

class _AttendanceAdjustmentScreenState extends State<AttendanceAdjustmentScreen>
    implements AttendanceAdjustmentView {
  var _reasonErrorNotifier = ItemNotifier<String>();
  var _reasonTextController = TextEditingController();

  late AttendanceAdjustmentPresenter presenter;
  late Loader loader;

  @override
  void initState() {
    loader = Loader(context);
    presenter = AttendanceAdjustmentPresenter(this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: 'Adjust Attendance',
        showDivider: true,
        leadingButtons: [
          CircularIconButton(
            color: Colors.white,
            iconColor: AppColors.defaultColor,
            iconName: 'assets/icons/close_icon.svg',
            onPressed: () => Navigator.pop(context),
          )
        ],
        trailingButtons: [
          CircularIconButton(
            color: Colors.white,
            iconColor: AppColors.defaultColor,
            iconName: 'assets/icons/check_mark_icon.svg',
            onPressed: _submitAdjustment,
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _dateAndStatus(),
              _dottedLineDivider(),
              Container(
                padding: EdgeInsets.only(bottom: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Punched In',
                      style: TextStyle(
                          color: presenter.punchInOutLabelColorForItem(
                                  widget.attendanceListItem)),
                    ),
                    Text(
                      widget.attendanceListItem.originalPunchInTime,
                      style: TextStyle(color: AppColors.labelColor),
                    ),
                  ],
                ),
              ),
              _adjustPunchInTime(),
              Container(
                padding: EdgeInsets.only(bottom: 8.0,top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Punched Out',
                      style: TextStyle(
                          color: presenter.punchInOutLabelColorForItem(
                                  widget.attendanceListItem)),
                    ),
                    Text(
                      widget.attendanceListItem.originalPunchOutTime,
                      style: TextStyle(color: AppColors.labelColor),
                    ),
                  ],
                ),
              ),
              _adjustPunchOutTime(),
              _reasonForAdjustment(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _dateAndStatus() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.attendanceListItem.getReadableDate(),
          style: TextStyle(color: AppColors.defaultColorDark),
        ),
        Text(
          widget.attendanceListItem.status.toReadableString(),
          style: TextStyle(
              color: widget.attendanceListPresenter
                  .getStatusColorForItem(widget.attendanceListItem)),
        ),
      ],
    );
  }

  Widget _dottedLineDivider() {
    return Container(
      height: 24,
      child: Row(
        children: List.generate(
            150 ~/ 2,
            (index) => Expanded(
                  child: Container(
                    color: index % 2 == 0 ? Colors.grey : Colors.transparent,
                    height: 1,
                  ),
                )),
      ),
    );
  }

  Widget _adjustPunchInTime() {
    return Container(
      padding: EdgeInsets.only(top: 4.0, left: 4, right: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
        color: presenter.adjustedPunchInColor,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Adjust Punch In',
                    style: TextStyle(color:  Colors.black,),
                  ),

                  TextSpan(
                      text: presenter.punchInAdjusted ?? '',
                      style: TextStyle(color: AppColors.defaultColor,fontSize: 12),
                  ),
                ]),
              ),

          Container(
            padding: EdgeInsets.only(top: 12.0),
            child: InkWell(
              onTap: _pickPunchInTime,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${presenter.punchInTime.hour}',
                    style: TextStyle(color: AppColors.defaultColorDark),
                  ),
                  Text(
                    ':',
                  ),
                  Text(
                    '${presenter.punchInTime.minute}',
                    style: TextStyle(color: AppColors.defaultColorDark),
                  ),
                  Text(
                    presenter.getPeriod(presenter.punchInTime),
                    style: TextStyle(color: AppColors.defaultColorDark),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _adjustPunchOutTime() {
    return Container(
      padding: EdgeInsets.only(top: 4.0, left: 4, right: 4),
      decoration: BoxDecoration(
        color: presenter.adjustedPunchOutColor,
        borderRadius: BorderRadius.all(
          Radius.circular(10.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Adjust Punch Out',
                    style: TextStyle(color: Colors.black),
                  ),
                  TextSpan(
                    text: presenter.punchOutAdjusted ?? '',
                    style: TextStyle(color: AppColors.defaultColor,fontSize: 12),
                  ),
                ]),
          ),
          Container(
            padding: EdgeInsets.only(top: 12.0),
            child: InkWell(
              onTap: _pickPunchOutTime,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    '${presenter.punchOutTime.hour}',
                    style: TextStyle(color: AppColors.defaultColorDark),
                  ),
                  Text(
                    ':',
                  ),
                  Text(
                    '${presenter.punchOutTime.minute}',
                    style: TextStyle(color: AppColors.defaultColorDark),
                  ),
                  Text(
                    presenter.getPeriod(presenter.punchOutTime),
                    style: TextStyle(color: AppColors.defaultColorDark),
                  ),
                ],
              ),
            ),
          ),
          Divider(),
        ],
      ),
    );
  }

  Widget _reasonForAdjustment() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            padding: EdgeInsets.only(bottom: 12.0, top: 20),
            child: Text('Reason of adjustment')),
        ItemNotifiable<String>(
          notifier: _reasonErrorNotifier,
          builder: (context, value) => TextField(
            controller: _reasonTextController,
            minLines: 4,
            keyboardType: TextInputType.multiline,
            maxLines: 8,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderSide: BorderSide(color: AppColors.greyColor, width: 1.0),
              ),
              hintText: 'write your reason here',
              errorText: value,
            ),
          ),
        )
      ],
    );
  }

  void _pickPunchInTime() async {
    presenter.adjustedTime = (await showTimePicker(
      context: context,
      initialTime: presenter.punchInTime,
    ))!;
    if (presenter.adjustedTime != null) {
      setState(() {
          presenter.changePropertiesOfPunchInContainer();
      });
    }
    presenter.getAdjustedPunchIn();
    _getAdjustedStatus();
  }

  void _pickPunchOutTime() async {
    presenter.adjustedTime = (await showTimePicker(
      context: context,
      initialTime: presenter.punchOutTime,
    ))!;
    if (presenter.adjustedTime != null) {
      setState(() {
          presenter.changePropertiesOfPunchOutContainer();
      });
    }
    presenter.getAdjustedPunchOut();
    _getAdjustedStatus();
  }

  _getAdjustedStatus() {
    presenter.loadAdjustedStatus(widget.attendanceListItem.date);
  }

  void _submitAdjustment() {
      presenter.submitAdjustment(
          widget.attendanceListItem.date,
          _reasonTextController.text);
  }

  @override
  void showLoader() {
    loader.showLoadingIndicator("Loading...");
  }

  @override
  void hideLoader() {
    loader.hideOpenDialog();
  }

  @override
  void clearError() {
      _reasonErrorNotifier.notify(null);
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
  void onAdjustAttendanceSuccess(String title,String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message,
        onPressed: () => Navigator.pop(context));
  }

  @override
  void onAdjustAttendanceFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void onGetAdjustedStatusFailed(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

}
