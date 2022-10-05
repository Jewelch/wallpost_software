import 'package:wallpost/_shared/device/device_settings.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/api_exception.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/exception/location_acquisition_failed_exception.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/exception/location_address_failed_exception.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/exception/location_permission_denied_exception.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/exception/location_permission_permanently_denied_exception.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/exception/location_services_disabled_exception.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/attendance_details_provider.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/break_end_marker.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/break_start_marker.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/location_provider.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/punch_in_marker.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/services/punch_out_marker.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/view_contracts/attendance_detailed_view.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/view_contracts/attendance_view.dart';

class AttendancePresenter {
  final AttendanceView basicView;
  final AttendanceDetailedView? detailedView;
  final AttendanceDetailsProvider _attendanceDetailsProvider;
  final LocationProvider _locationProvider;
  final PunchOutMarker _punchOutMarker;
  final PunchInMarker _punchInMarker;
  final BreakStartMarker _breakStartMarker;
  final BreakEndMarker _breakEndMarker;
  final DeviceSettings _deviceSettings;

  late AttendanceDetails _attendanceDetails;
  late AttendanceLocation? _attendanceLocation;
  var _shouldReloadDataOnResume = false;

  AttendancePresenter({required this.basicView, this.detailedView})
      : _attendanceDetailsProvider = AttendanceDetailsProvider(),
        _locationProvider = LocationProvider(),
        _punchInMarker = PunchInMarker(),
        _punchOutMarker = PunchOutMarker(),
        _breakStartMarker = BreakStartMarker(),
        _breakEndMarker = BreakEndMarker(),
        _deviceSettings = DeviceSettings();

  AttendancePresenter.initWith(
    this.basicView,
    this.detailedView,
    this._attendanceDetailsProvider,
    this._locationProvider,
    this._punchInMarker,
    this._punchOutMarker,
    this._breakStartMarker,
    this._breakEndMarker,
    this._deviceSettings,
  );

  //MARK: Function to load attendance details

  Future<void> loadAttendanceDetails() async {
    if (_attendanceDetailsProvider.isLoading) return;

    try {
      basicView.showLoader();
      _attendanceDetails = await _attendanceDetailsProvider.getDetails();

      if (!_attendanceDetails.canMarkAttendanceFromApp) {
        _showCannotPunchInFromAppMessage();
        return;
      }

      if (!_attendanceDetails.canMarkAttendanceNow) _showTimeTillPunchIn();

      await _loadAttendanceViews();
    } on WPException {
      basicView.showErrorAndRetryView("Failed to load attendance details.\nTap here to reload.");
    }
  }

  void _showCannotPunchInFromAppMessage() async {
    basicView.showErrorAndRetryView(
        "You are not allowed to mark attendance from the app. Please contact HR or tap here to reload.");
  }

  void _showTimeTillPunchIn() async {
    basicView.showCountDownView(_attendanceDetails.secondsTillPunchIn.toInt());
  }

  Future<void> _loadAttendanceViews() async {
    if (_attendanceDetails.isNotPunchedIn) {
      await _loadPunchInDetails();
    } else if (_attendanceDetails.isPunchedIn) {
      await _loadPunchOutDetails(_attendanceDetails);
    } else if (_attendanceDetails.isPunchedOut) {
      await _loadPunchedOutDetails(_attendanceDetails);
    }
  }

  Future<void> _loadPunchInDetails() async {
    _attendanceLocation = await getLocation();
    if (_attendanceLocation == null) return;

    basicView.showPunchInButton();
    detailedView?.hideBreakButton();
    await _loadAddress(_attendanceLocation!);
  }

  Future<void> _loadPunchOutDetails(AttendanceDetails attendanceDetails) async {
    _attendanceLocation = await getLocation();
    if (_attendanceLocation == null) return;

    basicView.showPunchOutButton();
    await _loadAddress(_attendanceLocation!);
    _showPunchInTime(attendanceDetails);
    _attendanceDetails.isOnBreak ? detailedView?.showResumeButton() : detailedView?.showBreakButton();
  }

  Future<void> _loadPunchedOutDetails(AttendanceDetails attendanceDetails) async {
    _attendanceLocation = await getLocation();
    if (_attendanceLocation == null) return;

    _showPunchInTime(attendanceDetails);
    _showPunchOutTime(attendanceDetails);
    detailedView?.hideBreakButton();
  }

  //MARK: Functions to get location

  Future<AttendanceLocation?> getLocation() async {
    try {
      var attendanceLocation = await _locationProvider.getLocation();
      detailedView?.showLocationOnMap(attendanceLocation);
      return attendanceLocation;
    } on LocationServicesDisabledException {
      basicView.showRequestToTurnOnGpsView("Location service disabled.\nTap here to go to location settings.");
    } on LocationPermissionsDeniedException {
      basicView.showErrorAndRetryView("Location permission denied.\nTap here to grant permission.");
    } on LocationPermissionsPermanentlyDeniedException {
      basicView.showRequestToEnableLocationView("Location permission denied.\nTap here to go to settings.");
    } on LocationAcquisitionFailedException {
      basicView.showErrorAndRetryView("Failed to get location.\nTap here to reload.");
    }
    return null;
  }

  //MARK: Functions to load address

  Future<void> _loadAddress(AttendanceLocation location) async {
    var address = "";

    try {
      address = await _locationProvider.getLocationAddress(location);
    } on LocationReverseGeocodingException {
      address = "${location.latitude}, ${location.longitude}";
    }
    basicView.showAddress(address);
  }

  //MARK: Functions to show punched in and out time

  void _showPunchInTime(AttendanceDetails attendanceDetails) {
    detailedView?.showPunchInTime(attendanceDetails.punchInTimeString);
  }

  void _showPunchOutTime(AttendanceDetails attendanceDetails) {
    detailedView?.showPunchOutTime(attendanceDetails.punchOutTimeString);
  }

  //MARK: Functions to mark attendance

  Future<void> markPunchIn({required bool isLocationValid}) async {
    if (_punchInMarker.isLoading) return;

    try {
      basicView.showAttendanceButtonLoader();
      await _punchInMarker.punchIn(_attendanceLocation!, isLocationValid: isLocationValid);
      _attendanceDetails = await _attendanceDetailsProvider.getDetails();
      basicView.showPunchOutButton();
      _showPunchInTime(_attendanceDetails);
      detailedView?.showBreakButton();
    } on WPException catch (e) {
      basicView.showPunchInButton();
      if (e is ServerSentException && e.userReadableMessage.contains("outside the office location")) {
        basicView.showAlertToMarkAttendanceWithInvalidLocation(true, "Invalid location", e.userReadableMessage);
      } else {
        basicView.showErrorMessage("Punch in failed", e.userReadableMessage);
      }
    }
  }

  Future<void> markPunchOut({required bool isLocationValid}) async {
    if (_punchOutMarker.isLoading) return;

    try {
      basicView.showAttendanceButtonLoader();
      await _punchOutMarker.punchOut(_attendanceDetails, _attendanceLocation!, isLocationValid: isLocationValid);
      _attendanceDetails = await _attendanceDetailsProvider.getDetails();
      _showTimeTillPunchIn();
      _showPunchOutTime(_attendanceDetails);
      detailedView?.hideBreakButton();
    } on WPException catch (e) {
      basicView.showPunchOutButton();
      if (e is ServerSentException && e.userReadableMessage.contains("outside the office location")) {
        basicView.showAlertToMarkAttendanceWithInvalidLocation(false, "Invalid location", e.userReadableMessage);
      } else {
        basicView.showErrorMessage("Punch out failed", e.userReadableMessage);
      }
    }
  }

  //MARK: Functions to mark break

  Future<void> startBreak() async {
    if (_breakStartMarker.isLoading) return;

    try {
      detailedView?.showBreakLoader();
      await _breakStartMarker.startBreak(_attendanceDetails, _attendanceLocation!);
      _attendanceDetails = await _attendanceDetailsProvider.getDetails();
      detailedView?.hideLoader();
      detailedView?.showResumeButton();
    } on WPException catch (e) {
      detailedView?.hideLoader();
      basicView.showErrorMessage("Failed to start break", e.userReadableMessage);
    }
  }

  Future<void> endBreak() async {
    if (_breakEndMarker.isLoading) return;

    try {
      detailedView?.showBreakLoader();
      await _breakEndMarker.endBreak(_attendanceDetails, _attendanceLocation!);
      detailedView?.hideLoader();
      detailedView?.showBreakButton();
    } on WPException catch (e) {
      detailedView?.hideLoader();
      basicView.showErrorMessage("Failed to end break", e.userReadableMessage);
    }
  }

  //MARK: Functions to go to settings

  void goToLocationSettings() {
    _shouldReloadDataOnResume = true;
    _deviceSettings.goToLocationSettings();
  }

  void goToAppSettings() {
    _shouldReloadDataOnResume = true;
    _deviceSettings.goToAppSettings();
  }

  bool shouldReloadDataWhenAppIsResumed() {
    var reloadData = _shouldReloadDataOnResume;
    _shouldReloadDataOnResume = false;
    return reloadData;
  }
}
