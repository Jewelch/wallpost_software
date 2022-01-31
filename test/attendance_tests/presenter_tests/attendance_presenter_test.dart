import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance/entities/attendance_details.dart';
import 'package:wallpost/attendance/entities/attendance_location.dart';
import 'package:wallpost/attendance/entities/punch_in_from_app_permission.dart';
import 'package:wallpost/attendance/entities/punch_in_now_permission.dart';
import 'package:wallpost/attendance/exception/location_acquisition_failed_exception.dart';
import 'package:wallpost/attendance/services/attendance_details_provider.dart';
import 'package:wallpost/attendance/services/attendance_location_validator.dart';
import 'package:wallpost/attendance/services/location_provider.dart';
import 'package:wallpost/attendance/services/punch_in_from_app_permission_provider.dart';
import 'package:wallpost/attendance/services/punch_in_now_permission_provider.dart';
import 'package:wallpost/attendance/ui/contracts/attendance_view.dart';
import 'package:wallpost/attendance/ui/presenters/attendance_presenter.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockAttendanceView extends Mock implements AttendanceView {}

class MockAttendanceDetailsProvider extends Mock
    implements AttendanceDetailsProvider {}

class MockPunchInNowPermissionProvider extends Mock
    implements PunchInNowPermissionProvider {}

class MockLocationProvider extends Mock implements LocationProvider {}

class MockPunchInFromAppPermissionProvider extends Mock
    implements PunchInFromAppPermissionProvider {}

class MockAttendanceDetails extends Mock implements AttendanceDetails {}

class MockPunchInFromAppPermission extends Mock
    implements PunchInFromAppPermission {}

class MockPunchInNowPermission extends Mock implements PunchInNowPermission {}

class MockAttendanceLocation extends Mock implements AttendanceLocation {}

class MockAttendanceLocationValidator extends Mock
    implements AttendanceLocationValidator {}

void main() {
  var view = MockAttendanceView();
  var mockAttendanceDetailsProvider = MockAttendanceDetailsProvider();
  var mockLocationProvider = MockLocationProvider();
  var mockPunchInFromAppPermissionProvider =
      MockPunchInFromAppPermissionProvider();
  var mockPunchInNowPermissionProvider = MockPunchInNowPermissionProvider();
  var mockAttendanceLocationValidator = MockAttendanceLocationValidator();

  AttendancePresenter presenter = AttendancePresenter.initWith(
      view,
      mockAttendanceDetailsProvider,
      mockLocationProvider,
      mockPunchInFromAppPermissionProvider,
      mockPunchInNowPermissionProvider,
      mockAttendanceLocationValidator);

  setUp(() {
    reset(view);
    reset(mockAttendanceDetailsProvider);
    reset(mockLocationProvider);
    reset(mockPunchInFromAppPermissionProvider);
    reset(mockPunchInNowPermissionProvider);
    registerFallbackValue(MockAttendanceLocation());
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(mockAttendanceDetailsProvider);
    verifyNoMoreInteractions(mockLocationProvider);
    verifyNoMoreInteractions(mockPunchInFromAppPermissionProvider);
    verifyNoMoreInteractions(mockPunchInNowPermissionProvider);
  }

  test("loading attendance details successfully", () async {
    //given

    var attendance = MockAttendanceDetails();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockAttendanceLocation()));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showBreakButton(),
      () => view.showPunchOutButton()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to loading attendance details', () async {
    //given
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    //when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => view.hideLoader(),
      () => view.showDisableButton(),
      () => view.showFailedToLoadAttendance("Loading attendance details failed",
          InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("get location successfully", () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockAttendanceLocation()));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showBreakButton(),
      () => view.showPunchOutButton()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to get location', () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.error(LocationAcquisitionFailedException()));

    //when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.hideLoader(),
      () => view.showDisableButton(),
      () => view.showFailedToGetLocation("Getting location failed",
          LocationAcquisitionFailedException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      "show punch in button when user not punch in and  allowed to punch in app permission also can punch in now",
      () async {
    //given
    var attendance = MockAttendanceDetails();
    var appPermission = MockPunchInFromAppPermission();
    var punchInNowPermission = MockPunchInNowPermission();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);

    when(() => attendance.isPunchedIn).thenReturn(false);

    when(() => appPermission.isAllowed).thenReturn(true);

    when(() => punchInNowPermission.canPunchInNow).thenReturn(true);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
        .thenAnswer((_) => Future.value(appPermission));
    when(() => mockPunchInNowPermissionProvider.canPunchInNow())
        .thenAnswer((_) => Future.value(punchInNowPermission));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.hideLoader(),
      () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
      () => mockPunchInNowPermissionProvider.canPunchInNow(),
      () => view.showPunchInButton()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      "show disable button when user not punch in and not allowed to punch in app permission ",
      () async {
    //given

    var attendance = MockAttendanceDetails();
    var appPermission = MockPunchInFromAppPermission();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(false);
    when(() => appPermission.isAllowed).thenReturn(false);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
        .thenAnswer((_) => Future.value(appPermission));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.hideLoader(),
      () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
      () => view.showDisableButton(),
      () => view.hideBreakButton(),
      () => view
          .showMessageToAllowPunchInFromAppPermission("Allow app permission")
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      "show remaining time to punch in when user not punch in and  allowed to punch in app permission but cannot punch in now",
      () async {
    //given
    var attendance = MockAttendanceDetails();
    var appPermission = MockPunchInFromAppPermission();
    var punchInNowPermission = MockPunchInNowPermission();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(false);
    when(() => appPermission.isAllowed).thenReturn(true);
    when(() => punchInNowPermission.canPunchInNow).thenReturn(false);
    when(() => punchInNowPermission.secondsTillPunchIn).thenReturn(123);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
        .thenAnswer((_) => Future.value(appPermission));
    when(() => mockPunchInNowPermissionProvider.canPunchInNow())
        .thenAnswer((_) => Future.value(punchInNowPermission));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.hideLoader(),
      () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
      () => mockPunchInNowPermissionProvider.canPunchInNow(),
      () => view.showDisableButton(),
      () => view.hideBreakButton(),
      () => view.showSecondTillPunchIn("123")
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  // IS PUNCH IN _YES

  test("hide break button and show punch out time after user is punch out ",
      () async {
    //given
    var attendance = MockAttendanceDetails();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(true);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchOutTime = inputFormat.parse('2021-09-02 18:00:00').toString();
    when(() => attendance.punchOutTimeString).thenReturn(punchOutTime);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockAttendanceLocation()));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.hideLoader(),
      () => view.hideBreakButton(),
      () => view.showPunchOutTime(punchOutTime)
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("show resume button when the user is on break", () async {
    //given
    var attendance = MockAttendanceDetails();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(true);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockAttendanceLocation()));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showResumeButton(),
      () => view.showPunchOutButton(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      "show enabled break button when the user is not on break and user is punch in",
      () async {
    //given
    var attendance = MockAttendanceDetails();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockAttendanceLocation()));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showBreakButton(),
      () => view.showPunchOutButton(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("show punch out button when the user is punch in and not punch out ",
      () async {
    //given
    var attendance = MockAttendanceDetails();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockAttendanceLocation()));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showBreakButton(),
      () => view.showPunchOutButton(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("canPunchOut_WhenLocationIsValid_UserIsPunchIn_NotPunchOut", () async {
    //given

    var attendance = MockAttendanceDetails();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockAttendanceLocationValidator.validateLocation(any(),
        isForPunchIn: true)).thenAnswer((_) => Future.value(true));
    await presenter.loadAttendanceDetails();
    // when
    await presenter.doPunchOut();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showBreakButton(),
      () => view.showPunchOutButton(),
      () => mockAttendanceLocationValidator.validateLocation(any(),
          isForPunchIn: true),
      () => view.doPunchOut()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("showAlert_WhenLocationIsNotValid_UserIsPunchIn_NotPunchOut", () async {
    //given

    var attendance = MockAttendanceDetails();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockAttendanceLocationValidator.validateLocation(any(),
        isForPunchIn: true)).thenAnswer((_) => Future.value(false));
    await presenter.loadAttendanceDetails();
    // when
    await presenter.doPunchOut();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showBreakButton(),
      () => view.showPunchOutButton(),
      () => mockAttendanceLocationValidator.validateLocation(any(),
          isForPunchIn: true),
      () => view.showAlertToVerifyLocation("location is not valid")
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}

//When to get the location first
// 1. user is not punched in (attendance details) and can punch in now + can punch in from app (call the two services)
// 2. user is punched in
