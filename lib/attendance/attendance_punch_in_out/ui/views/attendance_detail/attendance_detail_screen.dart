import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/constants/attendance_colors.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/time_to_punch_in_calculator.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/presenters/attendance_presenter.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/presenters/attendance_report_presenter.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/view_contracts/attendance_view.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/views/attendance_detail/attendance_report_widget.dart';

import '../../../../../_common_widgets/app_bars/simple_app_bar.dart';
import '../../../../../_common_widgets/buttons/rounded_back_button.dart';
import 'attendance_detail_action_button.dart';
import 'attendance_detail_loader.dart';
import 'break_action_button.dart';

class AttendanceDetailScreen extends StatefulWidget {
  const AttendanceDetailScreen({Key? key}) : super(key: key);

  @override
  _AttendanceDetailScreenState createState() => _AttendanceDetailScreenState();
}

class _AttendanceDetailScreenState extends State<AttendanceDetailScreen>
    with WidgetsBindingObserver
    implements AttendanceView {
  late final AttendancePresenter presenter;
  late final AttendanceReportPresenter reportPresenter;
  final _viewTypeNotifier = ItemNotifier(defaultValue: LOADER_VIEW);
  final _countDownNotifier = ItemNotifier(defaultValue: "");
  var _locationNotifier = ItemNotifier<AttendanceLocation?>(defaultValue: null);
  var _attendanceButtonLoaderNotifier = ItemNotifier<bool>(defaultValue: false);
  var _breakButtonLoaderNotifier = ItemNotifier<bool>(defaultValue: false);

  static const LOADER_VIEW = 1;
  static const ERROR_VIEW = 2;
  static const GPS_DISABLED_VIEW = 3;
  static const PERMISSION_DENIED_FOREVER_ERROR_VIEW = 4;
  static const COUNT_DOWN_VIEW = 5;
  static const PUNCH_IN_BUTTON_VIEW = 6;
  static const PUNCH_OUT_BUTTON_VIEW = 7;

  late String _timeString;
  late Timer _currentTimer;
  late Timer _countDownTimer;
  var _errorMessage = "";

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
    _currentTimer.cancel();
    _countDownTimer.cancel();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) presenter.loadAttendanceDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SimpleAppBar(
        title: "Attendance Details",
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SafeArea(
        child: ItemNotifiable<int>(
          notifier: _viewTypeNotifier,
          builder: (context, viewType) {
            if (viewType == LOADER_VIEW) return AttendanceDetailLoader();

            if (viewType == ERROR_VIEW) return _errorAndRetryView();

            if (viewType == GPS_DISABLED_VIEW) return _enableGpsView();

            if (viewType == PERMISSION_DENIED_FOREVER_ERROR_VIEW) return _grantLocationPermissionView();

            if (viewType == COUNT_DOWN_VIEW) return _countDownView();

            if (viewType == PUNCH_IN_BUTTON_VIEW) return _punchInButton();

            if (viewType == PUNCH_OUT_BUTTON_VIEW) return _punchOutButton();

            return Container();
          },
        ),
      ),
    );
  }

  //MARK: Functions to build the error and retry view

  Widget _errorAndRetryView() {
    return _errorButton(
      title: _errorMessage,
      onPressed: () => presenter.loadAttendanceDetails(),
    );
  }

  Widget _enableGpsView() {
    return _errorButton(
      title: _errorMessage,
      onPressed: () => presenter.goToLocationSettings(),
    );
  }

  Widget _grantLocationPermissionView() {
    return _errorButton(
      title: _errorMessage,
      onPressed: () => presenter.goToAppSettings(),
    );
  }

  Widget _errorButton({required String title, required VoidCallback onPressed}) {
    return Container(
      child: Center(
        child: TextButton(
          child: Text(title, textAlign: TextAlign.center, style: TextStyles.titleTextStyle),
          onPressed: onPressed,
        ),
      ),
    );
  }

  //MARK: Functions to build the countdown view

  Widget _countDownView() {
    return _dataView(
      content: ItemNotifiable<String>(
        notifier: _countDownNotifier,
        builder: (context, timeLeft) => _attendanceButton(
          title: timeLeft,
          subTitle: "To Punch In",
          buttonColor: AttendanceColors.disabledButtonColor,
          onPressed: () => {},
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

  Widget _punchInButton() {
    return _dataView(
      content: _attendanceButton(
        title: "Punch In",
        subTitle: _timeString,
        buttonColor: AttendanceColors.punchInButtonColor,
        onPressed: () => presenter.markPunchIn(isLocationValid: true),
      ),
    );
  }

  Widget _punchOutButton() {
    return _dataView(
      content: Column(
        children: [
          _attendanceButton(
            title: "Punch Out",
            subTitle: _timeString,
            buttonColor: AttendanceColors.punchOutButtonColor,
            onPressed: () => _doPunchOut(),
          ),
          SizedBox(height: 4),
          presenter.shouldShowStartBreakButton() ? _startBreakButton() : _endBreakButton(),
        ],
      ),
    );
  }

  void _doPunchOut() {
    Alert.showSimpleAlertWithButtons(
        context: context,
        title: "Punch Out",
        message: " Do you really want to punch out? ",
        buttonOneTitle: "Cancel",
        buttonTwoTitle: "Yes",
        buttonTwoOnPressed: () => presenter.markPunchOut(isLocationValid: true));
  }

  //MARK: Function to build the data view

  Widget _dataView({required Widget content}) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            alignment: Alignment.center,
            children: [
              _mapView(),
              Positioned(
                bottom: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildAttendanceTimeView("Punch In", presenter.getPunchInTime()),
                    SizedBox(width: 12),
                    content,
                    SizedBox(width: 12),
                    _buildAttendanceTimeView("Punch Out", presenter.getPunchOutTime()),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 80),
        AttendanceReportWidget(),
        SizedBox(height: 30),
      ],
    );
  }

  //MARK: Functions to build map view

  Widget _mapView() {
    return Container(
      margin: EdgeInsets.only(bottom: 70, right: 12),
      child: ItemNotifiable<AttendanceLocation?>(
        notifier: _locationNotifier,
        builder: (context, location) => ClipRRect(
          borderRadius: BorderRadius.only(topRight: Radius.circular(28), bottomRight: Radius.circular(28)),
          child: location == null
              ? Container()
              : GoogleMap(
                  zoomControlsEnabled: false,
                  compassEnabled: false,
                  tiltGesturesEnabled: false,
                  rotateGesturesEnabled: false,
                  myLocationButtonEnabled: false,
                  scrollGesturesEnabled: false,
                  initialCameraPosition: CameraPosition(
                    target: LatLng(location.latitude.toDouble(), location.longitude.toDouble()),
                    zoom: 16.0,
                  ),
                  markers: Set<Marker>()
                    ..add(Marker(
                      markerId: MarkerId('Current Location'),
                      position: LatLng(location.latitude.toDouble(), location.longitude.toDouble()),
                    )),
                ),
        ),
      ),
    );
  }

  //MARK: Function to build the attendance time view

  Widget _buildAttendanceTimeView(String label, String time) {
    return Column(
      children: [
        Text(time, style: TextStyles.largeTitleTextStyleBold),
        SizedBox(height: 2),
        Text(label, style: TextStyles.titleTextStyle),
      ],
    );
  }

  //MARK: Functions to build the attendance and break buttons

  Widget _attendanceButton({
    required String title,
    required String subTitle,
    required Color buttonColor,
    required VoidCallback onPressed,
  }) {
    return ItemNotifiable<bool>(
      notifier: _attendanceButtonLoaderNotifier,
      builder: (context, showLoader) {
        return AttendanceDetailActionButton(
          title: title,
          subTitle: subTitle,
          buttonColor: buttonColor,
          onPressed: onPressed,
          showLoader: showLoader,
        );
      },
    );
  }

  //MARK: Functions to build start break and end buttons

  Widget _startBreakButton() {
    return _breakButton(title: "Start Break", onPressed: () => presenter.startBreak());
  }

  Widget _endBreakButton() {
    return _breakButton(title: "End Break", onPressed: () => presenter.endBreak());
  }

  Widget _breakButton({required String title, required VoidCallback onPressed}) {
    return ItemNotifiable<bool>(
      notifier: _breakButtonLoaderNotifier,
      builder: (context, showLoader) => BreakActionButton(
          title: title,
          buttonColor: AttendanceColors.breakButtonColor,
          textColor: AttendanceColors.breakButtonTextColor,
          showLoader: showLoader,
          onButtonPressed: onPressed),
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void showAttendanceButtonLoader() {
    _attendanceButtonLoaderNotifier.notify(true);
  }

  @override
  void showButtonBreakLoader() {
    _breakButtonLoaderNotifier.notify(true);
  }

  @override
  void showErrorAlert(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void showErrorAndRetryView(String message) {
    _viewTypeNotifier.notify(ERROR_VIEW);
    _errorMessage = message;
  }

  @override
  void showRequestToTurnOnGpsView(String message) {
    _viewTypeNotifier.notify(GPS_DISABLED_VIEW);
    _errorMessage = message;
  }

  @override
  void showRequestToEnableLocationView(String message) {
    _viewTypeNotifier.notify(PERMISSION_DENIED_FOREVER_ERROR_VIEW);
    _errorMessage = message;
  }

  @override
  void showCountDownView(int secondsTillPunchIn) {
    var _remainingTimeToPunchInString = TimeToPunchInCalculator.timeTillPunchIn(secondsTillPunchIn.toInt());
    _countDownNotifier.notify(_remainingTimeToPunchInString);
    _attendanceButtonLoaderNotifier.notify(false);

    _viewTypeNotifier.notify(COUNT_DOWN_VIEW);
    _startCountDownTimer(secondsTillPunchIn);
  }

  @override
  void showPunchInButton() {
    _viewTypeNotifier.notify(PUNCH_IN_BUTTON_VIEW);
    _attendanceButtonLoaderNotifier.notify(false);

    _currentTimer = Timer.periodic(Duration(milliseconds: 1), (Timer t) => _getCurrentTime());
  }

  @override
  void showPunchOutButton() {
    _viewTypeNotifier.notify(PUNCH_OUT_BUTTON_VIEW);
    _attendanceButtonLoaderNotifier.notify(false);
    _breakButtonLoaderNotifier.notify(false);

    _currentTimer = Timer.periodic(Duration(milliseconds: 1), (Timer t) => _getCurrentTime());
  }

  @override
  void showLocation(AttendanceLocation attendanceLocation, String address) {
    _locationNotifier.notify(attendanceLocation);
  }

  @override
  void showAlertToMarkAttendanceWithInvalidLocation(bool isForPunchIn, String title, String message) {
    Alert.showSimpleAlertWithButtons(
      context: context,
      title: title,
      message: message,
      buttonOneTitle: "Cancel",
      buttonTwoTitle: "Yes",
      buttonTwoOnPressed: () =>
          isForPunchIn ? presenter.markPunchIn(isLocationValid: false) : presenter.markPunchOut(isLocationValid: false),
    );
  }

  //MARK: Util functions

  void _getCurrentTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = DateFormat('hh:mm a').format(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }
}
