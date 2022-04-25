import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_report.dart';
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
import 'package:wallpost/attendance_punch_in_out/services/punch_in_from_app_permission_provider.dart';
import 'package:wallpost/attendance_punch_in_out/services/punch_in_marker.dart';
import 'package:wallpost/attendance_punch_in_out/services/punch_in_now_permission_provider.dart';
import 'package:wallpost/attendance_punch_in_out/services/punch_out_marker.dart';
import 'package:wallpost/attendance_punch_in_out/ui/view_contracts/attendance_view.dart';

class AttendancePresenter {
  final AttendanceView _view;
  final AttendanceDetailsProvider _attendanceDetailsProvider;
  final LocationProvider _locationProvider;
  final PunchInFromAppPermissionProvider _punchInFromAppPermissionProvider;
  final PunchInNowPermissionProvider _punchInNowPermissionProvider;
  final AttendanceLocationValidator _attendanceLocationValidator;
  final PunchOutMarker _punchOutMarker;
  final PunchInMarker _punchInMarker;
  final BreakStartMarker _breakStartMarker;
  final BreakEndMarker _breakEndMarker;
  late AttendanceReportProvider _attendanceReportProvider;

  late AttendanceDetails _attendanceDetails;
  late AttendanceLocation _attendanceLocation;
  late AttendanceReport _attendanceReport;

  AttendancePresenter(this._view)
      : _attendanceDetailsProvider = AttendanceDetailsProvider(),
        _locationProvider = LocationProvider(),
        _punchInFromAppPermissionProvider = PunchInFromAppPermissionProvider(),
        _punchInNowPermissionProvider = PunchInNowPermissionProvider(),
        _attendanceLocationValidator = AttendanceLocationValidator(),
        _punchInMarker = PunchInMarker(),
        _punchOutMarker = PunchOutMarker(),
        _breakStartMarker = BreakStartMarker(),
        _breakEndMarker = BreakEndMarker(),
        _attendanceReportProvider = AttendanceReportProvider();

  AttendancePresenter.initWith(
      this._view,
      this._attendanceDetailsProvider,
      this._locationProvider,
      this._punchInFromAppPermissionProvider,
      this._punchInNowPermissionProvider,
      this._attendanceLocationValidator,
      this._punchInMarker,
      this._punchOutMarker,
      this._breakStartMarker,
      this._breakEndMarker,
      this._attendanceReportProvider);

  Future<void> loadAttendanceDetails() async {
    if (_attendanceDetailsProvider.isLoading) return;

    try {
      _view.showLoader();
      _attendanceDetails = await _attendanceDetailsProvider.getDetails();

      if (_attendanceDetails.isPunchedIn) {
        _view.hideLoader();
        await _loadPunchOutDetails(_attendanceDetails);
      } else {
        await _getPunchInFromAppPermission();
      }
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showErrorMessage("Loading attendance details failed", "Failed to load attendance details.\nTap to reload");
    }
  }

  Future<void> getLocation() async {
    try {
      _attendanceLocation = (await _locationProvider.getLocation())!;
      _view.showLocationPositions(_attendanceLocation);
      await _getLocationAddress(_attendanceLocation);
    } on LocationServicesDisabledException catch (e) {
      _view.requestToTurnOnDeviceLocation(e.userReadableMessage, "Location service disabled."
          "\nTap here to go to location settings");
    }
    on LocationPermissionsDeniedException catch (e) {
      _view.requestToLocationPermissions(true,e.userReadableMessage, "Location permission denied."
          "\nTap here to grant permission");
    } on LocationPermissionsPermanentlyDeniedException catch (e){
      _view.requestToLocationPermissions(false,e.userReadableMessage, "Location permission denied."
          "\nTap here to go to settings");
    } on LocationAcquisitionFailedException catch (e) {
      _view.showErrorMessage("Getting location failed", e.userReadableMessage);
    }
  }

  Future<void> _getLocationAddress(AttendanceLocation attendanceLocation) async {
    try {
      var address = await _locationProvider.getLocationAddress(attendanceLocation);
      _view.showLocationAddress(address.toString());
    } on LocationReverseGeocodingException {
      _view.showLocationAddress("");
    }
  }

  Future<void> _getPunchInFromAppPermission() async {
    try {
      var punchInFromAppPermission = await _punchInFromAppPermissionProvider.canPunchInFromApp();
      if (punchInFromAppPermission.isAllowed) {
        await _loadPunchInDetails();
      } else {
        _view.hideLoader();
        _view.hideBreakButton();
        _view.showErrorMessage("Punch in from app disabled", "Punch in from app disabled,"
            "Looks like you are not allowed to punch in from the app.\nPlease contact your HR to resolve this issue.");
      }
    } on WPException catch (e) {
      _view.hideLoader();
     // _view.showDisabledButton();
      _view.showErrorMessage("", "Failed to load punch in from app permission.\nTap to reload");
    }
  }

  Future<void> _loadPunchInDetails() async {
    try {
      var punchInNowPermission = await _punchInNowPermissionProvider.canPunchInNow();
      _view.hideLoader();
      if (punchInNowPermission.canPunchInNow) {
        _view.showPunchInButton();
        _view.hideBreakButton();
        await getLocation();
      } else {
        _view.showDisabledButton();
        _view.hideBreakButton();
        _view.showTimeTillPunchIn(punchInNowPermission.secondsTillPunchIn);
      }
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showErrorMessage("Failed to load punch in permission", "Failed to load punch in permission.\nTap to reload");
    }
  }

  Future<void> _loadPunchOutDetails(AttendanceDetails attendanceDetails) async {
    if (attendanceDetails.isPunchedOut) {
      _showPunchInTime(attendanceDetails);
      _showPunchOutTime(attendanceDetails);
      _view.showDisabledButton();
      _view.hideBreakButton();
    } else {
      //_showPunchInTime(_attendanceDetails);
      _view.showPunchOutButton();
      await getLocation();
      _isOnBreak(_attendanceDetails);

    }
  }

  void _isOnBreak(AttendanceDetails attendanceDetails) {
    if (attendanceDetails.isOnBreak) {
      _view.showResumeButton();
    } else {
      _view.showBreakButton();
    }
  }

  Future<void> validateLocation(bool isForPunchIn) async {
    try {
      var isLocationValid =
          await _attendanceLocationValidator.validateLocation(_attendanceLocation, isForPunchIn: isForPunchIn);
      if (isLocationValid) {
        if (isForPunchIn) {
          await doPunchIn(true);
        } else {
          await doPunchOut(true);
        }
      } else {
        _view.showAlertToInvalidLocation(
            isForPunchIn,
            "Invalid punch ${isForPunchIn ? 'in' : 'out'} location",
            "You are not allowed to punch ${isForPunchIn ? 'in' : 'out'} outside the office location. " +
                "Doing so will affect your performance. Would you still like to punch ${isForPunchIn ? 'in' : 'out'}?");
      }
    } on WPException catch (e) {
      _view.showErrorMessage("Failed to validate your location", e.userReadableMessage);
    }
  }

  Future<void> doPunchIn(bool isValid) async {
    try {
      await _punchInMarker.punchIn(_attendanceLocation, isLocationValid: isValid);
      _view.doRefresh();
    } on WPException catch (e) {
      _view.showErrorMessage("Punched in failed", e.userReadableMessage);
    }
  }

  Future<void> doPunchOut(bool isValid) async {
    try {
      await _punchOutMarker.punchOut(_attendanceDetails, _attendanceLocation, isLocationValid: isValid);
      _view.doRefresh();
    } on WPException catch (e) {
      _view.showErrorMessage("Punched out failed", e.userReadableMessage);
    }
  }

  Future<void> startBreak() async {
    try {
      await _breakStartMarker.startBreak(_attendanceDetails, _attendanceLocation);
      _view.doRefresh();
      _view.showResumeButton();
    } on WPException catch (e) {
      _view.showErrorMessage("Start break is failed", e.userReadableMessage);
    }
  }

  Future<void> endBreak() async {
    try {
      await _breakEndMarker.endBreak(_attendanceDetails, _attendanceLocation);
      _view.showBreakButton();
    } on WPException catch (e) {
      _view.showErrorMessage("End break is failed", e.userReadableMessage);
    }
  }

  Future<void> loadAttendanceReport() async {
    try {
      _attendanceReport = await _attendanceReportProvider.getReport();
      _view.showAttendanceReport(_attendanceReport);
    } on WPException catch (e) {
      _view.showErrorMessage("Getting attendance report is failed", e.userReadableMessage);
    }
  }

  void _showPunchInTime(AttendanceDetails attendanceDetails) {
    _view.showPunchInTime(attendanceDetails.punchInTimeString);
  }

  void _showPunchOutTime(AttendanceDetails attendanceDetails) {
    _view.showPunchOutTime(attendanceDetails.punchOutTimeString);
  }
}
