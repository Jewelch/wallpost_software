import 'package:wallpost/_shared/device/device_settings.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/api_exception.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_acquisition_failed_exception.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_address_failed_exception.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_permission_denied_exception.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_permission_permanently_denied_exception.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_services_disabled_exception.dart';
import 'package:wallpost/attendance_punch_in_out/services/attendance_details_provider.dart';
import 'package:wallpost/attendance_punch_in_out/services/attendance_location_validator.dart';
import 'package:wallpost/attendance_punch_in_out/services/attendance_report_provider.dart';
import 'package:wallpost/attendance_punch_in_out/services/break_end_marker.dart';
import 'package:wallpost/attendance_punch_in_out/services/break_start_marker.dart';
import 'package:wallpost/attendance_punch_in_out/services/location_provider.dart';
import 'package:wallpost/attendance_punch_in_out/services/punch_in_marker.dart';
import 'package:wallpost/attendance_punch_in_out/services/punch_out_marker.dart';
import 'package:wallpost/attendance_punch_in_out/ui/view_contracts/attendance_detailed_view.dart';
import 'package:wallpost/attendance_punch_in_out/ui/view_contracts/attendance_view.dart';

class AttendancePresenter {
  final AttendanceView basicView;
  final AttendanceDetailedView? detailedView;
  final AttendanceDetailsProvider _attendanceDetailsProvider;
  final LocationProvider _locationProvider;
  final AttendanceLocationValidator _attendanceLocationValidator;
  final PunchOutMarker _punchOutMarker;
  final PunchInMarker _punchInMarker;
  final BreakStartMarker _breakStartMarker;
  final BreakEndMarker _breakEndMarker;
  late AttendanceReportProvider _attendanceReportProvider;

  final DeviceSettings _deviceSettings;

  late AttendanceDetails _attendanceDetails;
  late AttendanceLocation? _attendanceLocation;
  var shouldReloadDataOnResume = false;

  AttendancePresenter({required this.basicView, this.detailedView})
      : _attendanceDetailsProvider = AttendanceDetailsProvider(),
        _locationProvider = LocationProvider(),
        _attendanceLocationValidator = AttendanceLocationValidator(),
        _punchInMarker = PunchInMarker(),
        _punchOutMarker = PunchOutMarker(),
        _breakStartMarker = BreakStartMarker(),
        _breakEndMarker = BreakEndMarker(),
        _attendanceReportProvider = AttendanceReportProvider(),
        _deviceSettings = DeviceSettings();

  AttendancePresenter.initWith(
    this.basicView,
    this.detailedView,
    this._attendanceDetailsProvider,
    this._locationProvider,
    this._attendanceLocationValidator,
    this._punchInMarker,
    this._punchOutMarker,
    this._breakStartMarker,
    this._breakEndMarker,
    this._attendanceReportProvider,
    this._deviceSettings,
  );

  //MARK: Function to load attendance report

  Future<void> loadAttendanceReport() async {

    try {
      detailedView?.showAttendanceReportLoader();
      var attendanceReport = await _attendanceReportProvider.getReport();
      detailedView?.showAttendanceReport(attendanceReport);
    } on WPException {
      detailedView?.showAttendanceReportErrorAndRetryView("Failed to load report.\nTap to reload");
    }
  }

  //MARK: Function to load attendance details

  Future<void> loadAttendanceDetails() async {
    if (_attendanceDetailsProvider.isLoading) return;

    try {
      basicView.showLoader();
      _attendanceDetails = await _attendanceDetailsProvider.getDetails();

      var canMarkAttendance = await _getAttendancePermission(_attendanceDetails);
      if (!canMarkAttendance) return;

      if (_attendanceDetails.isNotPunchedIn) return _loadPunchInDetails();
      else if (_attendanceDetails.isPunchedIn) return _loadPunchOutDetails(_attendanceDetails);
      else if (_attendanceDetails.isPunchedOut) return _loadPunchedOutDetails(_attendanceDetails);
    } on WPException {
      basicView.showErrorAndRetryView("Failed to load attendance details.\nTap to reload");
    }
  }

  Future<void> _loadPunchInDetails() async {
    _attendanceLocation = await getLocation();
    if (_attendanceLocation == null) return;

    basicView.showPunchInButton();
    detailedView?.hideBreakButton();
    _loadAddress(_attendanceLocation!);
  }

  Future<void> _loadPunchOutDetails(AttendanceDetails attendanceDetails) async {
    _attendanceLocation = await getLocation();
    if (_attendanceLocation == null) return;

    basicView.showPunchOutButton();
    _loadAddress(_attendanceLocation!);
    _showPunchInTime(attendanceDetails);
    _loadBreakDetails();
  }

  void _loadBreakDetails() {
    _attendanceDetails.isOnBreak ? detailedView?.showResumeButton() : detailedView?.showBreakButton();
  }

  Future<void> _loadPunchedOutDetails(AttendanceDetails attendanceDetails) async {
    _attendanceLocation = await getLocation();
    if (_attendanceLocation == null) return;

    _showPunchInTime(attendanceDetails);
    _showPunchOutTime(attendanceDetails);
    detailedView?.hideBreakButton();
  }

  //MARK: Functions to get attendance permissions

  Future<bool> _getAttendancePermission(AttendanceDetails attendanceDetails) async {
      if (!attendanceDetails.canMarkAttendancePermissionFromApp) {
        basicView.showErrorAndRetryView(
            "You are not allowed to mark attendance from the app.\nPlease contact your HR or tap to reload.");
        return false;
      }

      if (!attendanceDetails.canMarkAttendanceNow) {
        basicView.showCountDownView(attendanceDetails.secondsTillPunchIn.toInt());
        return false;
      }

      return true;
  }

  //MARK: Functions to get location

  Future<AttendanceLocation?> getLocation() async {
    try {
      var attendanceLocation = await _locationProvider.getLocation();
      detailedView?.showLocationOnMap(attendanceLocation);
      return attendanceLocation;
    } on LocationServicesDisabledException {
      basicView.showRequestToTurnOnGpsView("Location service disabled.\nTap here to go to location settings");
    } on LocationPermissionsDeniedException {
      basicView.showErrorAndRetryView("Location permission denied.\nTap here to grant permission");
    } on LocationPermissionsPermanentlyDeniedException {
      basicView.showRequestToEnableLocationView("Location permission denied.\nTap here to go to settings");
    } on LocationAcquisitionFailedException {
      basicView.showErrorAndRetryView("Getting location failed");
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

  //MARK: Functions to check location is valid to mark attendance

  Future<void> isValidatedLocation(bool isForPunchIn) async {
    var isValidateLocation = await _validateAttendanceLocation(isForPunchIn);
    if (!isValidateLocation) return;

    if (isForPunchIn)
      await markPunchIn(isLocationValid: true);
    else
      await markPunchOut(true);
  }

  Future<bool> _validateAttendanceLocation(bool isForPunchIn) async {
    try {
      var attendanceLocationValidator =
          await _attendanceLocationValidator.validateLocation(_attendanceLocation!, isForPunchIn: isForPunchIn);

      if (!attendanceLocationValidator) {
        return false;
      }

      return true;
    } on WPException catch (e) {
      basicView.showErrorMessage("Failed to validate your location", e.userReadableMessage);
      return false;
    }
  }

//MARK: Functions to mark attendance

  Future<void> markPunchIn({required bool isLocationValid}) async {
    try {
      await _punchInMarker.punchIn(_attendanceLocation!, isLocationValid: isLocationValid);
      loadAttendanceDetails();
      loadAttendanceReport();
    } on WPException catch (e) {
      //TODO: Check error code after Niyas confirms the changes
      if (e is ServerSentException && e.errorCode == 111) {
        //location is invalid - show location invalid alert
        basicView.showAlertToInvalidLocation(
            true,
            "Invalid location",
            "You are not allowed to mark attendance outside the office location. " +
                "Doing so will affect your performance. Would you still like to mark your attendance?");
      } else {
        basicView.showErrorMessage("Punch in failed", e.userReadableMessage);
      }
    }
  }

  Future<void> markPunchOut(bool isLocationValid) async {
    try {
      await _punchOutMarker.punchOut(_attendanceDetails, _attendanceLocation!, isLocationValid: isLocationValid);
      loadAttendanceDetails();
      loadAttendanceReport();
    } on WPException catch (e) {
      if (e is ServerSentException && e.errorCode == 111) {
        //TODO: Check error code after Niyas confirms the changes
        basicView.showAlertToInvalidLocation(
            true,
            "Invalid location",
            "You are not allowed to mark attendance outside the office location. " +
                "Doing so will affect your performance. Would you still like to mark your attendance?");
      } else {
        basicView.showErrorMessage("Punch out failed", e.userReadableMessage);
      }
    }
  }

  //MARK: Functions to mark break

  Future<void> startBreak() async {
    try {
      await _breakStartMarker.startBreak(_attendanceDetails, _attendanceLocation!);
      loadAttendanceDetails();
    } on WPException catch (e) {
      basicView.showErrorMessage("Start break is failed", e.userReadableMessage);
    }
  }

  Future<void> endBreak() async {
    try {
      await _breakEndMarker.endBreak(_attendanceDetails, _attendanceLocation!);
      detailedView?.showBreakButton();
    } on WPException catch (e) {
      basicView.showErrorMessage("End break is failed", e.userReadableMessage);
    }
  }

  //MARK: Functions to go to settings

  void goToLocationSettings() {
    shouldReloadDataOnResume = true;
    _deviceSettings.goToLocationSettings();
  }

  void goToAppSettings() {
    shouldReloadDataOnResume = true;
    _deviceSettings.goToAppSettings();
  }

  bool shouldReloadDataWhenAppIsResumed() {
    var reloadData = shouldReloadDataOnResume;
    shouldReloadDataOnResume = false;
    return reloadData;
  }
}
