import 'dart:async';

import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance/entities/attendance_location.dart';
import 'package:wallpost/attendance/entities/attendance_report.dart';
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
    with WidgetsBindingObserver
    implements AttendanceView {

  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier();
  late final AttendancePresenter presenter;
  String? _timeString;
  String _locationAddress = "";
  String? _remainingTimeToPunchInString;
  late Timer _countDownTimer;
  late Timer _currentTimer;
  static const DISABLE_VIEW = 1;
  static const PUNCH_IN_BUTTON_VIEW = 2;
  static const PUNCH_OUT_BUTTON_VIEW = 3;
  static const LOADER_VIEW = 4;

  @override
  void initState() {
    presenter = AttendancePresenter(this);
    presenter.loadAttendanceDetails();
    _timeString = _formatDateTime(DateTime.now());
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    _currentTimer.cancel();
    _countDownTimer.cancel();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      presenter.loadAttendanceDetails();
    }
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
                  return _buildDisableView();
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

  Widget _buildDisableView() {
    if (_remainingTimeToPunchInString == null)
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
                "Loading...To Punch In",
                style: TextStyle(color: Colors.white),
              )));
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
              "$_remainingTimeToPunchInString To Punch In",
              style: TextStyle(color: Colors.white),
            )));
  }

  Widget _buildPunchInButton() {
    return AttendanceRectangleRoundedActionButton(
      title: "Punch In",
      subtitle: _locationAddress.length > 20
          ? '${_locationAddress.substring(0, 20)}...'
          : _locationAddress,
      status: "",
      time: _timeString,
      attendanceButtonColor: AppColors.punchInButtonColor,
      moreButtonColor: AppColors.punchInMoreButtonColor,
      onButtonPressed: () {
        presenter.validateLocation(true);
      },
      onMoreButtonPressed: () {
        _currentTimer.cancel();
        ScreenPresenter.presentAndRemoveAllPreviousScreens(
            AttendanceButtonDetailsScreen(), context);
      },
    );
  }

  Widget _buildPunchOutButton() {
    return AttendanceRectangleRoundedActionButton(
      title: "Punch Out",
      subtitle: _locationAddress.length > 20
          ? '${_locationAddress.substring(0, 20)}...'
          : _locationAddress,
      status: "",
      time: _timeString,
      attendanceButtonColor: AppColors.punchOutButtonColor,
      moreButtonColor: AppColors.punchOutMoreButtonColor,
      onButtonPressed: () {
        _doPunchOut();
      },
      onMoreButtonPressed: () {
        _currentTimer.cancel();
        ScreenPresenter.presentAndRemoveAllPreviousScreens(
            AttendanceButtonDetailsScreen(), context);
      },
    );
  }



  void _doPunchOut() {
    Alert.showSimpleAlertWithButtons(
      context: context,
      title: "Punch Out",
      message: " Do you really want to punch out ? ",
      buttonOneTitle: "Cancel",
      buttonTwoTitle: "Yes",
      buttonTwoOnPressed: () {
        presenter.validateLocation(false);
      },
    );
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
   if(this.mounted) setState(() {
      _timeString = formattedDateTime;
    });
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  void _startCountDownTimer(num _start) {
    const oneSec = const Duration(seconds: 1);
    _countDownTimer = new Timer.periodic(
      oneSec,
          (Timer timer) {
        _remainingTimeToPunchInString =
            TimeToPunchInCalculator.timeTillPunchIn(_start.toInt());
        if (_start == 0) {
          setState(() {
            timer.cancel();
            presenter.loadAttendanceDetails();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void hideLoader() {}

  @override
  void showPunchInButton() {
    _viewTypeNotifier.notify(PUNCH_IN_BUTTON_VIEW);
    _currentTimer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void showPunchOutButton() {
    _viewTypeNotifier.notify(PUNCH_OUT_BUTTON_VIEW);
    _currentTimer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void showTimeTillPunchIn(num seconds) {
    _startCountDownTimer(seconds);
    _viewTypeNotifier.notify(DISABLE_VIEW);
  }

  @override
  void showPunchInTime(String time) {}

  @override
  void showPunchOutTime(String time) {}

  @override
  void showDisabledButton() {
    _viewTypeNotifier.notify(DISABLE_VIEW);
  }

  @override
  void requestToTurnOnDeviceLocation(String title, String message) {
    Alert.showSimpleAlert(
        context: context,
        title: title,
        message: message,
        onPressed: () {
          AppSettings.openLocationSettings();
        });
  }

  @override
  void requestToLocationPermissions(String title, String message) {
    Alert.showSimpleAlert(
        context: context,
        title: title,
        message: message,
        onPressed: () {
          presenter.loadAttendanceDetails();
        });
  }

  @override
  void openAppSettings() {
    AppSettings.openAppSettings();
  }

  @override
  void showBreakButton() {}

  @override
  void hideBreakButton() {}

  @override
  void showResumeButton() {}

  @override
  void showLocationPositions(AttendanceLocation attendanceLocation) {}

  @override
  void showLocationAddress(String address) {
    setState(() {
      _locationAddress = address;
    });
  }

  @override
  void showAttendanceReport(AttendanceReport attendanceReport) {}

  @override
  void loadAttendanceDetails() {
    presenter.loadAttendanceDetails();
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
  void showAlertToInvalidLocation(
      bool isForPunchIn, String title, String message) {
    Alert.showSimpleAlertWithButtons(
      context: context,
      title: title,
      message: message,
      buttonOneTitle: "Cancel",
      buttonTwoTitle: "Yes",
      buttonTwoOnPressed: () {
        if (isForPunchIn) {
          presenter.doPunchIn(false);
        } else {
          presenter.doPunchOut(false);
        }
      },
    );
  }
}
