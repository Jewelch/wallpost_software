import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_report.dart';
import 'package:wallpost/attendance_punch_in_out/services/time_to_punch_in_calculator.dart';
import 'package:wallpost/attendance_punch_in_out/ui/presenters/attendance_presenter.dart';
import 'package:wallpost/attendance_punch_in_out/ui/views/attendance_button_details.dart';
import 'package:wallpost/attendance_punch_in_out/ui/views/attendance_rectangle_rounded_action_button.dart';

import '../view_contracts/attendance_view.dart';

class AttendanceButton extends StatefulWidget {
  @override
  State<AttendanceButton> createState() => _AttendanceButtonState();
}

class _AttendanceButtonState extends State<AttendanceButton> with WidgetsBindingObserver implements AttendanceView {
  late final AttendancePresenter presenter;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier(defaultValue: LOADER_VIEW);
  final ItemNotifier<String> _countDownNotifier = ItemNotifier(defaultValue: "");

  var _errorMessage = "";

  // String _remainingTimeToPunchInString = "";

  String? _timeString;
  late Timer _countDownTimer;
  late Timer _currentTimer;
  String _locationAddress = "";

  /*
  Types of views
  1. Loader
  2. error and retry (includes location soft denial as the presenter will re-initiate the permission approval)
  3. GPSDisabledView + go to setts
  4. location denied forever + go to setts


  4. Timer view
  5. punch in
  6. punch out
   */
  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const GPS_DISABLED_VIEW = 3;
  static const PERMISSION_DENIED_FOREVER_ERROR_VIEW = 4;
  static const COUNT_DOWN_VIEW = 5;

  static const PUNCH_IN_BUTTON_VIEW = 6;
  static const PUNCH_OUT_BUTTON_VIEW = 7;

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
    if (state == AppLifecycleState.resumed && presenter.shouldReloadDataWhenAppIsResumed()) {
      presenter.loadAttendanceDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      width: MediaQuery.of(context).size.width,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: ItemNotifiable<int>(
          notifier: _viewTypeNotifier,
          builder: (context, viewType) {
            if (viewType == LOADER_VIEW) return _buildLoader();

            if (viewType == ERROR_VIEW) return _errorAndRetryButton();

            if (viewType == GPS_DISABLED_VIEW) return _enableGpsButton();

            if (viewType == PERMISSION_DENIED_FOREVER_ERROR_VIEW) return _grantLocationPermissionButton();

            if (viewType == COUNT_DOWN_VIEW) return _buildCountDownView();

            if (viewType == PUNCH_IN_BUTTON_VIEW) return _buildPunchInButton();

            if (viewType == PUNCH_OUT_BUTTON_VIEW) return _buildPunchOutButton();

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return Container(
      color: Colors.red,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget _errorAndRetryButton() {
    return _errorButton(
      title: _errorMessage,
      onPressed: () => presenter.loadAttendanceDetails(),
    );
  }

  Widget _enableGpsButton() {
    return _errorButton(
      title: _errorMessage,
      onPressed: () => presenter.goToLocationSettings(),
    );
  }

  Widget _grantLocationPermissionButton() {
    return _errorButton(
      title: _errorMessage,
      onPressed: () => presenter.goToAppSettings(),
    );
  }

  Widget _errorButton({required String title, required VoidCallback onPressed}) {
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      color: Colors.purple,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildCountDownView() {
    return ItemNotifiable(
      notifier: _countDownNotifier,
      builder: (context, timeLeft) => Text(
        "$timeLeft to punch in",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildPunchInButton() {
    return AttendanceRectangleRoundedActionButton(
      title: "Punch In",
      subtitle: _locationAddress.length > 20 ? '${_locationAddress.substring(0, 20)}...' : _locationAddress,
      status: "",
      time: _timeString,
      attendanceButtonColor: AppColors.punchInButtonColor,
      moreButtonColor: AppColors.punchInMoreButtonColor,
      onButtonPressed: () {
        presenter.validateLocation(true);
      },
      onMoreButtonPressed: () {
        _currentTimer.cancel();
        ScreenPresenter.presentAndRemoveAllPreviousScreens(AttendanceButtonDetailsScreen(), context);
      },
    );
  }

  Widget _buildPunchOutButton() {
    return AttendanceRectangleRoundedActionButton(
      title: "Punch Out",
      subtitle: _locationAddress.length > 20 ? '${_locationAddress.substring(0, 20)}...' : _locationAddress,
      status: "",
      time: _timeString,
      attendanceButtonColor: AppColors.punchOutButtonColor,
      moreButtonColor: AppColors.punchOutMoreButtonColor,
      onButtonPressed: () {
        _doPunchOut();
      },
      onMoreButtonPressed: () {
        _currentTimer.cancel();
        ScreenPresenter.presentAndRemoveAllPreviousScreens(AttendanceButtonDetailsScreen(), context);
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
    if (this.mounted)
      //TODO:
      _timeString = formattedDateTime;
  }

  String _formatDateTime(DateTime dateTime) {
    return DateFormat('hh:mm a').format(dateTime);
  }

  void _startCountDownTimer(num _start) {
    const oneSec = const Duration(seconds: 1);
    _countDownTimer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        //TODO
        var _remainingTimeToPunchInString = TimeToPunchInCalculator.timeTillPunchIn(_start.toInt());
        if (_start == 0) {
          timer.cancel();
          presenter.loadAttendanceDetails();
        } else {
          _start--;
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
    _currentTimer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  @override
  void showPunchOutButton() {
    _viewTypeNotifier.notify(PUNCH_OUT_BUTTON_VIEW);
    _currentTimer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
  }

  // @override
  // void showTimeTillPunchIn(num seconds) {
  //   _startCountDownTimer(seconds);
  //   _viewTypeNotifier.notify(COUNT_DOWN_VIEW);
  // }

  @override
  void showPunchInTime(String time) {}

  @override
  void showPunchOutTime(String time) {}

  @override
  void showCountDownView(int asdfadf) {
    _viewTypeNotifier.notify(COUNT_DOWN_VIEW);
  }

  @override
  void showRequestToTurnOnGpsView(String message) {
    _errorMessage = message;
    _viewTypeNotifier.notify(GPS_DISABLED_VIEW);
  }

  @override
  void showRequestToEnableLocationView(String message) {
    _errorMessage = message;
    _viewTypeNotifier.notify(PERMISSION_DENIED_FOREVER_ERROR_VIEW);
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
  void showAddress(String address) {
    // setState(() {
    _locationAddress = address;
    // });
  }

  @override
  void showAttendanceReport(AttendanceReport attendanceReport) {}

  @override
  void doRefresh() {}

  @override
  void showErrorAndRetryView(String title, String message) {
    _errorMessage = message;
    _viewTypeNotifier.notify(ERROR_VIEW);
  }

  @override
  void showAlertToInvalidLocation(bool isForPunchIn, String title, String message) {
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
