import 'package:wallpost/_shared/exceptions/wp_exception.dart';
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
import 'package:wallpost/attendance_punch_in_out/ui/device_settings.dart';
import 'package:wallpost/attendance_punch_in_out/ui/view_contracts/attendance_view.dart';

import '../../services/attendance_permissions_provider.dart';

//TODO: Handle stale locations

class AttendancePresenter {
  final AttendanceView _view;
  final AttendanceDetailsProvider _attendanceDetailsProvider;
  final LocationProvider _locationProvider;
  final AttendancePermissionsProvider _attendancePermissionsProvider;
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

  AttendancePresenter(this._view)
      : _attendanceDetailsProvider = AttendanceDetailsProvider(),
        _locationProvider = LocationProvider(),
        _attendancePermissionsProvider = AttendancePermissionsProvider(),
        _attendanceLocationValidator = AttendanceLocationValidator(),
        _punchInMarker = PunchInMarker(),
        _punchOutMarker = PunchOutMarker(),
        _breakStartMarker = BreakStartMarker(),
        _breakEndMarker = BreakEndMarker(),
        _attendanceReportProvider = AttendanceReportProvider(),
        _deviceSettings = DeviceSettings();

  AttendancePresenter.initWith(
    this._view,
    this._attendanceDetailsProvider,
    this._locationProvider,
    this._attendancePermissionsProvider,
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
      var attendanceReport = await _attendanceReportProvider.getReport();
      _view.showAttendanceReport(attendanceReport);
    } on WPException catch (e) {
      _view.showErrorAndRetryView("Getting attendance report is failed", e.userReadableMessage);
    }
  }

  //MARK: Function to load attendance details

  Future<void> loadAttendanceDetails() async {
    if (_attendanceDetailsProvider.isLoading) return;

    try {
      _view.showLoader();
      _attendanceDetails = await _attendanceDetailsProvider.getDetails();

      if (_attendanceDetails.isNotPunchedIn)
        _loadPunchInDetails();
      else if (_attendanceDetails.isPunchedIn)
        _loadPunchOutDetails();
      else if (_attendanceDetails.isPunchedOut) _loadPunchedOutDetails();
    } on WPException catch (_) {
      _view.showErrorAndRetryView(
          "Loading attendance details failed", "Failed to load attendance details.\nTap to reload");
    }
  }

  Future<void> _loadPunchInDetails() async {
    var canPunchInNow = await _canPunchInNow();
    if (!canPunchInNow) return;

    _attendanceLocation = await getLocation();
    if (_attendanceLocation == null) return;

    _view.showPunchInButton();
    _view.hideBreakButton();
    _loadAddress();
  }

  Future<void> _loadPunchOutDetails() async {
    //TODO
    // var canPunchOutFromApp = await _canMarkAttendanceFromApp();
    // if (!canPunchOutFromApp) return;
    //
    // _attendanceLocation = await getLocation();
    // if (_attendanceLocation == null) return;
    //
    // _view.showPunchOutButton();
    // _loadAddress();
    // _loadBreakDetails();
  }

  void _loadBreakDetails() {
    _attendanceDetails.isOnBreak ? _view.showResumeButton() : _view.showBreakButton();
  }

  Future<void> _loadPunchedOutDetails() async {
    //TODO:
    // _view.hideLoader();
    // await _loadPunchOutDetails(_attendanceDetails);
    /*
       if (attendanceDetails.isPunchedOut) {
      _showPunchInTime(attendanceDetails);
      _showPunchOutTime(attendanceDetails);
      _view.showDisabledButton();
      _view.hideBreakButton();
      */
  }

  //MARK: Functions to get attendance permissions

  Future<bool> _canPunchInNow() async {
    try {
      var attendancePermission = await _attendancePermissionsProvider.getPermissions();

      if (!attendancePermission.canPunchInFromApp) {
        _view.showErrorAndRetryView("Punch in from app disabled",
            "You are not allowed to punch in from the app.\nPlease contact your HR or tap to reload.");
        return false;
      }

      if (!attendancePermission.canPunchInNow) {
        _view.showCountDownView(attendancePermission.secondsTillPunchIn.toInt());
        return false;
      }

      return true;
    } on WPException catch (_) {
      _view.showErrorAndRetryView(
          "Failed to load punch in permission", "Failed to load punch in permission.\nTap to reload");
      return false;
    }
  }

  //MARK: Functions to get location

  Future<AttendanceLocation?> getLocation() async {
    try {
      var attendanceLocation = await _locationProvider.getLocation();
      _view.showLocationPositions(attendanceLocation);
      return attendanceLocation;
    } on LocationServicesDisabledException catch (e) {
      _view.showRequestToTurnOnGpsView("Location service disabled.\nTap here to go to location settings");
    } on LocationPermissionsDeniedException catch (e) {
      _view.showRequestToEnableLocationView("Location permission denied.\nTap here to grant permission");
    } on LocationPermissionsPermanentlyDeniedException catch (e) {
      _view.showRequestToEnableLocationView("Location permission denied.\nTap here to go to settings");
    } on LocationAcquisitionFailedException catch (e) {
      _view.showErrorAndRetryView("Getting location failed", e.userReadableMessage);
    }

    return null;
  }

  Future<void> _loadAddress() async {
    var address = "";
    if (_attendanceLocation == null) address = "";

    try {
      address = await _locationProvider.getLocationAddress(_attendanceLocation!);
    } on LocationReverseGeocodingException {
      address = "";
    }

    _view.showAddress(address);
  }

  //MARK: Functions to mark attendance

  Future<void> doPunchIn(bool isValid) async {
    try {
      //TODO:
      // await _punchInMarker.punchIn(_attendanceLocation, isLocationValid: isValid);
      _view.doRefresh();
    } on WPException catch (e) {
      _view.showErrorAndRetryView("Punched in failed", e.userReadableMessage);
    }
  }

  Future<void> doPunchOut(bool isValid) async {
    try {
      //TODO:
      // await _punchOutMarker.punchOut(_attendanceDetails, _attendanceLocation, isLocationValid: isValid);
      _view.doRefresh();
    } on WPException catch (e) {
      _view.showErrorAndRetryView("Punched out failed", e.userReadableMessage);
    }
  }

  Future<void> validateLocation(bool isForPunchIn) async {
    try {
      //TODO:
      // var isLocationValid =
      //await _attendanceLocationValidator.validateLocation(_attendanceLocation, isForPunchIn: isForPunchIn);
      // if (isLocationValid) {
      //   if (isForPunchIn) {
      //     await doPunchIn(true);
      //   } else {
      //     await doPunchOut(true);
      //   }
      // } else {
      //   _view.showAlertToInvalidLocation(
      //       isForPunchIn,
      //       "Invalid punch ${isForPunchIn ? 'in' : 'out'} location",
      //       "You are not allowed to punch ${isForPunchIn ? 'in' : 'out'} outside the office location. " +
      //           "Doing so will affect your performance. Would you still like to punch ${isForPunchIn ? 'in' : 'out'}?");
      // }
    } on WPException catch (e) {
      _view.showErrorAndRetryView("Failed to validate your location", e.userReadableMessage);
    }
  }

  //MARK: Functions to mark break

  Future<void> startBreak() async {
    try {
      //TODO:
      // await _breakStartMarker.startBreak(_attendanceDetails, _attendanceLocation);
      _view.doRefresh();
      _view.showResumeButton();
    } on WPException catch (e) {
      _view.showErrorAndRetryView("Start break is failed", e.userReadableMessage);
    }
  }

  Future<void> endBreak() async {
    try {
      //TODO:
      // await _breakEndMarker.endBreak(_attendanceDetails, _attendanceLocation);
      _view.showBreakButton();
    } on WPException catch (e) {
      _view.showErrorAndRetryView("End break is failed", e.userReadableMessage);
    }
  }

  // TODO -----

  void _showPunchInTime(AttendanceDetails attendanceDetails) {
    _view.showPunchInTime(attendanceDetails.punchInTimeString);
  }

  void _showPunchOutTime(AttendanceDetails attendanceDetails) {
    _view.showPunchOutTime(attendanceDetails.punchOutTimeString);
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
