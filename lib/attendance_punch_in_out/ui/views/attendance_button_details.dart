import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
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
  final ItemNotifier<int> _buttonTypeNotifier =
      ItemNotifier(defaultValue: PUNCH_IN_BUTTON_VIEW);
  final ItemNotifier<int> _breakButtonNotifier =
      ItemNotifier(defaultValue: SHOW_BREAK_BUTTON_VIEW);
  var _attendanceReportNotifier =
      ItemNotifier<AttendanceReport?>(defaultValue: null);
  late final AttendancePresenter presenter;
  GoogleMapController? _controller;
  Set<Marker> _markers = {};
  late BitmapDescriptor customIcon;
  late String _timeString;
  late Timer _currentTimer;
  static const PUNCH_IN_BUTTON_VIEW = 1;
  static const PUNCH_OUT_BUTTON_VIEW = 2;
  static const LOADER_VIEW = 3;
  static const SHOW_BREAK_BUTTON_VIEW = 4;
  static const HIDE_BREAK_BUTTON_VIEW = 5;
  static const RESUME_BUTTON_VIEW = 6;

  @override
  void initState() {
    presenter = AttendancePresenter(basicView: this, detailedView: this);
    presenter.loadAttendanceDetails();
    // presenter.loadAttendanceReport();
    _timeString = _formatDateTime(DateTime.now());
    _currentTimer =
        Timer.periodic(Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
    WidgetsBinding.instance!.addObserver(this);
  }

  @override
  void dispose() {
    _currentTimer.cancel();
    WidgetsBinding.instance!.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    if (state == AppLifecycleState.resumed) {
      _controller!.setMapStyle("[]");
      presenter.loadAttendanceDetails();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWithBackButton(
        leadingButton: BackButton(
            color: Colors.black
        ),
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
            child: Column(
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
                  child: _buildAttendanceButtonView(),
                  bottom: 0,
                ),
              ],
            ),
            SizedBox(
              height: 16,
            ),
            _buildBreakButtonView(),
            SizedBox(
              height: 8,
            ),
            _buildAttendanceReport()
          ],
        )),
      ),
    );
  }

  Widget _mapView() {
    return ClipRRect(
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
            target: LatLng(0, 0),
            zoom: 14.0,
          ),
          onMapCreated: (GoogleMapController controller) {
            _controller = controller;
          },
          markers: _markers,
        ));
  }

  Widget _buildAttendanceButtonView() {
    return Container(
      width: 140,
      height: 140,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(100),
        child: ItemNotifiable<int>(
          notifier: _buttonTypeNotifier,
          builder: (context, value) {
            if (value == LOADER_VIEW) return _buildLoader();

            if (value == PUNCH_IN_BUTTON_VIEW) return _buildPunchInButton();

            if (value == PUNCH_OUT_BUTTON_VIEW) return _buildPunchOutButton();

            return Container();
          },
        ),
      ),
    );
  }

  Widget _buildLoader() {
    return Container(
      color: AttendanceColors.disabledButtonColor,
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          backgroundColor: Colors.transparent,
          valueColor:
              AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.7)),
        ),
      ),
    );
  }

  Widget _buildPunchInButton() {
    return _actionButton(
      title: "Punch In",
      time: _timeString,
      buttonColor: AttendanceColors.punchInButtonColor,
      onPressed: () => presenter.validateLocation(true),
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
    return Container(
      width: 140,
      child: ClipRRect(
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
      ),
    );
  }

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

  Widget _buildAttendanceReport() {
    return Container(
        child: ItemNotifiable<AttendanceReport?>(
            notifier: _attendanceReportNotifier,
            builder: (context, attendanceReport) {
              if ((attendanceReport != null)) {
                return Container(
                  margin: EdgeInsets.all(20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          if (attendanceReport.late == 1)
                            Text("${attendanceReport.late} Day",
                                style: TextStyle(
                                    color: AttendanceColors
                                        .attendanceReportLatePunchInDayTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold)),
                          if (attendanceReport.late == 0 ||
                              attendanceReport.late > 1)
                            Text("${attendanceReport.late} Days",
                                style: TextStyle(
                                    color: AttendanceColors
                                        .attendanceReportLatePunchInDayTextColor,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 16,
                          ),
                          Text("Late Punch In",
                              style: TextStyle(color: Colors.black))
                        ],
                      ),
                      Column(
                        children: [
                          if (attendanceReport.earlyLeave == 1)
                            Text(
                              "${attendanceReport.earlyLeave} Day",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          if (attendanceReport.earlyLeave == 0 ||
                              attendanceReport.earlyLeave > 1)
                            Text(
                              "${attendanceReport.earlyLeave} Days",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          SizedBox(
                            height: 16,
                          ),
                          Text("Early Punch Out",
                              style: TextStyle(color: Colors.black))
                        ],
                      ),
                      Column(
                        children: [
                          if (attendanceReport.absents == 1)
                            Text(
                              "${attendanceReport.absents} Day",
                              style: TextStyle(
                                  color: AttendanceColors
                                      .attendanceReportAbsenceDayTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          if (attendanceReport.absents == 0 ||
                              attendanceReport.absents > 1)
                            Text(
                              "${attendanceReport.absents} Days",
                              style: TextStyle(
                                  color: AttendanceColors
                                      .attendanceReportAbsenceDayTextColor,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ),
                          SizedBox(
                            height: 16,
                          ),
                          Text("Absences",
                              style: TextStyle(color: Colors.black))
                        ],
                      )
                    ],
                  ),
                );
              } else
                return Container();
            }));
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

  void _doPunchOut() {
    Alert.showSimpleAlertWithButtons(
      context: context,
      title: "Punch Out",
      message: " Do you really want to punch out? ",
      buttonOneTitle: "Cancel",
      buttonTwoTitle: "Yes",
      buttonTwoOnPressed: () {
        presenter.validateLocation(false);
      },
    );
  }

  //MARK: View functions

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
  void showLoader() {
    _buttonTypeNotifier.notify(LOADER_VIEW);
  }

  @override
  void showPunchInButton() {
    _buttonTypeNotifier.notify(PUNCH_IN_BUTTON_VIEW);
  }

  @override
  void showPunchOutButton() {
    _buttonTypeNotifier.notify(PUNCH_OUT_BUTTON_VIEW);
  }

  @override
  void showPunchInTime(String time) {}

  @override
  void showAddress(String address) {}

  @override
  void showPunchOutTime(String time) {}

  @override
  void showCountDownView(int secondsTillPunchIn) {
    ScreenPresenter.presentAndRemoveAllPreviousScreens(
        MyPortalScreen(), context);
  }

  @override
  void showTimeTillPunchIn(num seconds) {}

  @override
  void showLocationAddress(String address) {}

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
  void showRequestToTurnOnGpsView(String message) {
    // Alert.showSimpleAlert(
    //     context: context,
    //     title: title,
    //     message: message,
    //     onPressed: () {
    //       Geolocator.openLocationSettings();
    //     });
  }

  @override
  void showRequestToEnableLocationView(String message) {
    if (false) {
      // Alert.showSimpleAlert(
      //     context: context,
      //     title: title,
      //     message: message,
      //     onPressed: () {
      //       presenter.loadAttendanceDetails();
      //     });
    } else {
      Alert.showSimpleAlert(
          context: context,
          title: "title",
          message: message,
          onPressed: () {
            Geolocator.openAppSettings();
          });
    }
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

  @override
  void showError(String title, String message) {
    Alert.showSimpleAlert(context: context, title: title, message: message);
  }

  @override
  void showErrorAndRetryView(String title, String message) {
    Alert.showSimpleAlert(
        context: context,
        title: title,
        message: message,
        onPressed: () {
          presenter.loadAttendanceDetails();
        });
  }

  @override
  void showLocationOnMap(AttendanceLocation attendanceLocation) {
    _controller
        ?.animateCamera(CameraUpdate.newCameraPosition(new CameraPosition(
      target: LatLng(attendanceLocation.latitude.toDouble(),
          attendanceLocation.longitude.toDouble()),
      zoom: 14.0,
    )));
    _markers.add(Marker(
        markerId: MarkerId(''),
        position: LatLng(attendanceLocation.latitude.toDouble(),
            attendanceLocation.longitude.toDouble())));
  }
}
