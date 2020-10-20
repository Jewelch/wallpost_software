import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/my_portal/ui/attendance/location_address_view.dart';
import 'package:wallpost/my_portal/ui/attendance/utils/location_provider_util.dart';

import 'attendance_button_view.dart';
import 'disable_attendance_button_with_timer.dart';

class AttendanceBaseView extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _AttendanceBaseViewState();
}

class _AttendanceBaseViewState extends State<AttendanceBaseView> {
  bool showError = false;
  bool attendance = true;

  @override
  Widget build(BuildContext context) {
    if (attendance) {
      return _buildAttendanceView();
    } else {
      return showError ? _buildErrorAndRetryView() : _buildProgressIndicator();
    }
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
                    Text('---'),
                  ],
                ),
                Spacer(),
                AttendanceButtonView(name: 'Punch\nIn', color: Colors.green, onPressed: () => {}),
                // AttendanceButtonView(name: 'Punch\nOut',color: Colors.red,onPressed: ()=>{}),
                //AttendanceButtonView(name: 'Loading',color: Colors.grey,onPressed: null,),
                //DisableAttendanceButtonWithTimer(secondsToPunchIn: 5000, onTimerFinished: () => {setState(() {})},),
                Spacer(),
                Column(
                  children: [
                    Text('Punch Out'),
                    Text('---'),
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
  Widget _buildAttendanceSummaryTitleView() {
    var now = new DateTime.now();
    var formatter = new DateFormat('MMM yyyy');
    String date =formatter.format(now);
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
              Text('Late Punch In',
                  style: TextStyle(color: AppColors.attendanceLabelColor)),
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
              Text('Early Punch out',
                  style: TextStyle(color: AppColors.attendanceLabelColor)),
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
                setState(() {});
                //_getEmployeePerformance();
              },
            ),
          ],
        ),
      ),
    );
  }


}
