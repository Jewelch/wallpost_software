import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_common_widgets/alert/alert.dart';
import 'package:wallpost/_common_widgets/loader/loader.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance/entities/attendance_details.dart';
import 'package:wallpost/attendance/entities/attendance_location.dart';
import 'package:wallpost/attendance/entities/punch_in_from_app_permission.dart';
import 'package:wallpost/attendance/entities/punch_in_now_permission.dart';
import 'package:wallpost/attendance/services/attendance_details_provider.dart';
import 'package:wallpost/attendance/services/location_provider.dart';
import 'package:wallpost/attendance/services/punch_in_from_app_permission_provider.dart';
import 'package:wallpost/attendance/services/punch_in_marker.dart';
import 'package:wallpost/attendance/services/punch_in_now_permission_provider.dart';
import 'package:wallpost/attendance/services/punch_out_marker.dart';
import 'package:wallpost/attendance/ui/location_address_view.dart';

import 'attendance_button_view.dart';
import 'disable_attendance_button_with_timer.dart';

class AttendanceBaseView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AttendanceBaseViewState();
}

class _AttendanceBaseViewState extends State<AttendanceBaseView> {
  AttendanceDetailsProvider _attendanceDetailsProvider = AttendanceDetailsProvider();
  PunchInFromAppPermissionProvider _punchInFromAppPermissionProvider = PunchInFromAppPermissionProvider();
  PunchInNowPermissionProvider _punchInNowPermissionProvider = PunchInNowPermissionProvider();
  PunchInFromAppPermission _punchInFromAppPermission;
  PunchInNowPermission _punchInNowPermission;
  AttendanceDetails attendanceDetail;
  Loader _loader;

  @override
  void initState() {
    super.initState();
    _loader = Loader(context);
    _initAPICall();
  }

  @override
  Widget build(BuildContext context) {
    if (_attendanceDetailsProvider.isLoading ||
        _punchInFromAppPermissionProvider.isLoading ||
        _punchInNowPermissionProvider.isLoading) return Container(child: _buildProgressIndicator());
    if (attendanceDetail == null)
      return _buildErrorAndRetryView();
    else
      return _buildAttendanceView();
  }

  Widget _buildAttendanceView() {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 25,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    Text('Punch In'),
                    Text(attendanceDetail.punchInTimeString.isEmpty ? '...' : attendanceDetail.punchInTimeString),
                  ],
                ),
                Spacer(),
                _getAttendanceButton(),
                Spacer(),
                Column(
                  children: [
                    Text('Punch Out'),
                    Text(attendanceDetail.punchOutTimeString.isEmpty ? '...' : attendanceDetail.punchOutTimeString),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(
            height: 20,
          ),
          LocationAddressView(),
          SizedBox(
            height: 20,
          ),
          _buildAttendanceSummaryTitleView(),
          SizedBox(
            height: 20,
          ),
          _buildAttendanceSummaryView(),
        ],
      ),
    );
  }

  Widget _getAttendanceButton() {
    //

    if (!_punchInNowPermission.canPunchInNow)
      return DisableAttendanceButtonWithTimer(
        secondsToPunchIn: _punchInNowPermission.secondsTillPunchIn,
        onTimerFinished: () => {setState(() {})},
      );
    /*  return AttendanceButtonView(
        name: 'Loading', color: Colors.grey, onPressed: null,);*/
    if (attendanceDetail.isPunchedIn)
      return AttendanceButtonView(name: 'Punch\nOut', color: Colors.red, onPressed: () => {_showPunchPotConfirmationAlert()});
    else
      return AttendanceButtonView(name: 'Punch\nIn', color: Colors.green, onPressed: () => {/*_doPunchIn()*/});
  }

  Widget _buildAttendanceSummaryTitleView() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MMM yyyy');
    String date = formatter.format(now);
    return Text('$date Summary');
  }

  _buildAttendanceSummaryView() {
    return Row(
      children: [
        Expanded(
          child: Column(
            children: [
              Text('23 Days'),
              SizedBox(
                height: 2,
              ),
              Text('Late Punch In', style: TextStyle(color: AppColors.attendanceLabelColor)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text('3 Days'),
              SizedBox(
                height: 2,
              ),
              Text('Early Punch out', style: TextStyle(color: AppColors.attendanceLabelColor)),
            ],
          ),
        ),
        Expanded(
          child: Column(
            children: [
              Text('0 Days'),
              SizedBox(
                height: 2,
              ),
              Text(
                'Absence',
                style: TextStyle(color: AppColors.attendanceLabelColor),
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      height: 150,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(width: 30, height: 30, child: CircularProgressIndicator()),
        ],
      ),
    );
  }

  Widget _buildErrorAndRetryView() {
    return Container(
      height: 150,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FlatButton(
              child: Text(
                'Failed to load attendance\nTap Here To Retry',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14),
              ),
              onPressed: () {
                setState(() {
                  _getAttendanceDetail();
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  void _initAPICall() async {
    _getPunchInFromAppPermission();
    _getAttendanceDetail();
    _getPunchInNowPermission();
  }

  void _getAttendanceDetail() async {
    try {
      attendanceDetail = await _attendanceDetailsProvider.getDetails();
      setState(() {});
    } on WPException catch (error) {
      Alert.showSimpleAlert(
        context,
        title: 'Failed To Load Attendance Detail',
        message: error.userReadableMessage,
        buttonTitle: 'Okay',
      );
      setState(() {});
    }
  }

  void _getPunchInFromAppPermission() async {
    try {
      _punchInFromAppPermission = await _punchInFromAppPermissionProvider.canPunchInFromApp();

      if (!_punchInFromAppPermission.isAllowed) setState(() {});
    } on WPException catch (error) {
      Alert.showSimpleAlert(
        context,
        title: 'Failed To Load Detail',
        message: error.userReadableMessage,
        buttonTitle: 'Okay',
      );
      setState(() {});
    }
  }

  void _getPunchInNowPermission() async {
    try {
      _punchInNowPermission = await _punchInNowPermissionProvider.canPunchInNow();

      setState(() {});
    } on WPException catch (error) {
      Alert.showSimpleAlert(
        context,
        title: 'Failed To Load Detail',
        message: error.userReadableMessage,
        buttonTitle: 'Okay',
      );
      setState(() {});
    }
  }

  void _doPunchIn() async {
    await _loader.show('Punch In ..');

    AttendanceLocation _attendanceLocation = await _getLocation();
    try {
      var _ = await PunchInMarker().punchIn(_attendanceLocation, isLocationValid: true);
      await _loader.hide();

      setState(() {});
    } on WPException catch (error) {
      await _loader.hide();
      Alert.showSimpleAlert(
        context,
        title: 'Failed To Punch In',
        message: error.userReadableMessage,
        buttonTitle: 'Okay',
      );
      setState(() {});
    }
  }
  _showPunchPotConfirmationAlert() {
    Alert.showSimpleAlertWithButtons(
      context,
      title: 'Punch Out',
      message: 'Are you sure you want to punch out?',
      buttonOneTitle: 'No',
      buttonTwoTitle: 'Yes',
      buttonTwoOnPressed: ()=>{
        print('onPressed------------------')
        //_doPunchOut
      }
    );
  }

  void _doPunchOut() async {
    await _loader.show('Punch Out..');

    AttendanceLocation _attendanceLocation = await _getLocation();
    try {
      var _ = await PunchOutMarker().punchOut(attendanceDetail, _attendanceLocation, isLocationValid: false);
      await _loader.hide();

      setState(() {});
    } on WPException catch (error) {
      await _loader.hide();
      Alert.showSimpleAlert(
        context,
        title: 'Failed To Punch Out',
        message: error.userReadableMessage,
        buttonTitle: 'Okay',
      );
      setState(() {});
    }
  }

  Future<AttendanceLocation> _getLocation() async {
    Position position = await LocationProvider().getLocation();
    return AttendanceLocation(position.latitude, position.longitude);
  }


}
