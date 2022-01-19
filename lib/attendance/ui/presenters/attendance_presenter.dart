import 'package:geolocator/geolocator.dart';
import 'package:wallpost/_shared/exceptions/wp_exception.dart';
import 'package:wallpost/attendance/entities/attendance_details.dart';
import 'package:wallpost/attendance/entities/punch_in_from_app_permission.dart';
import 'package:wallpost/attendance/entities/punch_in_now_permission.dart';
import 'package:wallpost/attendance/services/attendance_details_provider.dart';
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

  late AttendanceDetails _attendanceDetails;
  late PunchInFromAppPermission _punchInFromAppPermission;
  late PunchInNowPermission _punchInNowPermission;
  late Position _position;

  AttendancePresenter(this._view)
      : _attendanceDetailsProvider = AttendanceDetailsProvider(),
        _locationProvider = LocationProvider(),
        _punchInFromAppPermissionProvider = PunchInFromAppPermissionProvider(),
        _punchInNowPermissionProvider = PunchInNowPermissionProvider();

  AttendancePresenter.initWith(this._view, this._attendanceDetailsProvider, this._locationProvider,
      this._punchInFromAppPermissionProvider, this._punchInNowPermissionProvider);

  Future<void> loadAttendanceDetails() async {
    if (_attendanceDetailsProvider.isLoading) return;

    _view.showLoader();

    try {
      var attendanceDetails = await _attendanceDetailsProvider.getDetails();
      _view.hideLoader();
      _getLocation(attendanceDetails);
    } on WPException catch (e) {
      _view.hideLoader();
      _view.showDisableButton();
      _view.showFailedToLoadAttendance("Loading attendance details failed", e.userReadableMessage);
    }
  }

  void _getLocation(AttendanceDetails attendanceDetails) async {
    try {
      await _locationProvider.getLocation();
      if (!attendanceDetails.isPunchedIn) {
        _getPunchInFromAppPermission();
      }
    } on WPException catch (e) {
      _view.showDisableButton();
      _view.showFailedToGetLocation("Getting location failed");
    }
  }

  void _getPunchInFromAppPermission() async {
    var punchInFromAppPermission = await _punchInFromAppPermissionProvider.canPunchInFromApp();
    if (punchInFromAppPermission.isAllowed) {
      _loadPunchInDetails();
    } else {
      _view.showDisableButton();
      _view.hideBreakButton();
      _view.showFailedToGetPunchInFromAppPermission("Punch in from app permission failed");
    }
  }

  void _loadPunchInDetails() async {
    var punchInNowPermission = await _punchInNowPermissionProvider.canPunchInNow();
    if (punchInNowPermission.canPunchInNow) {
      _view.showPunchInButton();
    } else {
      _view.showDisableButton();
      _view.hideBreakButton();
      _view.showSecondTillPunchIn(punchInNowPermission.secondsTillPunchIn.toString());
    }
  }

  void _getLocationAddress(Position position) async {
    var address = await _locationProvider.getLocationAddress(position);
    _view.showLocationAddress(address.toString());
  }
}
