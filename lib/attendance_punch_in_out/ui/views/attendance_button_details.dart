import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/attendance_punch_in_out/constants/app_bar_with_back_button.dart';
import 'package:wallpost/_common_widgets/screen_presenter/screen_presenter.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance_punch_in_out/constants/attendance_colors.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_report.dart';
import 'package:wallpost/attendance_punch_in_out/services/time_to_punch_in_calculator.dart';
import 'package:wallpost/attendance_punch_in_out/ui/presenters/attendance_presenter.dart';
import 'package:wallpost/attendance_punch_in_out/ui/view_contracts/attendance_detailed_view.dart';
import 'package:wallpost/attendance_punch_in_out/ui/view_contracts/attendance_view.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';
import 'package:wallpost/company_list/views/companies_list_screen.dart';
import 'package:wallpost/dashboard/ui/my_portal_screen.dart';

class AttendanceButtonDetailsScreen extends StatefulWidget {
  const AttendanceButtonDetailsScreen({Key? key}) : super(key: key);

  @override
  _AttendanceButtonDetailsScreenState createState() =>
      _AttendanceButtonDetailsScreenState();
}

class _AttendanceButtonDetailsScreenState
    extends State<AttendanceButtonDetailsScreen>
    with WidgetsBindingObserver
    implements AttendanceView, AttendanceDetailedView {
  var _viewSelectorNotifier = ItemNotifier<int>(defaultValue: 0);
  var _buttonTypeNotifier = ItemNotifier<int>(defaultValue: PUNCH_IN_BUTTON_VIEW);
  var _breakButtonNotifier = ItemNotifier<int>(defaultValue: SHOW_BREAK_BUTTON_VIEW);
  var _attendanceReportNotifier = ItemNotifier<AttendanceReport?>(defaultValue: null);
  var _locationOnMapNotifier = ItemNotifier<AttendanceLocation?>(defaultValue: null);
  final ItemNotifier<String> _countDownNotifier = ItemNotifier(defaultValue: "");

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

  @override
  void initState() {
    presenter = AttendancePresenter(basicView: this, detailedView: this);
    presenter.loadAttendanceDetails();
    // presenter.loadAttendanceReport();

    _currentTimer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getCurrentTime());
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
    if (state == AppLifecycleState.resumed &&
        presenter.shouldReloadDataWhenAppIsResumed()) {
      presenter.loadAttendanceDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        leadingButton: BackButton(color: Colors.black),
        onLeadingButtonPressed: () =>
            ScreenPresenter.presentAndRemoveAllPreviousScreens(
                MyPortalScreen(), context),
        textButton1: TextButton(
            child: Row(
              children: [
                Text(
                  '${SelectedCompanyProvider().getSelectedCompanyForCurrentUser().name}',
                  style: TextStyles.screenTitleTextStyle
                      .copyWith(color: AppColors.defaultColor),
                ),
                SizedBox(width: 2),
                Icon(Icons.keyboard_arrow_down_outlined, size: 28),
              ],
            ),
            onPressed: () => ScreenPresenter.presentAndRemoveAllPreviousScreens(
                CompanyListScreen(), context)),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
            child: ItemNotifiable<int>(
          notifier: _viewSelectorNotifier,
          builder: (context, viewType) {
            if (viewType == LOADER_VIEW) return _buildLoader();

            if (viewType == ERROR_VIEW) return _errorAndRetryView();

            if (viewType == GPS_DISABLED_VIEW) return _enableGpsView();

            if (viewType == PERMISSION_DENIED_FOREVER_ERROR_VIEW)
              return _grantLocationPermissionView();

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
      height: 150,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: AttendanceColors.disabledButtonColor,
          valueColor:
              AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
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

  Widget _errorButton(
      {required String title, required VoidCallback onPressed}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      height: 150,
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
                Container(height: 70, color: Colors.transparent),
              ],
            ),
            Positioned(
              bottom: 0,
              child: Container(
                  width: 140, height: 140, child: _buildAttendanceButtonView()),
            ),
          ],
        ),
        SizedBox(height: 16),
        Container(width: 140, child: _buildBreakButtonView()),
        SizedBox(height: 8),
        Container(
            margin: EdgeInsets.all(20), child: _buildAttendanceReportView())
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
              target: LatLng(
                  location!.latitude.toDouble(), location.longitude.toDouble()),
              zoom: 14.0,
            ),
            markers: Set<Marker>()
              ..add(Marker(
                markerId: MarkerId(''),
                position: LatLng(location.latitude.toDouble(),
                    location.longitude.toDouble()),
              )),
          )),
    );
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
      notifier: _countDownNotifier,
      builder: (context, timeLeft) => Container(
        color: AttendanceColors.disabledButtonColor,
        child: Center(
          child: Text(
            "$timeLeft to punch in",
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
        _countDownNotifier.notify(_remainingTimeToPunchInString);
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
      onPressed: () => presenter.isValidatedLocation(true),
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
      buttonTwoOnPressed: () {
        presenter.isValidatedLocation(false);
      },
    );
  }

  Widget _actionButton(
      {required String title,
      required String time,
      required Color buttonColor,
      required VoidCallback onPressed}) {
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
    return MaterialButton(
      elevation: 0,
      highlightElevation: 0,
      color: buttonColor,
      child: Row(
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
    );
  }

  //MARK: Functions to build attendance report

  Widget _buildAttendanceReportView() {
    return ItemNotifiable<AttendanceReport?>(
        notifier: _attendanceReportNotifier,
        builder: (context, attendanceReport) {
          if ((attendanceReport != null)) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _attendanceReportDetails("Late Punch In", attendanceReport.late,
                    AttendanceColors.attendanceReportLatePunchInDayTextColor),
                _attendanceReportDetails("Early Punch Out",
                    attendanceReport.earlyLeave, Colors.black),
                _attendanceReportDetails("Absences", attendanceReport.absents,
                    AttendanceColors.attendanceReportAbsenceDayTextColor)
              ],
            );
          } else
            return Container();
        });
  }

  Widget _attendanceReportDetails(String title, num noOfDays, Color textColor) {
    return Column(
      children: [
        noOfDays == 1
            ? Text("$noOfDays Day",
                style: TextStyles.titleTextStyle.copyWith(color: textColor))
            : Text("$noOfDays Days",
                style: TextStyles.titleTextStyle.copyWith(color: textColor)),
        SizedBox(height: 8),
        Text(title,
            style: TextStyles.titleTextStyle.copyWith(color: Colors.black))
      ],
    );
  }

  //MARK: View functions

  @override
  void showLoader() {
    _viewSelectorNotifier.notify(LOADER_VIEW);
  }

  @override
  void showErrorAndRetryView( String message) {
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
    _countDownNotifier.notify(_remainingTimeToPunchInString);

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
  void showPunchInTime(String time) {}

  @override
  void showPunchOutTime(String time) {}

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
    _attendanceReportNotifier.notify(attendanceReport);
  }

  @override
  void doRefresh() {
    presenter.loadAttendanceDetails();
    presenter.loadAttendanceReport();
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
          presenter.markPunchIn(isLocationValid: false);
        } else {
          presenter.markPunchOut(false);
        }
      },
    );
  }

  @override
  void showErrorMessage(String title,String message) {
    // TODO: implement showErrorMessage
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
