import 'package:flutter/material.dart';
import 'package:notifiable/item_notifiable.dart';
import 'package:wallpost/_common_widgets/text_styles/text_styles.dart';
import 'package:wallpost/_shared/constants/app_colors.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_report.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/presenters/attendance_report_presenter.dart';

import '../../../../../_common_widgets/shimmer/shimmer_effect.dart';
import '../../view_contracts/attendance_report_view.dart';

class AttendanceReportWidget extends StatefulWidget {
  @override
  State<AttendanceReportWidget> createState() => _AttendanceReportWidgetState();
}

class _AttendanceReportWidgetState extends State<AttendanceReportWidget> implements AttendanceReportView {
  var _viewSelectorReportNotifier = ItemNotifier<int>(defaultValue: 0);
  var _attendanceReportNotifier = ItemNotifier<AttendanceReport?>(defaultValue: null);
  late final AttendanceReportPresenter reportPresenter;
  var _errorMessage = "";

  static const REPORT_LOADER_VIEW = 1;
  static const REPORT_ERROR_VIEW = 2;
  static const REPORT_DATA_VIEW = 3;

  @override
  void initState() {
    reportPresenter = AttendanceReportPresenter(reportsView: this);
    reportPresenter.loadAttendanceReport();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: ItemNotifiable<int?>(
        notifier: _viewSelectorReportNotifier,
        builder: (context, viewType) {
          if (viewType == REPORT_LOADER_VIEW) return AttendanceReportsLoader();

          if (viewType == REPORT_ERROR_VIEW) return _errorAndRetryView();

          if (viewType == REPORT_DATA_VIEW) return _dataView();

          return Container();
        },
      ),
    );
  }

  //MARK: Functions to build the error and retry view

  Widget _errorAndRetryView() {
    return _errorButton(
      title: _errorMessage,
      onPressed: () {
        reportPresenter.loadAttendanceReport();
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
    return ItemNotifiable<AttendanceReport?>(
        notifier: _attendanceReportNotifier,
        builder: (context, attendanceReport) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _attendanceReport("Late Punch In", attendanceReport!.late, AppColors.yellow),
              _attendanceReport("Early Punch Out", attendanceReport.earlyLeave, Colors.black),
              _attendanceReport("Absences", attendanceReport.absents, AppColors.red)
            ],
          );
        });
  }

  Widget _attendanceReport(String title, num noOfDays, Color textColor) {
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
  void showLoader() {
    _viewSelectorReportNotifier.notify(REPORT_LOADER_VIEW);
  }

  @override
  void showErrorAndRetryView(String message) {
    _viewSelectorReportNotifier.notify(REPORT_ERROR_VIEW);
    _errorMessage = message;
  }

  @override
  void showAttendanceReport(AttendanceReport attendanceReport) {
    _viewSelectorReportNotifier.notify(REPORT_DATA_VIEW);
    _attendanceReportNotifier.notify(attendanceReport);
  }
}

class AttendanceReportsLoader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ShimmerEffect(
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _emptyContainer(height: 12, width: 80, cornerRadius: 12),
                  _emptyContainer(height: 12, width: 80, cornerRadius: 12),
                  _emptyContainer(height: 12, width: 80, cornerRadius: 12),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _emptyContainer(height: 8, width: 80, cornerRadius: 12),
                  _emptyContainer(height: 8, width: 80, cornerRadius: 12),
                  _emptyContainer(height: 8, width: 80, cornerRadius: 12),
                ],
              ),
            ],
          )
        ],
      ),
    );
  }

  _emptyContainer({required double height, double width = double.infinity, required double cornerRadius}) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
    );
  }
}
