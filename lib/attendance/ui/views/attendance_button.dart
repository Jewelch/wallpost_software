import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance/ui/presenters/attendance_presenter.dart';
import 'package:wallpost/attendance/ui/views/punchout_screen.dart';

import '../view_contracts/attendance_view.dart';

class AttendanceButton extends StatefulWidget {
  @override
  State<AttendanceButton> createState() => _AttendanceButtonState();
}

class _AttendanceButtonState extends State<AttendanceButton>
    implements AttendanceView {
  late final AttendancePresenter presenter;
  String? _timeString;
  String _locationAddress = "";
  late num _remainingTimeToPunchIn = 0;

  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier();
  static const DISABLE_VIEW = 1;
  static const PUNCH_IN_BUTTON_VIEW = 2;
  static const PUNCH_OUT_SCREEN = 3;
  static const LOADER_VIEW = 4;

  @override
  void initState() {
    presenter = AttendancePresenter(this);
    presenter.loadAttendanceDetails();
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        child: Column(
          children: [
            ItemNotifiable<int>(
              notifier: _viewTypeNotifier,
              builder: (context, value) {
                if (value == LOADER_VIEW) {
                  return _buildLoader();
                } else if (value == DISABLE_VIEW) {
                  return _buildDisableButton();
                } else if (value == PUNCH_IN_BUTTON_VIEW) {
                  return _buildPunchInButton();
                }
                return Container();
              },
            )
          ],
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return Container(
      margin: EdgeInsets.all(20),
      width: MediaQuery.of(context).size.width,
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.greyColor,
        borderRadius: BorderRadius.all(
          Radius.circular(20.0),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
        width: 20,
        height: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              backgroundColor: Colors.transparent,
              valueColor:
                  AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDisableButton() {
    return Container(
        margin: EdgeInsets.all(20),
        width: MediaQuery.of(context).size.width,
        height: 64,
        decoration: BoxDecoration(
          color: Colors.grey,
          borderRadius: BorderRadius.all(
            Radius.circular(20.0),
          ),
        ),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              "$_remainingTimeToPunchIn  To Punch In",
              style: TextStyle(color: Colors.white),
            )));
  }

  Widget _buildPunchInButton() {
    return Container(
      margin: EdgeInsets.all(20),
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(right: 12),
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.punchInButtonDarkColor,
              borderRadius: BorderRadius.all(
                Radius.circular(20.0),
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.punchInButtonDarkColor.withOpacity(0.5),
                  spreadRadius: 1,
                  blurRadius: 7,
                  offset: Offset(0, 3), // changes position of shadow
                ),
              ],
            ),
            child: Align(
                alignment: Alignment.centerRight,
                child: RichText(
                  text: TextSpan(
                    children: [
                      WidgetSpan(
                        child: Icon(
                          Icons.arrow_upward,
                          size: 20,
                          color: Colors.white,
                        ),
                      ),
                      TextSpan(
                        text: " More",
                      ),
                    ],
                  ),
                )),
          ),
          InkWell(
            onTap: () {
              _doPunchIn();
            },
            child: Container(
              margin: EdgeInsets.only(right: 72),
              padding: EdgeInsets.all(12),
              height: 64,
              decoration: BoxDecoration(
                color: AppColors.punchInButtonLightColor,
                borderRadius: BorderRadius.all(
                  Radius.circular(20.0),
                ),
              ),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Punch In",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(_locationAddress,
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.locationAddressTextColor))
                      ],
                    ),
                    Column(
                      children: [
                        //  Text( _timeString!,
                        Text(_timeString!,
                            style:
                                TextStyle(fontSize: 16, color: Colors.white)),
                        SizedBox(
                          height: 2,
                        ),
                        Text("Absent",
                            style: TextStyle(
                                fontSize: 12,
                                color: AppColors.attendanceStatusColor))
                      ],
                    ),
                  ]),
            ),
          ),
        ],
      ),
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  void _doPunchIn() {
    presenter.validateLocation(true);
  }

  @override
  void showLoader() {
    _viewTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void hideLoader() {}

  @override
  void showPunchInButton() {
    _viewTypeNotifier.notify(PUNCH_IN_BUTTON_VIEW);
  }

  @override
  void showPunchOutButton() {
    setState(() {
      ScreenPresenter.presentAndRemoveAllPreviousScreens(
          PunchOutScreen(), context);
    });
  }

  @override
  void showTimeTillPunchIn(num seconds) {
    _remainingTimeToPunchIn = seconds;
    _viewTypeNotifier.notify(DISABLE_VIEW);
  }

  @override
  void showPunchInTime(String time) {
    // TODO: implement showPunchInTime
  }

  @override
  void showPunchOutTime(String time) {
    // TODO: implement showPunchOutTime
  }

  @override
  void showLocationAddress(String address) {
    setState(() {
      _locationAddress = address;
    });
  }

  @override
  void showBreakButton() {
    // TODO: implement showBreakButton
  }

  @override
  void hideBreakButton() {
    // TODO: implement hideBreakButton
  }

  @override
  void showResumeButton() {
    // TODO: implement showResumeButton
  }

  @override
  void openAppSettings() {
    // TODO: implement openAppSettings
  }

  @override
  void showDisabledButton() {
    // TODO: implement showDisabledButton
  }

  @override
  void showAlertToDeniedLocationPermission(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void showAlertToTurnOnDeviceLocation(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void showAlertToVerifyLocation(String message) {
    Alert.showSimpleAlert(context: context, title: "", message: message);
  }

  @override
  void showError(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void showErrorMessage(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void showFailedToGetLocation(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void showMessageToAllowPunchInFromAppPermission(String message) {
    Alert.showSimpleAlert(context: context, title: "", message: message);
  }
}
