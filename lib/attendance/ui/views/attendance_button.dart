import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance/services/time_to_punch_in_calculator.dart';
import 'package:wallpost/attendance/ui/presenters/attendance_presenter.dart';
import 'package:wallpost/attendance/ui/views/attendance_rectangle_rounded_action_button.dart';
import 'package:wallpost/attendance/ui/views/attendance_button_details.dart';

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

  //late num _remainingTimeToPunchIn = 0;
  late Timer _timer;
  String? _remainingTimeToPunchInString = "";

  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier();
  static const DISABLE_VIEW = 1;
  static const PUNCH_IN_BUTTON_VIEW = 2;
  static const PUNCH_OUT_BUTTON_VIEW = 3;
  static const LOADER_VIEW = 4;

  @override
  void initState() {
    presenter = AttendancePresenter(this);
    presenter.loadAttendanceDetails();
    // _timeString = _formatDateTime(DateTime.now());
    // Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        width: MediaQuery.of(context).size.width,
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
                } else if (value == PUNCH_OUT_BUTTON_VIEW) {
                  return _buildPunchOutButton();
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
            child:
            Text(
              "$_remainingTimeToPunchInString  To Punch In",
              style: TextStyle(color: Colors.white),
            )));
  }

  Widget _buildPunchInButton() {
    return AttendanceRectangleRoundedActionButton(
      title: "Punch In",
      subtitle: _locationAddress.length > 30
          ? '${_locationAddress.substring(0, 30)}...'
          : _locationAddress,
      status: "Abse",
      time: "10:10",
      attendanceButtonColor: AppColors.punchInButtonColor,
      moreButtonColor: AppColors.punchInMoreButtonColor,
      onButtonPressed: () {
        print("button");
      },
      onMorePressed: () {
        print("More");
        ScreenPresenter.presentAndRemoveAllPreviousScreens(
            AttendanceButtonDetailsScreen(), context);
      },
    );
  }

  Widget _buildPunchOutButton() {
    return AttendanceRectangleRoundedActionButton(
      title: "Punch Out",
      subtitle: _locationAddress.length > 30
          ? '${_locationAddress.substring(0, 30)}...'
          : _locationAddress,
      status: "",
      time: "10:10",
      attendanceButtonColor: AppColors.punchOutButtonColor,
      moreButtonColor: AppColors.punchOutMoreButtonColor,
      onButtonPressed: () {
        print("button punchout");
      },
      onMorePressed: () {
        ScreenPresenter.presentAndRemoveAllPreviousScreens(
            AttendanceButtonDetailsScreen(), context);
      },
    );
  }

  void _startCountDownTimer(num _start) {
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        _remainingTimeToPunchInString =
            TimeToPunchInCalculator.timeTillPunchIn(_start.toInt());
        if (_start == 0) {
          setState(() {
            timer.cancel();
            _viewTypeNotifier.notify(PUNCH_IN_BUTTON_VIEW);
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  // void _getTime() {
  //   final DateTime now = DateTime.now();
  //   final String formattedDateTime = _formatDateTime(now);
  //   setState(() {
  //     _timeString = formattedDateTime;
  //   });
  // }
  //
  // String _formatDateTime(DateTime dateTime) {
  //   return DateFormat('hh:mm a').format(dateTime);
  // }

  void _doPunchIn() {
    // presenter.validateLocation(true);
    print("doPunchIn>>>>>>>>>>>>>More");
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
    _viewTypeNotifier.notify(PUNCH_OUT_BUTTON_VIEW);
  }

  @override
  void showTimeTillPunchIn(num seconds) {
    // _remainingTimeToPunchIn = seconds;
    _startCountDownTimer(seconds);
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

  @override
  void showLocationPositions(num lat, num lon) {
    // TODO: implement showLocationPositions
  }
}
