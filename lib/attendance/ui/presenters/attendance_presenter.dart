import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance/entities/attendance_details.dart';
import 'package:wallpost/attendance/entities/attendance_location.dart';
import 'package:wallpost/attendance/exception/location_address_failed_exception.dart';
import 'package:wallpost/attendance/services/attendance_details_provider.dart';
import 'package:wallpost/attendance/services/attendance_location_validator.dart';
import 'package:wallpost/attendance/services/location_provider.dart';
import 'package:wallpost/attendance/services/punch_in_from_app_permission_provider.dart';
import 'package:wallpost/attendance/services/punch_in_now_permission_provider.dart';
import 'package:wallpost/attendance/services/punch_out_marker.dart';
import 'package:wallpost/attendance/ui/contracts/attendance_view.dart';

class AttendancePresenter {
  final AttendanceView _view;
  final AttendanceDetailsProvider _attendanceDetailsProvider;
  final LocationProvider _locationProvider;
  final PunchInFromAppPermissionProvider _punchInFromAppPermissionProvider;
  final PunchInNowPermissionProvider _punchInNowPermissionProvider;
  final AttendanceLocationValidator _attendanceLocationValidator;
  final PunchOutMarker _punchOutMarker;

  late AttendanceDetails _attendanceDetails;
  late AttendanceLocation _attendanceLocation;

  //NOTE: getting the location is a parallel process or - do we load location only when needed? - only when needed
  AttendancePresenter(this._view)
      : _attendanceDetailsProvider = AttendanceDetailsProvider(),
        _locationProvider = LocationProvider(),
        _punchInFromAppPermissionProvider = PunchInFromAppPermissionProvider(),
        _punchInNowPermissionProvider = PunchInNowPermissionProvider(),
        _attendanceLocationValidator = AttendanceLocationValidator(),
        _punchOutMarker = PunchOutMarker();

  AttendancePresenter.initWith(
      this._view,
      this._attendanceDetailsProvider,
      this._locationProvider,
      this._punchInFromAppPermissionProvider,
      this._punchInNowPermissionProvider,
      this._attendanceLocationValidator,
      this._punchOutMarker);

  Future<void> loadAttendanceDetails() async {
    if (_attendanceDetailsProvider.isLoading) return;

    try {
      _view.showLoader();
      _attendanceDetails = await _attendanceDetailsProvider.getDetails();
      if (_attendanceDetails.isPunchedIn) {
        _view.hideLoader();
        _loadPunchOutDetails(_attendanceDetails);
      } else {
        await _getPunchInFromAppPermission();
      }
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showDisabledButton();
      _view.showErrorMessage(
          "Loading attendance details failed", e.userReadableMessage);
    }
  }

  // Future<void> getLocation() async {
  //   try {
  //   _attendanceLocation = (await _locationProvider.getLocation())!;
  //   _getLocationAddress(_attendanceLocation);
  //
  //   } on LocationServicesDisabledException catch (e) {
  //     //turn on Gps
  //     _view.hideLoader();
  //     _view.showDisableButton();
  //     _view.showAlertToTurnOnDeviceLocation(
  //         "Please turn on device location", e.userReadableMessage);
  //   } on LocationPermissionsDeniedException catch (e) {
  //     // Show Location access permission alert
  //     _view.hideLoader();
  //     _view.showDisableButton();
  //     _view.showAlertToDeniedLocationPermission(
  //         "Please allow Location permission", e.userReadableMessage);
  //   } on LocationPermissionsPermanentlyDeniedException catch (e) {
  //     _view.hideLoader();
  //     _view.showDisableButton();
  //     _view.openAppSettings();
  //   } on LocationAcquisitionFailedException catch (e) {
  //     _view.hideLoader();
  //     _view.showDisableButton();
  //     _view.showFailedToGetLocation(
  //         "Getting location failed", e.userReadableMessage);
  //   }
  // }

  Future<void> _getLocationAddress(
      AttendanceLocation attendanceLocation) async {
    try {
      var address =
          await _locationProvider.getLocationAddress(attendanceLocation);
      _view.showLocationAddress(address.toString());
    } on LocationReverseGeocodingException catch (e) {
      _view.showLocationAddress("");
    }
  }

  Future<void> _getPunchInFromAppPermission() async {
    try {
      var punchInFromAppPermission =
          await _punchInFromAppPermissionProvider.canPunchInFromApp();
      if (punchInFromAppPermission.isAllowed) {
        await _loadPunchInDetails();
      } else {
        _view.hideLoader();
        _view.showDisabledButton();
        _view.hideBreakButton();
        _view.showError("Punch in from app disabled",
            "Looks like you are not allowed to punch in from the app. Please contact your HR to resolve this issue.");
      }
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showDisabledButton();
      _view.showErrorMessage(
          "Failed to load punch in from app permission", e.userReadableMessage);
    }
  }

  Future<void> _loadPunchInDetails() async {
    try {
      var punchInNowPermission =
          await _punchInNowPermissionProvider.canPunchInNow();
      _view.hideLoader();
      if (punchInNowPermission.canPunchInNow) {
        _view.showPunchInButton();
        _view.hideBreakButton();
      } else {
        _view.showDisabledButton();
        _view.hideBreakButton();
        _view.showTimeTillPunchIn(punchInNowPermission.secondsTillPunchIn);
      }
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showDisabledButton();
      _view.showErrorMessage(
          "Failed to load punch in permission", e.userReadableMessage);
    }
  }

  void _loadPunchOutDetails(AttendanceDetails attendanceDetails) {
    if (attendanceDetails.isPunchedOut) {
      _showPunchInTime(attendanceDetails);
      _showPunchOutTime(attendanceDetails);
      _view.showDisabledButton();
      _view.hideBreakButton();
    } else {
      _showPunchInTime(attendanceDetails);
      _view.showPunchOutButton();
      _isOnBreak(attendanceDetails);
    }
  }

  void _isOnBreak(AttendanceDetails attendanceDetails) {
    if (attendanceDetails.isOnBreak) {
      _view.showResumeButton();
    } else {
      _view.showBreakButton();
    }
  }

  Future<void> validateLocationForPunchOut() async {
    try {
      _view.showLoader();
      var isLocationValid = await _attendanceLocationValidator
          .validateLocation(_attendanceLocation, isForPunchIn: true);
      if (isLocationValid) {
        _doPunchOut();
      } else {
        _view.hideLoader();
        _view.showError("Location validation error", "Invalid location");
      }
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showErrorMessage(
          "Failed to location validation", e.userReadableMessage);
    }
  }

  Future<void> _doPunchOut() async {
    try {
      _punchOutMarker.punchOut(_attendanceDetails, _attendanceLocation,
          isLocationValid: true);
      _view.hideLoader();
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showErrorMessage("Punch out failed", e.userReadableMessage);
    }
  }

  void _showPunchInTime(AttendanceDetails attendanceDetails) {
    _view.showPunchInTime(attendanceDetails.punchInTimeString);
  }

  void _showPunchOutTime(AttendanceDetails attendanceDetails) {
    _view.showPunchOutTime(attendanceDetails.punchOutTimeString);
  }
}
