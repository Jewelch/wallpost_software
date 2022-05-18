import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/device/device_settings.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_permissions.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_permission_denied_exception.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_permission_permanently_denied_exception.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_services_disabled_exception.dart';
import 'package:wallpost/attendance_punch_in_out/services/attendance_details_provider.dart';
import 'package:wallpost/attendance_punch_in_out/services/attendance_location_validator.dart';
import 'package:wallpost/attendance_punch_in_out/services/attendance_permissions_provider.dart';
import 'package:wallpost/attendance_punch_in_out/services/attendance_report_provider.dart';
import 'package:wallpost/attendance_punch_in_out/services/break_end_marker.dart';
import 'package:wallpost/attendance_punch_in_out/services/break_start_marker.dart';
import 'package:wallpost/attendance_punch_in_out/services/location_provider.dart';
import 'package:wallpost/attendance_punch_in_out/services/punch_in_marker.dart';
import 'package:wallpost/attendance_punch_in_out/services/punch_out_marker.dart';
import 'package:wallpost/attendance_punch_in_out/ui/view_contracts/attendance_detailed_view.dart';
import 'package:wallpost/attendance_punch_in_out/ui/view_contracts/attendance_view.dart';
import 'package:wallpost/attendance_punch_in_out/ui/presenters/attendance_presenter.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockAttendanceView extends Mock implements AttendanceView {}

class MockAttendanceDetailsView extends Mock implements AttendanceDetailedView {}

class MockAttendanceDetailsProvider extends Mock implements AttendanceDetailsProvider {}

class MockAttendancePermissionProvider extends Mock implements AttendancePermissionsProvider {}

class MockLocationProvider extends Mock implements LocationProvider {}

class MockAttendanceDetails extends Mock implements AttendanceDetails {}

class MockAttendancePermission extends Mock implements AttendancePermissions {}

class MockAttendanceLocation extends Mock implements AttendanceLocation {}

class MockAttendanceLocationValidator extends Mock implements AttendanceLocationValidator {}

class MockAttendanceReportProvider extends Mock implements AttendanceReportProvider {}

class MockPunchInMarker extends Mock implements PunchInMarker {}

class MockPunchOutMarker extends Mock implements PunchOutMarker {}

class MockBreakStartMarker extends Mock implements BreakStartMarker {}

class MockBreakEndMarker extends Mock implements BreakEndMarker {}

class MockDeviceSettings extends Mock implements DeviceSettings {}

void main() {
  var view = MockAttendanceView();
  var detailView = MockAttendanceDetailsView();
  var mockAttendanceDetailsProvider = MockAttendanceDetailsProvider();
  var mockLocationProvider = MockLocationProvider();
  var mockAttendancePermissionProvider = MockAttendancePermissionProvider();
  var mockAttendanceLocationValidator = MockAttendanceLocationValidator();
  var mockPunchInMarker = MockPunchInMarker();
  var mockPunchOutMarker = MockPunchOutMarker();
  var mockBreakStartMaker = MockBreakStartMarker();
  var mocKBreakEndMarker = MockBreakEndMarker();
  var mockAttendanceReportProvider = MockAttendanceReportProvider();

  var mockDeviceSettings = MockDeviceSettings();

  AttendancePresenter presenter = AttendancePresenter.initWith(
      view,
      detailView,
      mockAttendanceDetailsProvider,
      mockLocationProvider,
      mockAttendanceLocationValidator,
      mockPunchInMarker,
      mockPunchOutMarker,
      mockBreakStartMaker,
      mocKBreakEndMarker,
      mockAttendanceReportProvider,
      mockDeviceSettings);

  setUp(() {
    reset(view);
    reset(detailView);
    reset(mockAttendanceDetailsProvider);
    //  reset(mockLocationProvider);
    reset(mockLocationProvider);
    reset(mockAttendanceLocationValidator);
    reset(mockPunchOutMarker);
    registerFallbackValue(MockAttendanceDetails());
    registerFallbackValue(MockAttendancePermission());
    registerFallbackValue(MockAttendanceLocation());
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(detailView);
    verifyNoMoreInteractions(mockAttendanceDetailsProvider);
    verifyNoMoreInteractions(mockLocationProvider);
    verifyNoMoreInteractions(mockAttendanceLocationValidator);
    verifyNoMoreInteractions(mockPunchOutMarker);
  }

  test('failure to load attendance details', () async {
    //given

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => view.showErrorAndRetryView("Failed to load attendance details.\nTap to reload"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("loading attendance details successfully", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value(""));

    //when
    await presenter.loadAttendanceDetails();
    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => detailView.showLocationOnMap(attendanceLocation),
      () => view.showPunchInButton(),
      () => detailView.hideBreakButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('shows error and retry button when the user cannot mark attendance permission from app', () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(false);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => view.showErrorAndRetryView(
          "You are not allowed to mark attendance from the app.\nPlease contact your HR or tap to reload.")
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('shows remaining time to punch in  when the user is not punched in and cannot punch in now', () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(false);
    when(() => attendance.secondsTillPunchIn).thenReturn(123);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => view.showCountDownView(123),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('shows request to turn on gps when location service disabled', () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.error(LocationServicesDisabledException()));

    //when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.showRequestToTurnOnGpsView("Location service disabled.\nTap here to go to location settings"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('shows request to grant permission when the location permission is denied', () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.error(LocationPermissionsDeniedException()));

    //when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.showErrorAndRetryView("Location permission denied.\nTap here to grant permission"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('show request to go to app settings when the location permission is permanently denied', () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.error(LocationPermissionsPermanentlyDeniedException()));

    //when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.showRequestToEnableLocationView("Location permission denied.\nTap here to go to settings"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("shows punch in button when the user is not punched in and can punch in now", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value(""));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => detailView.showLocationOnMap(attendanceLocation),
      () => view.showPunchInButton(),
      () => detailView.hideBreakButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("show alert when failed to validate location for punch in", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendancePermission = MockAttendancePermission();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendancePermission.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendancePermission.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockAttendancePermissionProvider.getPermissions()).thenAnswer((_) => Future.value(attendancePermission));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: true))
        .thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.loadAttendanceDetails();

    //when
    await presenter.isValidatedLocation(true);

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockAttendancePermissionProvider.getPermissions(),
      () => mockLocationProvider.getLocation(),
      () => detailView.showLocationOnMap(attendanceLocation),
      () => view.showPunchInButton(),
      () => detailView.hideBreakButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
      () => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: true),
      () => view.showAddress("address"),
      () => view.showErrorMessage("Failed to validate your location", InvalidResponseException().userReadableMessage),
    ]);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("failure to punch in", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendancePermission = MockAttendancePermission();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendancePermission.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendancePermission.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockAttendancePermissionProvider.getPermissions()).thenAnswer((_) => Future.value(attendancePermission));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: true))
        .thenAnswer((_) => Future.value(true));
    when(() => mockPunchInMarker.punchIn(any(), isLocationValid: true))
        .thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.loadAttendanceDetails();

    //when
    await presenter.isValidatedLocation(true);

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockAttendancePermissionProvider.getPermissions(),
      () => mockLocationProvider.getLocation(),
      () => detailView.showLocationOnMap(attendanceLocation),
      () => view.showPunchInButton(),
      () => detailView.hideBreakButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
      () => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: true),
      () => view.showAddress("address"),
      () => mockPunchInMarker.punchIn(any(), isLocationValid: true),
      () => view.showErrorMessage('Punched in failed', InvalidResponseException().userReadableMessage),
    ]);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("successfully punched in with invalid location", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendancePermission = MockAttendancePermission();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendancePermission.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendancePermission.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockAttendancePermissionProvider.getPermissions()).thenAnswer((_) => Future.value(attendancePermission));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: true))
        .thenAnswer((_) => Future.value(false));
    when(() => mockPunchInMarker.punchIn(any(), isLocationValid: false)).thenAnswer((_) => Future.value());
    await presenter.loadAttendanceDetails();
    await presenter.isValidatedLocation(true);

    //when
    await presenter.markPunchIn(isLocationValid: false);

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockAttendancePermissionProvider.getPermissions(),
      () => mockLocationProvider.getLocation(),
      () => detailView.showLocationOnMap(attendanceLocation),
      () => view.showPunchInButton(),
      () => detailView.hideBreakButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
      () => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: true),
      () => view.showAddress("address"),
      () => view.showAlertToInvalidLocation(
          true,
          'Invalid location',
          "You are not allowed to mark attendance outside the office location. " +
              "Doing so will affect your performance. Would you still like to mark?"),
      () => mockPunchInMarker.punchIn(any(), isLocationValid: false),
      () => view.doRefresh()
    ]);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("successfully punched in with valid location", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendancePermission = MockAttendancePermission();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendancePermission.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendancePermission.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockAttendancePermissionProvider.getPermissions()).thenAnswer((_) => Future.value(attendancePermission));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: true))
        .thenAnswer((_) => Future.value(true));
    when(() => mockPunchInMarker.punchIn(any(), isLocationValid: true)).thenAnswer((_) => Future.value());
    await presenter.loadAttendanceDetails();

    //when
    await presenter.isValidatedLocation(true);

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockAttendancePermissionProvider.getPermissions(),
      () => mockLocationProvider.getLocation(),
      () => detailView.showLocationOnMap(attendanceLocation),
      () => view.showPunchInButton(),
      () => detailView.hideBreakButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
      () => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: true),
      () => view.showAddress("address"),
      () => mockPunchInMarker.punchIn(any(), isLocationValid: true),
      () => view.doRefresh()
    ]);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("shows punch out button when the user is punched in and not punched out", () async {
    //given

    var attendance = MockAttendanceDetails();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isNotPunchedIn).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(true);
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value(""));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => detailView.showLocationOnMap(attendanceLocation),
      () => view.showPunchOutButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
      () => detailView.showPunchInTime(punchInTime),
      () => detailView.showBreakButton(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("shows resume button when the user is on break", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendancePermission = MockAttendancePermission();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isNotPunchedIn).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(true);
    when(() => attendancePermission.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendancePermission.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockAttendancePermissionProvider.getPermissions()).thenAnswer((_) => Future.value(attendancePermission));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value(""));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockAttendancePermissionProvider.getPermissions(),
      () => mockLocationProvider.getLocation(),
      () => detailView.showLocationOnMap(attendanceLocation),
      () => view.showPunchOutButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
      () => detailView.showResumeButton(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("failure to punch out", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendancePermission = MockAttendancePermission();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isNotPunchedIn).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);
    when(() => attendancePermission.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendancePermission.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockAttendancePermissionProvider.getPermissions()).thenAnswer((_) => Future.value(attendancePermission));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value(""));
    when(() => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true))
        .thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.loadAttendanceDetails();

    // when
    await presenter.markPunchOut(true);

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockAttendancePermissionProvider.getPermissions(),
      () => mockLocationProvider.getLocation(),
      () => detailView.showLocationOnMap(attendanceLocation),
      () => view.showPunchOutButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
      () => detailView.showBreakButton(),
      () => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true),
      () => view.showAddress(""),
      () => view.showErrorMessage('Punched out failed', InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("successfully punched out with invalid location", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendancePermission = MockAttendancePermission();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isNotPunchedIn).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);
    when(() => attendancePermission.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendancePermission.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockAttendancePermissionProvider.getPermissions()).thenAnswer((_) => Future.value(attendancePermission));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: false))
        .thenAnswer((_) => Future.value(false));
    when(() => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: false)).thenAnswer((_) => Future.value());

    await presenter.loadAttendanceDetails();
    await presenter.isValidatedLocation(false);

    // when
    await presenter.markPunchOut(false);

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockAttendancePermissionProvider.getPermissions(),
      () => mockLocationProvider.getLocation(),
      () => detailView.showLocationOnMap(attendanceLocation),
      () => view.showPunchOutButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
      () => detailView.showBreakButton(),
      () => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: false),
      () => view.showAddress("address"),
      () => view.showAlertToInvalidLocation(
          true,
          'Invalid location',
          "You are not allowed to mark attendance outside the office location. " +
              "Doing so will affect your performance. Would you still like to mark?"),
      () => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: false),
      () => view.doRefresh()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("successfully punched out when the location is valid", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendancePermission = MockAttendancePermission();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isNotPunchedIn).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);
    when(() => attendancePermission.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendancePermission.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockAttendancePermissionProvider.getPermissions()).thenAnswer((_) => Future.value(attendancePermission));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: false))
        .thenAnswer((_) => Future.value(true));
    when(() => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true)).thenAnswer((_) => Future.value());

    await presenter.loadAttendanceDetails();

    // when
    await presenter.isValidatedLocation(false);

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockAttendancePermissionProvider.getPermissions(),
      () => mockLocationProvider.getLocation(),
      () => detailView.showLocationOnMap(attendanceLocation),
      () => view.showPunchOutButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
      () => detailView.showBreakButton(),
      () => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: false),
      () => view.showAddress("address"),
      () => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true),
      () => view.doRefresh()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("shows punch in and out time  when the user is punched out and cannot punch in now", () async {
    //given


    var attendance = MockAttendanceDetails();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedOut).thenReturn(true);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(false);
    when(() => attendance.secondsTillPunchIn).thenReturn(123);
    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);
    String punchOutTime = inputFormat.parse('2021-09-02 18:00:00').toString();
    when(() => attendance.punchOutTimeString).thenReturn(punchOutTime);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value(""));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => view.showCountDownView(123),
      () => mockLocationProvider.getLocation(),
      () => detailView.showLocationOnMap(attendanceLocation),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
      () => detailView.showPunchInTime(punchInTime),
      () => detailView.showPunchOutTime(punchOutTime),
      () => detailView.hideBreakButton(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  //
  // test(
  //     "shows disabled button with punch in and punch out time after the user is punched out",
  //     () async {
  //   //given
  //   var attendance = MockAttendanceDetails();
  //   when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
  //   when(() => attendance.isPunchedIn).thenReturn(true);
  //   when(() => attendance.isPunchedOut).thenReturn(true);
  //   var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  //   String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
  //   when(() => attendance.punchInTimeString).thenReturn(punchInTime);
  //   String punchOutTime = inputFormat.parse('2021-09-02 18:00:00').toString();
  //   when(() => attendance.punchOutTimeString).thenReturn(punchOutTime);
  //   when(() => mockAttendanceDetailsProvider.getDetails())
  //       .thenAnswer((_) => Future.value(attendance));
  //
  //   // when
  //   await presenter.loadAttendanceDetails();
  //
  //   //then
  //   verifyInOrder([
  //     () => mockAttendanceDetailsProvider.isLoading,
  //     () => view.showLoader(),
  //     () => mockAttendanceDetailsProvider.getDetails(),
  //     () => view.hideLoader(),
  //     () => view.showPunchInTime(punchInTime),
  //     () => view.showPunchOutTime(punchOutTime),
  //     () => view.showDisabledButton(),
  //     () => view.hideBreakButton(),
  //   ]);
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  //
  // test("show resume button when start break", () async {
  //   //given
  //   var attendance = MockAttendanceDetails();
  //   var attendanceLocation = MockAttendanceLocation();
  //   when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
  //   when(() => attendance.isPunchedIn).thenReturn(true);
  //   when(() => attendance.isPunchedOut).thenReturn(false);
  //   when(() => attendance.isOnBreak).thenReturn(false);
  //   var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  //   String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
  //   when(() => attendance.punchInTimeString).thenReturn(punchInTime);
  //   when(() => mockAttendanceDetailsProvider.getDetails())
  //       .thenAnswer((_) => Future.value(attendance));
  //   when(() => mockLocationProvider.getLocation())
  //       .thenAnswer((_) => Future.value(attendanceLocation));
  //   when(() => mockLocationProvider.getLocationAddress(any()))
  //       .thenAnswer((_) => Future.value("address"));
  //   when(() => mockBreakStartMaker.startBreak(any(), any()))
  //       .thenAnswer((_) => Future.value());
  //
  //   await presenter.loadAttendanceDetails();
  //
  //   // when
  //   await presenter.startBreak();
  //
  //   //then
  //   verifyInOrder([
  //     () => mockAttendanceDetailsProvider.isLoading,
  //     () => view.showLoader(),
  //     () => mockAttendanceDetailsProvider.getDetails(),
  //     () => view.hideLoader(),
  //     () => view.showPunchInTime(punchInTime),
  //     () => view.showPunchOutButton(),
  //     () => view.showBreakButton(),
  //     () => mockLocationProvider.getLocation(),
  //     () => view.showLocationPositions(attendanceLocation),
  //     () => mockLocationProvider.getLocationAddress(any()),
  //     () => view.showLocationAddress("address"),
  //     () => mockBreakStartMaker.startBreak(any(), any()),
  //     () => view.doRefresh(),
  //     () => view.showResumeButton()
  //   ]);
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
  //
  // test("show break button when end break", () async {
  //   //given
  //   var attendance = MockAttendanceDetails();
  //   var attendanceLocation = MockAttendanceLocation();
  //   when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
  //   when(() => attendance.isPunchedIn).thenReturn(true);
  //   when(() => attendance.isPunchedOut).thenReturn(false);
  //   when(() => attendance.isOnBreak).thenReturn(true);
  //   var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  //   String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
  //   when(() => attendance.punchInTimeString).thenReturn(punchInTime);
  //   when(() => mockAttendanceDetailsProvider.getDetails())
  //       .thenAnswer((_) => Future.value(attendance));
  //   when(() => mockLocationProvider.getLocation())
  //       .thenAnswer((_) => Future.value(attendanceLocation));
  //   when(() => mockLocationProvider.getLocationAddress(any()))
  //       .thenAnswer((_) => Future.value("address"));
  //   when(() => mocKBreakEndMarker.endBreak(any(), any()))
  //       .thenAnswer((_) => Future.value());
  //
  //   await presenter.loadAttendanceDetails();
  //
  //   // when
  //   await presenter.endBreak();
  //
  //   //then
  //   verifyInOrder([
  //     () => mockAttendanceDetailsProvider.isLoading,
  //     () => view.showLoader(),
  //     () => mockAttendanceDetailsProvider.getDetails(),
  //     () => view.hideLoader(),
  //     () => view.showPunchInTime(punchInTime),
  //     () => view.showPunchOutButton(),
  //     () => view.showResumeButton(),
  //     () => mockLocationProvider.getLocation(),
  //     () => view.showLocationPositions(attendanceLocation),
  //     () => mockLocationProvider.getLocationAddress(any()),
  //     () => view.showLocationAddress("address"),
  //     () => mocKBreakEndMarker.endBreak(any(), any()),
  //     () => view.showBreakButton()
  //   ]);
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
}

//When to get the location first
// 1. user is not punched in (attendance details) and can punch in now + can punch in from app (call the two services)
// 2. user is punched in
