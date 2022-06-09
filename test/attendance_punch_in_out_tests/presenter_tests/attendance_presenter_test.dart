import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/device/device_settings.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_details.dart';
import 'package:wallpost/attendance_punch_in_out/entities/attendance_location.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_permission_denied_exception.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_permission_permanently_denied_exception.dart';
import 'package:wallpost/attendance_punch_in_out/exception/location_services_disabled_exception.dart';
import 'package:wallpost/attendance_punch_in_out/services/attendance_details_provider.dart';
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

class MockAttendanceLocation extends Mock implements AttendanceLocation {}

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
    reset(mockPunchOutMarker);
    registerFallbackValue(MockAttendanceDetails());
    registerFallbackValue(MockAttendanceLocation());
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(detailView);
    verifyNoMoreInteractions(mockAttendanceDetailsProvider);
    verifyNoMoreInteractions(mockLocationProvider);
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
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(false);
    when(() => attendance.secondsTillPunchIn).thenReturn(123);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));

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

  test("failure to punch in", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockPunchInMarker.punchIn(any(), isLocationValid: true))
        .thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.loadAttendanceDetails();

    //when
    await presenter.markPunchIn(isLocationValid: true);

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
      () => mockPunchInMarker.punchIn(any(), isLocationValid: true),
      () => view.showAddress("address"),
      () => view.showErrorMessage('Punch in failed', InvalidResponseException().userReadableMessage),
    ]);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("shows alert to punch in with invalid location when mark punch in", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockPunchInMarker.punchIn(any(), isLocationValid: false))
        .thenAnswer((_) => Future.error(ServerSentException("", 0)));
    await presenter.loadAttendanceDetails();

    //when
    await presenter.markPunchIn(isLocationValid: false);

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
      () => mockPunchInMarker.punchIn(any(), isLocationValid: false),
      () => view.showAddress("address"),
      () => view.showAlertToMarkAttendanceWithInvalidLocation(
          true, 'Invalid location', ServerSentException("", 0).userReadableMessage),
    ]);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("successfully punched in with valid location", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendance.canMarkAttendancePermissionFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockPunchInMarker.punchIn(any(), isLocationValid: true)).thenAnswer((_) => Future.value());
    await presenter.loadAttendanceDetails();

    //when
    await presenter.markPunchIn(isLocationValid: true);

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
      () => mockPunchInMarker.punchIn(any(), isLocationValid: true),
      () => view.showAddress("address"),
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
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isNotPunchedIn).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(true);
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
      () => detailView.showResumeButton(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("failure to punch out", () async {
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
    when(() => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true))
        .thenAnswer((_) => Future.error(InvalidResponseException()));
    await presenter.loadAttendanceDetails();

    // when
    await presenter.markPunchOut(isLocationValid: true);

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
      () => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true),
      () => view.showAddress(""),
      () => view.showErrorMessage('Punch out failed', InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("shows alert to punch out with invalid location when mark punch out ", () async {
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
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: false))
        .thenAnswer((_) => Future.error(ServerSentException("", 0)));

    await presenter.loadAttendanceDetails();

    // when
    await presenter.markPunchOut(isLocationValid: false);

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
      () => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: false),
      () => view.showAddress("address"),
      () => view.showAlertToMarkAttendanceWithInvalidLocation(
          false, 'Invalid location', ServerSentException("", 0).userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("successfully punched out when the location is valid", () async {
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
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true)).thenAnswer((_) => Future.value());

    await presenter.loadAttendanceDetails();

    // when
    await presenter.markPunchOut(isLocationValid: true);

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
      () => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true),
      () => view.showAddress("address"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("shows punch in and out time and remaining time to punch in  when after punch out", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedOut).thenReturn(true);
    when(() => attendance.isPunchedIn).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(false);
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
      () => detailView.showPunchInTime(punchInTime),
      () => detailView.showPunchOutTime(punchOutTime),
      () => detailView.hideBreakButton(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

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
