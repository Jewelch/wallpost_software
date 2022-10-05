import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/views/attendance_action_button.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/views/attendance_details_screen.dart';

import '../../constants/attendance_colors.dart';
import '../../services/time_to_punch_in_calculator.dart';
import '../presenters/attendance_presenter.dart';
import '../view_contracts/attendance_view.dart';

class AttendanceWidget extends StatefulWidget {
  @override
  State<AttendanceWidget> createState() => _AttendanceWidgetState();
}

class _AttendanceWidgetState extends State<AttendanceWidget> with WidgetsBindingObserver implements AttendanceView {
  late final AttendancePresenter presenter;
  final ItemNotifier<int> _viewTypeNotifier = ItemNotifier(defaultValue: LOADER_VIEW);
  final ItemNotifier<String> _countDownNotifier = ItemNotifier(defaultValue: "");
  final ItemNotifier<String> _locationAddressNotifier = ItemNotifier(defaultValue: "");

  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const GPS_DISABLED_VIEW = 3;
  static const PERMISSION_DENIED_FOREVER_ERROR_VIEW = 4;
  static const COUNT_DOWN_VIEW = 5;
  static const PUNCH_IN_BUTTON_VIEW = 6;
  static const PUNCH_OUT_BUTTON_VIEW = 7;

  var _errorMessage = "";
  String? _timeString;
  Timer? _countDownTimer;
  Timer? _currentTimer;

  @override
  void initState() {
    presenter = AttendancePresenter(basicView: this);
    presenter.loadAttendanceDetails();
    WidgetsBinding.instance.addObserver(this);
    super.initState();
  }

  @override
  void dispose() {
    _cancelTimers();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _cancelTimers() {
    _currentTimer?.cancel();
    _countDownTimer?.cancel();
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
      height: 70,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AttendanceColors.buttonShadowColor.withOpacity(0.3),
            offset: Offset(0, 0),
            blurRadius: 20,
            spreadRadius: 0,
          ),
        ],
      ),
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

  //MARK: Functions to build the loader

  Widget _buildLoader() {
    return Container(
      color: AttendanceColors.disabledButtonColor,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Colors.transparent,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
        ),
      ),
    );
  }

  //MARK: Functions to build the error views

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
      color: AttendanceColors.disabledButtonColor,
      child: Text(
        title,
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      onPressed: onPressed,
    );
  }

  //MARK: Functions to build the countdown view

  Widget _buildCountDownView() {
    return ItemNotifiable(
      notifier: _countDownNotifier,
      builder: (context, timeLeft) => Container(
        color: AttendanceColors.disabledButtonColor,
        child: Center(
          child: Text(
            "$timeLeft To Punch In",
            style: TextStyles.titleTextStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  void _startCountDownTimer(num secondsTillPunchIn) {
    var start = secondsTillPunchIn;
    _countDownTimer = new Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      if (start == 0) {
        timer.cancel();
        presenter.loadAttendanceDetails();
        return;
      } else {
        var _remainingTimeToPunchInString = TimeToPunchInCalculator.timeTillPunchIn(start.toInt());
        _countDownNotifier.notify(_remainingTimeToPunchInString);
        start--;
      }
    });
  }

  //MARK: Functions to build punch in and out buttons

  Widget _buildPunchInButton() {
    return ItemNotifiable(
      notifier: _locationAddressNotifier,
      builder: (context, address) => AttendanceActionButton(
        title: "Punch In",
        locationAddress: "$address",
        time: _timeString ?? "",
        attendanceButtonColor: AttendanceColors.punchInButtonColor,
        moreButtonColor: AttendanceColors.punchInMoreButtonColor,
        onButtonPressed: () {
          presenter.markPunchIn(isLocationValid: true);
        },
        onRefreshPressed: () {
          presenter.loadAttendanceDetails();
        },
        onMoreButtonPressed: () {
          ScreenPresenter.present(AttendanceDetailsScreen(), context);
        },
      ),
    );
  }

  Widget _buildPunchOutButton() {
    return ItemNotifiable(
      notifier: _locationAddressNotifier,
      builder: (context, address) => AttendanceActionButton(
        title: "Punch Out",
        locationAddress: "$address",
        time: _timeString ?? "",
        attendanceButtonColor: AttendanceColors.punchOutButtonColor,
        moreButtonColor: AttendanceColors.punchOutMoreButtonColor,
        onButtonPressed: () {
          _doPunchOut();
        },
        onRefreshPressed: () {
          presenter.loadAttendanceDetails();
        },
        onMoreButtonPressed: () {
          ScreenPresenter.present(AttendanceDetailsScreen(), context);
        },
      ),
    );
  }

  void _doPunchOut() {
    Alert.showSimpleAlertWithButtons(
      context: context,
      title: "Punch Out",
      message: "Are you sure you want to punch out?",
      buttonOneTitle: "No",
      buttonTwoTitle: "Yes",
      buttonTwoOnPressed: () => presenter.markPunchOut(isLocationValid: true),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void showAttendanceButtonLoader() {
    _viewTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void showErrorAndRetryView(String message) {
    _errorMessage = message;
    _viewTypeNotifier.notify(ERROR_VIEW);
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
  void showCountDownView(int secondsTillPunchIn) {
    var _remainingTimeToPunchInString = TimeToPunchInCalculator.timeTillPunchIn(secondsTillPunchIn.toInt());
    _countDownNotifier.notify(_remainingTimeToPunchInString);

    _viewTypeNotifier.notify(COUNT_DOWN_VIEW);
    _startCountDownTimer(secondsTillPunchIn);
  }

  @override
  void showPunchInButton() {
    Timer(Duration(seconds: 1), () {
      _viewTypeNotifier.notify(PUNCH_IN_BUTTON_VIEW);
    });

    _currentTimer = Timer.periodic(Duration(milliseconds: 1), (Timer t) => _getCurrentTime());
  }

  @override
  void showPunchOutButton() {
    Timer(Duration(seconds: 1), () {
      _viewTypeNotifier.notify(PUNCH_OUT_BUTTON_VIEW);
    });

    _currentTimer = Timer.periodic(Duration(milliseconds: 1), (Timer t) => _getCurrentTime());
  }

  @override
  void showAddress(String address) {
    _locationAddressNotifier.notify(address);
  }

  @override
  void showAlertToMarkAttendanceWithInvalidLocation(bool isForPunchIn, String title, String message) {
    Alert.showSimpleAlertWithButtons(
      context: context,
      title: title,
      message: message,
      buttonOneTitle: "No",
      buttonTwoTitle: "Yes",
      buttonTwoOnPressed: () =>
          isForPunchIn ? presenter.markPunchIn(isLocationValid: false) : presenter.markPunchOut(isLocationValid: false),
    );
  }

  @override
  void showErrorMessage(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void doRefresh() {
    presenter.loadAttendanceDetails();
  }

  //MARK: Util functions

  void _getCurrentTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = DateFormat('hh:mm a').format(now);
    if (mounted) {
      setState(() => _timeString = formattedDateTime);
    }
  }

}
