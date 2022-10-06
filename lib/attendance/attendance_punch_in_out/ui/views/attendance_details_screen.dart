import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/constants/attendance_colors.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_report.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/time_to_punch_in_calculator.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/presenters/attendance_presenter.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/view_contracts/attendance_detailed_view.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/view_contracts/attendance_view.dart';

import '../../../../_common_widgets/app_bars/simple_app_bar.dart';
import '../../../../_common_widgets/buttons/rounded_back_button.dart';

class AttendanceDetailsScreen extends StatefulWidget {
  const AttendanceDetailsScreen({Key? key}) : super(key: key);

  @override
  _AttendanceDetailsScreenState createState() => _AttendanceDetailsScreenState();
}

class _AttendanceDetailsScreenState extends State<AttendanceDetailsScreen>
    with WidgetsBindingObserver
    implements AttendanceView, AttendanceDetailedView {
  var _viewSelectorNotifier = ItemNotifier<int>(defaultValue: 0);
  var _buttonTypeNotifier = ItemNotifier<int>(defaultValue: PUNCH_IN_BUTTON_VIEW);
  var _breakButtonNotifier = ItemNotifier<int>(defaultValue: SHOW_BREAK_BUTTON_VIEW);
  var _attendanceReportNotifier = ItemNotifier<AttendanceReport?>(defaultValue: null);
  var _locationOnMapNotifier = ItemNotifier<AttendanceLocation?>(defaultValue: null);
  var _punchInTimeNotifier = ItemNotifier<String?>(defaultValue: null);
  var _punchOutTimeNotifier = ItemNotifier<String?>(defaultValue: null);
  final ItemNotifier<String> _countDownTimeNotifier = ItemNotifier(defaultValue: "");
  var _viewSelectorReportNotifier = ItemNotifier<int>(defaultValue: 0);
  late final AttendancePresenter presenter;
  late String _timeString;
  late Timer _currentTimer;
  late Timer _countDownTimer;
  var _errorMessage = "";

  static const LOADER_VIEW = 1;

  static const DATA_VIEW = 2;

  static const ERROR_VIEW = 3;
  static const GPS_DISABLED_VIEW = 4;
  static const PERMISSION_DENIED_FOREVER_ERROR_VIEW = 5;

  static const COUNT_DOWN_VIEW = 6;
  static const PUNCH_IN_BUTTON_VIEW = 7;
  static const PUNCH_OUT_BUTTON_VIEW = 8;

  static const SHOW_BREAK_BUTTON_VIEW = 9;
  static const HIDE_BREAK_BUTTON_VIEW = 10;
  static const RESUME_BUTTON_VIEW = 11;

  static const REPORT_LOADER_VIEW = 12;
  static const REPORT_ERROR_VIEW = 13;
  static const REPORT_DATA_VIEW = 14;

  @override
  void initState() {
    presenter = AttendancePresenter(basicView: this, detailedView: this);
    presenter.loadAttendanceDetails();
    // presenter.loadAttendanceReport();

    _currentTimer = Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    _currentTimer.cancel();
    _countDownTimer.cancel();
    WidgetsBinding.instance.removeObserver(this);
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
      appBar: SimpleAppBar(
        title: "Approvals",
        leadingButton: RoundedBackButton(onPressed: () => Navigator.pop(context)),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: ItemNotifiable<int>(
          notifier: _viewSelectorNotifier,
          builder: (context, viewType) {
            if (viewType == LOADER_VIEW) return _buildLoader();

            if (viewType == ERROR_VIEW) return _errorAndRetryView();

            if (viewType == GPS_DISABLED_VIEW) return _enableGpsView();

            if (viewType == PERMISSION_DENIED_FOREVER_ERROR_VIEW) return _grantLocationPermissionView();

            if (viewType == DATA_VIEW) return _dataView();

            return Container();
          },
        )),
      ),
    );
  }

  //MARK: Functions to build the loader

  Widget _buildLoader() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      height: 50,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: AttendanceColors.disabledButtonColor,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
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

  Widget _reportErrorAndRetryView() {
    return _errorButton(
      title: _errorMessage,
      onPressed: () {
        // presenter.loadAttendanceReport()
      },
    );
  }

  Widget _errorButton({required String title, required VoidCallback onPressed}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      height: 80,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextButton(
              child: Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyles.titleTextStyle,
              ),
              onPressed: onPressed,
            ),
          ],
        ),
      ),
    );
  }

  Widget _dataView() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          clipBehavior: Clip.none,
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  height: 400,
                  margin: EdgeInsets.only(right: 10),
                  child: _mapView(),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  height: 70,
                  child: _buildAttendanceTimeView(),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(width: 140, height: 140, child: _buildAttendanceButtonView()),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(width: 140, child: _buildBreakButtonView()),
        SizedBox(height: 16),
        Container(padding: EdgeInsets.symmetric(horizontal: 12), child: _buildAttendanceReportView())
      ],
    );
  }

  //MARK: Functions to map view

  Widget _mapView() {
    return ItemNotifiable<AttendanceLocation?>(
      notifier: _locationOnMapNotifier,
      builder: (context, location) => ClipRRect(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
          child: GoogleMap(
            zoomControlsEnabled: false,
            compassEnabled: false,
            zoomGesturesEnabled: false,
            scrollGesturesEnabled: false,
            tiltGesturesEnabled: false,
            rotateGesturesEnabled: false,
            initialCameraPosition: CameraPosition(
              target: LatLng(location!.latitude.toDouble(), location.longitude.toDouble()),
              zoom: 14.0,
            ),
            markers: Set<Marker>()
              ..add(Marker(
                markerId: MarkerId(''),
                position: LatLng(location.latitude.toDouble(), location.longitude.toDouble()),
              )),
          )),
    );
  }

  Widget _buildAttendanceTimeView() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          children: [_buildPunchInTime(), SizedBox(height: 2), Text("Punch In", style: TextStyles.titleTextStyle)],
        ),
        Column(
          children: [_buildPunchOutTime(), SizedBox(height: 2), Text("Punch Out", style: TextStyles.titleTextStyle)],
        )
      ],
    );
  }

//MARK: Functions to punch in and out time view

  Widget _buildPunchInTime() {
    return ItemNotifiable<String?>(
        notifier: _punchInTimeNotifier,
        builder: (context, time) {
          if (time != null)
            return Text(time, style: TextStyles.titleTextStyleBold);
          else
            return Text("_ _ _");
        });
  }

  Widget _buildPunchOutTime() {
    return ItemNotifiable<String?>(
        notifier: _punchOutTimeNotifier,
        builder: (context, time) {
          if (time != null)
            return Text(time, style: TextStyles.titleTextStyleBold);
          else
            return Text("_ _ _");
        });
  }

  Widget _buildAttendanceButtonView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: ItemNotifiable<int>(
        notifier: _buttonTypeNotifier,
        builder: (context, value) {
          if (value == PUNCH_IN_BUTTON_VIEW) return _buildPunchInButton();

          if (value == PUNCH_OUT_BUTTON_VIEW) return _buildPunchOutButton();

          if (value == COUNT_DOWN_VIEW) return _buildCountDownView();

          return Container();
        },
      ),
    );
  }

  //MARK: Functions to build the countdown view

  Widget _buildCountDownView() {
    return ItemNotifiable(
      notifier: _countDownTimeNotifier,
      builder: (context, timeLeft) => Container(
        color: AttendanceColors.disabledButtonColor,
        child: Center(
          child: Text(
            "$timeLeft\nto punch in",
            style: TextStyle(color: Colors.white),
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
        _countDownTimeNotifier.notify(_remainingTimeToPunchInString);
        start--;
      }
    });
  }

//MARK: Functions to build punch in and out buttons

  Widget _buildPunchInButton() {
    return _actionButton(
      title: "Punch In",
      time: _timeString,
      buttonColor: AttendanceColors.punchInButtonColor,
      onPressed: () => presenter.markPunchIn(isLocationValid: true),
    );
  }

  Widget _buildPunchOutButton() {
    return _actionButton(
      title: "Punch Out",
      time: _timeString,
      buttonColor: AttendanceColors.punchOutButtonColor,
      onPressed: () => _doPunchOut(),
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

  Widget _actionButton(
      {required String title, required String time, required Color buttonColor, required VoidCallback onPressed}) {
    return MaterialButton(
      padding: EdgeInsets.all(20),
      elevation: 0,
      highlightElevation: 0,
      color: buttonColor,
      child: Column(
        children: [
          Icon(Icons.access_time, size: 32, color: Colors.white),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyles.titleTextStyle.copyWith(color: Colors.white),
          ),
          Text(
            time,
            style: TextStyles.titleTextStyle.copyWith(color: Colors.white),
          )
        ],
      ),
      onPressed: onPressed,
    );
  }

  Widget _buildBreakButtonView() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: ItemNotifiable<int>(
        notifier: _breakButtonNotifier,
        builder: (context, value) {
          if (value == SHOW_BREAK_BUTTON_VIEW) return _buildStartBreakButton();

          if (value == RESUME_BUTTON_VIEW) return _buildEndBreakButton();

          if (value == HIDE_BREAK_BUTTON_VIEW) return Container();

          return Container();
        },
      ),
    );
  }

  //MARK: Functions to build start break and end buttons

  Widget _buildStartBreakButton() {
    return _breakActionButton(
        title: "Start Break",
        buttonColor: AttendanceColors.breakButtonColor,
        textColor: AttendanceColors.breakButtonTextColor,
        onButtonPressed: () => presenter.startBreak());
  }

  Widget _buildEndBreakButton() {
    return _breakActionButton(
        title: "Resume",
        buttonColor: AttendanceColors.resumeButtonColor,
        textColor: Colors.white,
        onButtonPressed: () => presenter.endBreak());
  }

  Widget _breakActionButton(
      {required String title,
      required Color buttonColor,
      required Color textColor,
      required VoidCallback onButtonPressed}) {
    return ElevatedButton(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.coffee_outlined,
            color: textColor,
            size: 18,
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyles.titleTextStyle.copyWith(color: textColor),
          ),
        ],
      ),
      onPressed: onButtonPressed,
      style: ElevatedButton.styleFrom(
        primary: buttonColor,
        onPrimary: textColor,
        elevation: 0.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }

  //MARK: Functions to build attendance report

  Widget _buildAttendanceReportView() {
    return ItemNotifiable<int?>(
      notifier: _viewSelectorReportNotifier,
      builder: (context, viewType) {
        if (viewType == REPORT_LOADER_VIEW) return _buildLoader();

        if (viewType == REPORT_ERROR_VIEW) return _reportErrorAndRetryView();

        if (viewType == REPORT_DATA_VIEW) return _attendanceReportDataView();

        return Container();
      },
    );
  }

  Widget _attendanceReportDataView() {
    return ItemNotifiable<AttendanceReport?>(
        notifier: _attendanceReportNotifier,
        builder: (context, attendanceReport) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _attendanceReportDetails("Late Punch In", attendanceReport!.late, Colors.deepOrange),
              _attendanceReportDetails("Early Punch Out", attendanceReport.earlyLeave, Colors.black),
              _attendanceReportDetails("Absences", attendanceReport.absents, Colors.red)
            ],
          );
        });
  }

  Widget _attendanceReportDetails(String title, num noOfDays, Color textColor) {
    return Column(
      children: [
        noOfDays == 1
            ? Text("$noOfDays Day", style: TextStyles.titleTextStyleBold.copyWith(color: textColor))
            : Text("$noOfDays Days", style: TextStyles.titleTextStyleBold.copyWith(color: textColor)),
        SizedBox(height: 8),
        Text(title, style: TextStyles.titleTextStyle.copyWith(color: Colors.black))
      ],
    );
  }

  //MARK: View functions

  @override
  void showAttendanceReportLoader() {
    _viewSelectorReportNotifier.notify(REPORT_LOADER_VIEW);
  }

  @override
  void showAttendanceReportErrorAndRetryView(String message) {
    _viewSelectorReportNotifier.notify(REPORT_ERROR_VIEW);
    _errorMessage = message;
  }

  @override
  void showLoader() {
    _viewSelectorNotifier.notify(LOADER_VIEW);
  }

  @override
  void showErrorAndRetryView(String message) {
    _viewSelectorNotifier.notify(ERROR_VIEW);
    _errorMessage = message;
  }

  @override
  void showRequestToTurnOnGpsView(String message) {
    _viewSelectorNotifier.notify(GPS_DISABLED_VIEW);
    _errorMessage = message;
  }

  @override
  void showRequestToEnableLocationView(String message) {
    _viewSelectorNotifier.notify(PERMISSION_DENIED_FOREVER_ERROR_VIEW);
    _errorMessage = message;
  }

  @override
  void showCountDownView(int secondsTillPunchIn) {
    var _remainingTimeToPunchInString = TimeToPunchInCalculator.timeTillPunchIn(secondsTillPunchIn.toInt());
    _countDownTimeNotifier.notify(_remainingTimeToPunchInString);

    _viewSelectorNotifier.notify(DATA_VIEW);
    _buttonTypeNotifier.notify(COUNT_DOWN_VIEW);
    _startCountDownTimer(secondsTillPunchIn);
  }

  @override
  void showPunchInButton() {
    _viewSelectorNotifier.notify(DATA_VIEW);
    _buttonTypeNotifier.notify(PUNCH_IN_BUTTON_VIEW);
  }

  @override
  void showPunchOutButton() {
    _viewSelectorNotifier.notify(DATA_VIEW);
    _buttonTypeNotifier.notify(PUNCH_OUT_BUTTON_VIEW);
  }

  @override
  void showPunchInTime(String time) {
    _punchInTimeNotifier.notify(time);
  }

  @override
  void showPunchOutTime(String time) {
    _punchOutTimeNotifier.notify(time);
  }

  @override
  void showAddress(String address) {}

  @override
  void showLocationOnMap(AttendanceLocation attendanceLocation) {
    _locationOnMapNotifier.notify(attendanceLocation);
  }

  @override
  void showBreakButton() {
    _breakButtonNotifier.notify(SHOW_BREAK_BUTTON_VIEW);
  }

  @override
  void hideBreakButton() {
    _breakButtonNotifier.notify(HIDE_BREAK_BUTTON_VIEW);
  }

  @override
  void showResumeButton() {
    _breakButtonNotifier.notify(RESUME_BUTTON_VIEW);
  }

  @override
  void showAttendanceReport(AttendanceReport attendanceReport) {
    _viewSelectorReportNotifier.notify(REPORT_DATA_VIEW);
    _attendanceReportNotifier.notify(attendanceReport);
  }

  @override
  void doRefresh() {}

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

  @override
  void showErrorMessage(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  //MARK: Util functions

  void _getCurrentTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = DateFormat('hh:mm a').format(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }


  @override
  void showBreakLoader() {

  }
}
