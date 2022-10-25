import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/device/device_settings.dart';
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
import 'package:wallpost/attendance/attendance_punch_in_out/ui/presenters/attendance_presenter.dart';
import 'package:wallpost/attendance/attendance_punch_in_out/ui/view_contracts/attendance_view.dart';

import '../../../_mocks/mock_network_adapter.dart';

class MockAttendanceView extends Mock implements AttendanceView {}

class MockAttendanceDetailsProvider extends Mock implements AttendanceDetailsProvider {}

class MockLocationProvider extends Mock implements LocationProvider {}

class MockAttendanceDetails extends Mock implements AttendanceDetails {}

class MockAttendanceLocation extends Mock implements AttendanceLocation {}

class MockPunchInMarker extends Mock implements PunchInMarker {}

class MockPunchOutMarker extends Mock implements PunchOutMarker {}

class MockBreakStartMarker extends Mock implements BreakStartMarker {}

class MockBreakEndMarker extends Mock implements BreakEndMarker {}

class MockDeviceSettings extends Mock implements DeviceSettings {}

void main() {
  var basicView = MockAttendanceView();
  var mockAttendanceDetailsProvider = MockAttendanceDetailsProvider();
  var mockLocationProvider = MockLocationProvider();
  var mockPunchInMarker = MockPunchInMarker();
  var mockPunchOutMarker = MockPunchOutMarker();
  var mockBreakStartMarker = MockBreakStartMarker();
  var mocKBreakEndMarker = MockBreakEndMarker();
  var mockDeviceSettings = MockDeviceSettings();

  AttendancePresenter presenter = AttendancePresenter.initWith(
      basicView,
      mockAttendanceDetailsProvider,
      mockLocationProvider,
      mockPunchInMarker,
      mockPunchOutMarker,
      mockBreakStartMarker,
      mocKBreakEndMarker,
      mockDeviceSettings);

  setUp(() {
    reset(basicView);
    reset(mockAttendanceDetailsProvider);
    reset(mockLocationProvider);
    reset(mockPunchOutMarker);
    registerFallbackValue(MockAttendanceDetails());
    registerFallbackValue(MockAttendanceLocation());
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(basicView);
    verifyNoMoreInteractions(mockAttendanceDetailsProvider);
    verifyNoMoreInteractions(mockLocationProvider);
    verifyNoMoreInteractions(mockPunchInMarker);
    verifyNoMoreInteractions(mockPunchOutMarker);
    verifyNoMoreInteractions(mockBreakStartMarker);
    verifyNoMoreInteractions(mocKBreakEndMarker);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(basicView);
    clearInteractions(mockAttendanceDetailsProvider);
    clearInteractions(mockLocationProvider);
    clearInteractions(mockPunchInMarker);
    clearInteractions(mockPunchOutMarker);
    clearInteractions(mockBreakStartMarker);
    clearInteractions(mocKBreakEndMarker);
  }

  test('test does nothing when the provider is loading', () async {
    //given
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(true);

    //when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to load attendance details', () async {
    //given
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => basicView.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => basicView.showErrorAndRetryView("Failed to load attendance details.\nTap here to reload."),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('after loading attendance details, shows error and retry button when the user cannot mark attendance from app',
      () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.canMarkAttendanceFromApp).thenReturn(false);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => basicView.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => basicView.showErrorAndRetryView(
          "You are not allowed to mark attendance from the app. Please contact HR or tap here to reload.")
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('after loading attendance details, shows time to punch in when the user cannot punch in now', () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(false);
    when(() => attendance.isPunchedOut).thenReturn(false);
    when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(false);
    when(() => attendance.secondsTillPunchIn).thenReturn(142);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => basicView.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => basicView.showCountDownView(142)
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  group('tests for loading location', () {
    test('shows request to turn on gps when location service is disabled', () async {
      //given
      var attendance = MockAttendanceDetails();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.isNotPunchedIn).thenReturn(true);
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation())
          .thenAnswer((_) => Future.error(LocationServicesDisabledException()));

      //when
      await presenter.loadAttendanceDetails();

      //then
      verifyInOrder([
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showRequestToTurnOnGpsView("Location service disabled.\nTap here to go to location settings."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('shows request to grant location permission when the location permission is denied', () async {
      //given
      var attendance = MockAttendanceDetails();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.isNotPunchedIn).thenReturn(true);
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation())
          .thenAnswer((_) => Future.error(LocationPermissionsDeniedException()));

      //when
      await presenter.loadAttendanceDetails();

      //then
      verifyInOrder([
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showErrorAndRetryView("Location permission denied.\nTap here to grant permission."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('show request to go to app settings when the location permission is permanently denied', () async {
      //given
      var attendance = MockAttendanceDetails();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isNotPunchedIn).thenReturn(true);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation())
          .thenAnswer((_) => Future.error(LocationPermissionsPermanentlyDeniedException()));

      //when
      await presenter.loadAttendanceDetails();

      //then
      verifyInOrder([
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showRequestToEnableLocationView("Location permission denied.\nTap here to go to settings."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('shows error message when location acquisition fails', () async {
      //given
      var attendance = MockAttendanceDetails();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.isNotPunchedIn).thenReturn(true);
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation())
          .thenAnswer((_) => Future.error(LocationAcquisitionFailedException()));

      //when
      await presenter.loadAttendanceDetails();

      //then
      verifyInOrder([
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showErrorAndRetryView("Failed to get location.\nTap here to reload."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("failure to get location address shows the latitude and longitude", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => attendanceLocation.latitude).thenReturn(11.4);
      when(() => attendanceLocation.longitude).thenReturn(34.2);
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isNotPunchedIn).thenReturn(true);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any()))
          .thenAnswer((_) => Future.error(LocationReverseGeocodingException()));

      // when
      await presenter.loadAttendanceDetails();

      //then
      verifyInOrder([
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showLocation(attendanceLocation, ""),
        () => basicView.showPunchInButton(),
        () => mockLocationProvider.getLocationAddress(attendanceLocation),
        () => basicView.showLocation(attendanceLocation, "11.4, 34.2"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  test("shows punch in button when the user is not punched in", () async {
    //given
    var attendance = MockAttendanceDetails();
    var attendanceLocation = MockAttendanceLocation();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isNotPunchedIn).thenReturn(true);
    when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => basicView.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => basicView.showLocation(attendanceLocation, ""),
      () => basicView.showPunchInButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
      () => basicView.showLocation(attendanceLocation, "some address"),
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
    when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
    when(() => attendance.canMarkAttendanceNow).thenReturn(true);
    when(() => attendance.punchInTimeString).thenReturn("09:00 AM");
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => basicView.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => basicView.showLocation(attendanceLocation, ""),
      () => basicView.showPunchOutButton(),
      () => mockLocationProvider.getLocationAddress(attendanceLocation),
      () => basicView.showLocation(attendanceLocation, "some address"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  group('punch in', () {
    test("punching in when the punch in marker is loading does nothing", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isNotPunchedIn).thenReturn(true);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
      when(() => mockPunchInMarker.isLoading).thenReturn(true);
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      //when
      await presenter.markPunchIn(isLocationValid: true);

      //then
      verifyInOrder([
        () => mockPunchInMarker.isLoading,
      ]);

      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("failure to punch in", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isNotPunchedIn).thenReturn(true);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
      when(() => mockPunchInMarker.isLoading).thenReturn(false);
      when(() => mockPunchInMarker.punchIn(any(), isLocationValid: true))
          .thenAnswer((_) => Future.error(InvalidResponseException()));
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      //when
      await presenter.markPunchIn(isLocationValid: true);

      //then
      verifyInOrder([
        () => mockPunchInMarker.isLoading,
        () => basicView.showAttendanceButtonLoader(),
        () => mockPunchInMarker.punchIn(any(), isLocationValid: true),
        () => basicView.showErrorAlert('Punch in failed', InvalidResponseException().userReadableMessage),
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showLocation(attendanceLocation, ""),
        () => basicView.showPunchInButton(),
        () => mockLocationProvider.getLocationAddress(attendanceLocation),
        () => basicView.showLocation(attendanceLocation, "address"),
      ]);

      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("shows alert when user tries to punch in with invalid location", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isNotPunchedIn).thenReturn(true);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
      when(() => mockPunchInMarker.isLoading).thenReturn(false);
      when(() => mockPunchInMarker.punchIn(any(), isLocationValid: false)).thenAnswer(
          (_) => Future.error(ServerSentException("Not allowed to punch in from outside the office location", 0)));
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      //when
      await presenter.markPunchIn(isLocationValid: false);

      //then
      verifyInOrder([
        () => mockPunchInMarker.isLoading,
        () => basicView.showAttendanceButtonLoader(),
        () => mockPunchInMarker.punchIn(any(), isLocationValid: false),
        () => basicView.showPunchInButton(),
        () => basicView.showAlertToMarkAttendanceWithInvalidLocation(
              true,
              'Invalid location',
              "Not allowed to punch in from outside the office location",
            ),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("successfully punching in with valid location", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isNotPunchedIn).thenReturn(true);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));
      when(() => mockPunchInMarker.isLoading).thenReturn(false);
      when(() => mockPunchInMarker.punchIn(any(), isLocationValid: true)).thenAnswer((_) => Future.value());
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      //when
      await presenter.markPunchIn(isLocationValid: true);

      //then
      verifyInOrder([
        () => mockPunchInMarker.isLoading,
        () => basicView.showAttendanceButtonLoader(),
        () => mockPunchInMarker.punchIn(any(), isLocationValid: true),
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showLocation(attendanceLocation, ""),
        () => basicView.showPunchInButton(),
        () => mockLocationProvider.getLocationAddress(attendanceLocation),
        () => basicView.showLocation(attendanceLocation, "some address"),
      ]);

      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('punch out', () {
    test("punching out when the punch out marker is loading does nothing", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isPunchedIn).thenReturn(true);
      when(() => attendance.isNotPunchedIn).thenReturn(false);
      when(() => attendance.isOnBreak).thenReturn(false);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.punchInTimeString).thenReturn("09:00 AM");
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));
      when(() => mockPunchOutMarker.isLoading).thenReturn(true);
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      // when
      await presenter.markPunchOut(isLocationValid: true);

      //then
      verifyInOrder([
        () => mockPunchOutMarker.isLoading,
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
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.punchInTimeString).thenReturn("09:00 AM");
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));
      when(() => mockPunchOutMarker.isLoading).thenReturn(false);
      when(() => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true))
          .thenAnswer((_) => Future.error(InvalidResponseException()));
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      // when
      await presenter.markPunchOut(isLocationValid: true);

      //then
      verifyInOrder([
        () => mockPunchOutMarker.isLoading,
        () => basicView.showAttendanceButtonLoader(),
        () => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true),
        () => basicView.showErrorAlert('Punch out failed', InvalidResponseException().userReadableMessage),
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showLocation(attendanceLocation, ""),
        () => basicView.showPunchOutButton(),
        () => mockLocationProvider.getLocationAddress(any()),
        () => basicView.showLocation(attendanceLocation, "some address"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("shows alert when user tries to punch out with invalid location", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isPunchedIn).thenReturn(true);
      when(() => attendance.isNotPunchedIn).thenReturn(false);
      when(() => attendance.isOnBreak).thenReturn(false);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.punchInTimeString).thenReturn("09:00 AM");
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));
      when(() => mockPunchOutMarker.isLoading).thenReturn(false);
      when(() => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: false)).thenAnswer(
          (_) => Future.error(ServerSentException("Not allowed to punch out from outside the office location", 0)));
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      // when
      await presenter.markPunchOut(isLocationValid: false);

      //then
      verifyInOrder([
        () => mockPunchOutMarker.isLoading,
        () => basicView.showAttendanceButtonLoader(),
        () => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: false),
        () => basicView.showPunchOutButton(),
        () => basicView.showAlertToMarkAttendanceWithInvalidLocation(
              false,
              'Invalid location',
              "Not allowed to punch out from outside the office location",
            ),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("successfully punching out with valid location", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isPunchedIn).thenReturn(true);
      when(() => attendance.isNotPunchedIn).thenReturn(false);
      when(() => attendance.isOnBreak).thenReturn(false);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.punchInTimeString).thenReturn("09:00 AM");
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));
      when(() => mockPunchOutMarker.isLoading).thenReturn(false);
      when(() => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true)).thenAnswer((_) => Future.value());
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      // when
      await presenter.markPunchOut(isLocationValid: true);

      //then
      verifyInOrder([
        () => mockPunchOutMarker.isLoading,
        () => basicView.showAttendanceButtonLoader(),
        () => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true),
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showLocation(attendanceLocation, ""),
        () => basicView.showPunchOutButton(),
        () => mockLocationProvider.getLocationAddress(any()),
        () => basicView.showLocation(attendanceLocation, "some address"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  // test("shows punch in and out time and remaining time to punch in after punch out", () async {
  //   //given
  //   var attendance = MockAttendanceDetails();
  //   var attendanceLocation = MockAttendanceLocation();
  //   when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
  //   when(() => attendance.isNotPunchedIn).thenReturn(false);
  //   when(() => attendance.isPunchedIn).thenReturn(false);
  //   when(() => attendance.isPunchedOut).thenReturn(true);
  //   when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
  //   when(() => attendance.canMarkAttendanceNow).thenReturn(false);
  //   when(() => attendance.secondsTillPunchIn).thenReturn(123);
  //   when(() => attendance.punchInTimeString).thenReturn("09:00 AM");
  //   when(() => attendance.punchOutTimeString).thenReturn("06:30 PM");
  //   when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
  //   when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
  //   when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value(""));
  //
  //   // when
  //   await presenter.loadAttendanceDetails();
  //
  //   //then
  //   verifyInOrder([
  //         () => mockAttendanceDetailsProvider.isLoading,
  //         () => basicView.showLoader(),
  //         () => mockAttendanceDetailsProvider.getDetails(),
  //         () => basicView.showCountDownView(123),
  //         () => mockLocationProvider.getLocation(),
  //         () => basicView.showLocation(attendanceLocation, ""),
  //         () => detailedView.showPunchInTime("09:00 AM"),
  //         () => detailedView.showPunchOutTime("06:30 PM"),
  //         () => detailedView.hideBreakButton(),
  //   ]);
  //   _verifyNoMoreInteractionsOnAllMocks();
  // });
//
  group('start break tests', () {
    test("does nothing if start break marker is loading", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isNotPunchedIn).thenReturn(false);
      when(() => attendance.isPunchedIn).thenReturn(true);
      when(() => attendance.isOnBreak).thenReturn(false);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.punchInTimeString).thenReturn("09:00 AM");
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));
      when(() => mockBreakStartMarker.isLoading).thenReturn(true);
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      // when
      await presenter.startBreak();

      //then
      verifyInOrder([
        () => mockBreakStartMarker.isLoading,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("failure to start break", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isNotPunchedIn).thenReturn(false);
      when(() => attendance.isPunchedIn).thenReturn(true);
      when(() => attendance.isOnBreak).thenReturn(false);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.punchInTimeString).thenReturn("09:00 AM");
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));
      when(() => mockBreakStartMarker.isLoading).thenReturn(false);
      when(() => mockBreakStartMarker.startBreak(any(), any()))
          .thenAnswer((_) => Future.error(InvalidResponseException()));
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      // when
      await presenter.startBreak();

      //then
      verifyInOrder([
        () => mockBreakStartMarker.isLoading,
        () => basicView.showButtonBreakLoader(),
        () => mockBreakStartMarker.startBreak(any(), any()),
        () => basicView.showErrorAlert("Failed to start break", InvalidResponseException().userReadableMessage),
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showLocation(attendanceLocation, ""),
        () => basicView.showPunchOutButton(),
        () => mockLocationProvider.getLocationAddress(any()),
        () => basicView.showLocation(attendanceLocation, "some address"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("successfully starting break", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isNotPunchedIn).thenReturn(false);
      when(() => attendance.isPunchedIn).thenReturn(true);
      when(() => attendance.isOnBreak).thenReturn(false);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.punchInTimeString).thenReturn("09:00 AM");
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));
      when(() => mockBreakStartMarker.isLoading).thenReturn(false);
      when(() => mockBreakStartMarker.startBreak(any(), any())).thenAnswer((_) => Future.value(null));
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      // when
      await presenter.startBreak();

      //then
      verifyInOrder([
        () => mockBreakStartMarker.isLoading,
        () => basicView.showButtonBreakLoader(),
        () => mockBreakStartMarker.startBreak(any(), any()),
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showLocation(attendanceLocation, ""),
        () => basicView.showPunchOutButton(),
        () => mockLocationProvider.getLocationAddress(any()),
        () => basicView.showLocation(attendanceLocation, "some address"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('end break tests', () {
    test("does nothing if end break marker is loading", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isNotPunchedIn).thenReturn(false);
      when(() => attendance.isPunchedIn).thenReturn(true);
      when(() => attendance.isOnBreak).thenReturn(true);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.punchInTimeString).thenReturn("09:00 AM");
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));
      when(() => mocKBreakEndMarker.isLoading).thenReturn(true);
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      // when
      await presenter.endBreak();

      //then
      verifyInOrder([
        () => mocKBreakEndMarker.isLoading,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("failure to end break", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isNotPunchedIn).thenReturn(false);
      when(() => attendance.isPunchedIn).thenReturn(true);
      when(() => attendance.isOnBreak).thenReturn(true);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.punchInTimeString).thenReturn("09:00 AM");
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));
      when(() => mocKBreakEndMarker.isLoading).thenReturn(false);
      when(() => mocKBreakEndMarker.endBreak(any(), any())).thenAnswer((_) => Future.error(InvalidResponseException()));
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      // when
      await presenter.endBreak();

      //then
      verifyInOrder([
        () => mocKBreakEndMarker.isLoading,
        () => basicView.showButtonBreakLoader(),
        () => mocKBreakEndMarker.endBreak(any(), any()),
        () => basicView.showErrorAlert("Failed to end break", InvalidResponseException().userReadableMessage),
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showLocation(attendanceLocation, ""),
        () => basicView.showPunchOutButton(),
        () => mockLocationProvider.getLocationAddress(any()),
        () => basicView.showLocation(attendanceLocation, "some address"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("successfully ending break", () async {
      //given
      var attendance = MockAttendanceDetails();
      var attendanceLocation = MockAttendanceLocation();
      when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
      when(() => attendance.isNotPunchedIn).thenReturn(false);
      when(() => attendance.isPunchedIn).thenReturn(true);
      when(() => attendance.isOnBreak).thenReturn(true);
      when(() => attendance.canMarkAttendanceFromApp).thenReturn(true);
      when(() => attendance.canMarkAttendanceNow).thenReturn(true);
      when(() => attendance.punchInTimeString).thenReturn("09:00 AM");
      when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
      when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(attendanceLocation));
      when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("some address"));
      when(() => mocKBreakEndMarker.isLoading).thenReturn(false);
      when(() => mocKBreakEndMarker.endBreak(any(), any())).thenAnswer((_) => Future.value(null));
      await presenter.loadAttendanceDetails();
      _clearInteractionsOnAllMocks();

      // when
      await presenter.endBreak();

      //then
      verifyInOrder([
        () => mocKBreakEndMarker.isLoading,
        () => basicView.showButtonBreakLoader(),
        () => mocKBreakEndMarker.endBreak(any(), any()),
        () => mockAttendanceDetailsProvider.isLoading,
        () => basicView.showLoader(),
        () => mockAttendanceDetailsProvider.getDetails(),
        () => mockLocationProvider.getLocation(),
        () => basicView.showLocation(attendanceLocation, ""),
        () => basicView.showPunchOutButton(),
        () => mockLocationProvider.getLocationAddress(any()),
        () => basicView.showLocation(attendanceLocation, "some address"),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group('tests for functions to go to settings', () {
    test('test go to location settings', () {
      //given
      when(() => mockDeviceSettings.goToLocationSettings()).thenAnswer((_) => Future.value(true));

      //when
      presenter.goToLocationSettings();

      //then
      verifyInOrder([
        () => mockDeviceSettings.goToLocationSettings(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('test go to app settings', () {
      //given
      when(() => mockDeviceSettings.goToAppSettings()).thenAnswer((_) => Future.value(true));

      //when
      presenter.goToAppSettings();

      //then
      verifyInOrder([
        () => mockDeviceSettings.goToAppSettings(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });
}
