import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance/entities/attendance_details.dart';
import 'package:wallpost/attendance/entities/attendance_location.dart';
import 'package:wallpost/attendance/exception/location_acquisition_failed_exception.dart';
import 'package:wallpost/attendance/exception/location_address_failed_exception.dart';
import 'package:wallpost/attendance/exception/location_permission_denied_exception.dart';
import 'package:wallpost/attendance/exception/location_permission_permanently_denied_exception.dart';
import 'package:wallpost/attendance/exception/location_services_disabled_exception.dart';
import 'package:wallpost/attendance/services/attendance_details_provider.dart';
import 'package:wallpost/attendance/services/attendance_location_validator.dart';
import 'package:wallpost/attendance/services/location_provider.dart';
import 'package:wallpost/attendance/services/punch_in_from_app_permission_provider.dart';
import 'package:wallpost/attendance/services/punch_in_now_permission_provider.dart';
import 'package:wallpost/attendance/ui/contracts/attendance_view.dart';

class AttendancePresenter {
  final AttendanceView _view;
  final AttendanceDetailsProvider _attendanceDetailsProvider;
  final LocationProvider _locationProvider;
  final PunchInFromAppPermissionProvider _punchInFromAppPermissionProvider;
  final PunchInNowPermissionProvider _punchInNowPermissionProvider;
  final AttendanceLocationValidator _attendanceLocationValidator;

  late AttendanceLocation _attendanceLocation;

  AttendancePresenter(this._view)
      : _attendanceDetailsProvider = AttendanceDetailsProvider(),
        _locationProvider = LocationProvider(),
        _punchInFromAppPermissionProvider = PunchInFromAppPermissionProvider(),
        _punchInNowPermissionProvider = PunchInNowPermissionProvider(),
        _attendanceLocationValidator = AttendanceLocationValidator();

  AttendancePresenter.initWith(
      this._view,
      this._attendanceDetailsProvider,
      this._locationProvider,
      this._punchInFromAppPermissionProvider,
      this._punchInNowPermissionProvider,
      this._attendanceLocationValidator);

  Future<void> loadAttendanceDetails() async {
    if (_attendanceDetailsProvider.isLoading) return;

    try {
      _view.showLoader();
      var attendanceDetails = await _attendanceDetailsProvider.getDetails();
      await _getLocation(attendanceDetails);
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showDisableButton();
      _view.showFailedToLoadAttendance(
          "Loading attendance details failed", e.userReadableMessage);
    }
  }

  Future<void> _getLocation(AttendanceDetails attendanceDetails) async {
    try {
      _attendanceLocation = (await _locationProvider.getLocation())!;
      _view.hideLoader();
      _getLocationAddress(_attendanceLocation);
      if (attendanceDetails.isPunchedIn) {
        _loadPunchOutDetails(attendanceDetails);
      } else {
        await _getPunchInFromAppPermission();
      }
    } on LocationServicesDisabledException catch (e) {
      //turn on Gps
      _view.hideLoader();
      _view.showDisableButton();
      _view.showAlertToTurnOnDeviceLocation(
          "Please turn on device location", e.userReadableMessage);
    } on LocationPermissionsDeniedException catch (e) {
      // Show Location access permission alert
      _view.hideLoader();
      _view.showDisableButton();
      _view.showAlertToDeniedLocationPermission(
          "Please allow Location permission", e.userReadableMessage);
    } on LocationPermissionsPermanentlyDeniedException catch (e) {
      _view.hideLoader();
      _view.showDisableButton();
      _view.openAppSettings();
    } on LocationAcquisitionFailedException catch (e) {
      _view.hideLoader();
      _view.showDisableButton();
      _view.showFailedToGetLocation(
          "Getting location failed", e.userReadableMessage);
    }
  }

  Future<void> _getLocationAddress(
      AttendanceLocation attendanceLocation) async {
    try {
      var address =
          await _locationProvider.getLocationAddress(attendanceLocation);
      _view.showLocationAddress(address.toString());
    } on LocationAddressFailedException catch (e) {
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
        _view.showDisableButton();
        _view.hideBreakButton();
        _view
            .showMessageToAllowPunchInFromAppPermission("Allow app permission");
      }
    } on WPException catch (e) {
      _view.showDisableButton();
    }
  }

  Future<void> _loadPunchInDetails() async {
    try {
      var punchInNowPermission =
          await _punchInNowPermissionProvider.canPunchInNow();
      if (punchInNowPermission.canPunchInNow) {
        _view.showPunchInButton();
      } else {
        _view.showDisableButton();
        _view.hideBreakButton();
        _view.showSecondTillPunchIn(
            punchInNowPermission.secondsTillPunchIn.toString());
      }
    } on WPException catch (e) {
      _view.showDisableButton();
    }
  }

  void _loadPunchOutDetails(AttendanceDetails attendanceDetails) {
    if (attendanceDetails.isPunchedOut) {
      _view.hideBreakButton();
      _showPunchOutTime(attendanceDetails);
    } else {
      _showPunchInTime(attendanceDetails);
      _isOnBreak(attendanceDetails);
      _view.showPunchOutButton();
    }
  }

  void _isOnBreak(AttendanceDetails attendanceDetails) {
    if (attendanceDetails.isOnBreak) {
      _view.showResumeButton();
    } else {
      _view.showBreakButton();
    }
  }

  Future<void> doPunchOut() async {
    var isLocationValid = await _attendanceLocationValidator
        .validateLocation(_attendanceLocation, isForPunchIn: true);

    if (isLocationValid) {
      _view.doPunchOut();
    } else {
      _view.showAlertToVerifyLocation(
        "location is not valid",
      );
    }
  }

  void _showPunchInTime(AttendanceDetails attendanceDetails) {
    _view.showPunchInTime(attendanceDetails.punchInTimeString);
  }

  void _showPunchOutTime(AttendanceDetails attendanceDetails) {
    _view.showPunchOutTime(attendanceDetails.punchOutTimeString);
  }
}
