import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance/entities/attendance_details.dart';
import 'package:wallpost/attendance/entities/attendance_location.dart';
import 'package:wallpost/attendance/entities/punch_in_from_app_permission.dart';
import 'package:wallpost/attendance/entities/punch_in_now_permission.dart';
import 'package:wallpost/attendance/services/attendance_details_provider.dart';
import 'package:wallpost/attendance/services/attendance_location_validator.dart';
import 'package:wallpost/attendance/services/location_provider.dart';
import 'package:wallpost/attendance/services/punch_in_from_app_permission_provider.dart';
import 'package:wallpost/attendance/services/punch_in_now_permission_provider.dart';
import 'package:wallpost/attendance/ui/contracts/attendance_view.dart';
import 'package:wallpost/attendance/ui/presenters/attendance_presenter.dart';

import '../../_mocks/mock_network_adapter.dart';

class MockAttendanceView extends Mock implements AttendanceView {}

class MockAttendanceDetailsProvider extends Mock implements AttendanceDetailsProvider {}

class MockPunchInNowPermissionProvider extends Mock implements PunchInNowPermissionProvider {}

class MockLocationProvider extends Mock implements LocationProvider {}

class MockPunchInFromAppPermissionProvider extends Mock implements PunchInFromAppPermissionProvider {}

class MockAttendanceDetails extends Mock implements AttendanceDetails {}

class MockPunchInFromAppPermission extends Mock implements PunchInFromAppPermission {}

class MockPunchInNowPermission extends Mock implements PunchInNowPermission {}

class MockAttendanceLocation extends Mock implements AttendanceLocation {}

class MockAttendanceLocationValidator extends Mock implements AttendanceLocationValidator {}

void main() {
  var view = MockAttendanceView();
  var mockAttendanceDetailsProvider = MockAttendanceDetailsProvider();
  var mockLocationProvider = MockLocationProvider();
  var mockPunchInFromAppPermissionProvider = MockPunchInFromAppPermissionProvider();
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
      () => view.hideLoader(),
      () => view.showDisableButton(),
      () => view.showFailedToLoadAttendance(
          "Loading attendance details failed", InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('shows disabled button when the user not punched in and getting the punch in from app permission fails',
      () async {
    //given
    var attendance = MockAttendanceDetails();
    var appPermission = MockPunchInFromAppPermission();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(false);
    when(() => appPermission.isAllowed).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp()).thenAnswer((_) => Future.value(appPermission));
    when(() => mockPunchInNowPermissionProvider.canPunchInNow())
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
      () => mockPunchInNowPermissionProvider.canPunchInNow(),
      () => view.hideLoader(),
      () => view.showDisableButton(),
      () => view.showFailedToGetPunchInPermission(
          "Failed to load punch in from app permission", InvalidResponseException().userReadableMessage)
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("shows disabled button when the user not punched in and is not allowed to punch in from app", () async {
    //given
    var attendance = MockAttendanceDetails();
    var appPermission = MockPunchInFromAppPermission();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(false);
    when(() => appPermission.isAllowed).thenReturn(false);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp()).thenAnswer((_) => Future.value(appPermission));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
      () => view.hideLoader(),
      () => view.showDisableButton(),
      () => view.hideBreakButton(),
      () => view.showError("Punch in from app disabled",
          "Looks like you are not allowed to punch in from the app. Please contact your HR to resolve this issue.")
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  /*

  //--------------------------------------------

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

    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => mockLocationProvider.getLocationAddress(any()),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showBreakButton(),
      () => view.showPunchOutButton()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("getLocationSuccessfully", () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);

    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => mockLocationProvider.getLocationAddress(any()),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showBreakButton(),
      () => view.showPunchOutButton()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failureToGetLocation', () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
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
      () => view.showFailedToGetLocation(
          "Getting location failed", LocationAcquisitionFailedException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('showAlertToTurnOnGps_whenLocationServiceDisabled', () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
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
      () => view.hideLoader(),
      () => view.showDisableButton(),
      () => view.showAlertToTurnOnDeviceLocation(
          "Please turn on device location", LocationServicesDisabledException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('showAlert_whenLocationPermissionsDenied', () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
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
      () => view.hideLoader(),
      () => view.showDisableButton(),
      () => view.showAlertToDeniedLocationPermission(
          "Please allow Location permission", LocationPermissionsDeniedException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('goToAppSetting_whenLocationPermissionsPermanentlyDenied', () async {
    //given
    var attendance = MockAttendanceDetails();
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
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
      () => view.hideLoader(),
      () => view.showDisableButton(),
      () => view.openAppSettings()
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('gettingPunchInAppPermission_whenFailGettingLocationAddress', () async {
    //given
    var attendance = MockAttendanceDetails();
    var appPermission = MockPunchInFromAppPermission();
    var punchInNowPermission = MockPunchInNowPermission();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);

    when(() => attendance.isPunchedIn).thenReturn(false);

    when(() => appPermission.isAllowed).thenReturn(true);

    when(() => punchInNowPermission.canPunchInNow).thenReturn(true);

    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockLocationProvider.getLocationAddress(any()))
        .thenAnswer((_) => Future.error(LocationReverseGeocodingException()));
    when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp()).thenAnswer((_) => Future.value(appPermission));
    when(() => mockPunchInNowPermissionProvider.canPunchInNow()).thenAnswer((_) => Future.value(punchInNowPermission));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => mockLocationProvider.getLocationAddress(any()),
      () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
      () => view.showLocationAddress(""),
      () => mockPunchInNowPermissionProvider.canPunchInNow(),
      () => view.hideLoader(),
      () => view.showPunchInButton(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("showPunchInButton_whenUserIsNotPunchIn_andAllowedToPunchInAppPermission_andCanPunchInNow", () async {
    //given
    var attendance = MockAttendanceDetails();
    var appPermission = MockPunchInFromAppPermission();
    var punchInNowPermission = MockPunchInNowPermission();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);

    when(() => attendance.isPunchedIn).thenReturn(false);

    when(() => appPermission.isAllowed).thenReturn(true);

    when(() => punchInNowPermission.canPunchInNow).thenReturn(true);

    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp()).thenAnswer((_) => Future.value(appPermission));
    when(() => mockPunchInNowPermissionProvider.canPunchInNow()).thenAnswer((_) => Future.value(punchInNowPermission));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => mockLocationProvider.getLocationAddress(any()),
      () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
      () => view.showLocationAddress("address"),
      () => mockPunchInNowPermissionProvider.canPunchInNow(),
      () => view.hideLoader(),
      () => view.showPunchInButton(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('showDisabledButton_whenTheUserIsNotPunchedIn_andGetPunchInFromAppPermissionFails', () async {
    //given
    var attendance = MockAttendanceDetails();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(false);

    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
        .thenAnswer((_) => Future.error(InvalidResponseException()));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => mockLocationProvider.getLocationAddress(any()),
      () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
      () => view.showLocationAddress("address"),
      () => view.hideLoader(),
      () => view.showDisableButton(),
      () => view.showFailedToGetPunchInFromAppPermission(
          "Loading punch in app permission failed", InvalidResponseException().userReadableMessage)
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("showRemainingTimeToPunchIn_whenUserIsNotPunchIn_andAllowedToPunchInAppPermission_butCannotPunchInNow",
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

    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp()).thenAnswer((_) => Future.value(appPermission));
    when(() => mockPunchInNowPermissionProvider.canPunchInNow()).thenAnswer((_) => Future.value(punchInNowPermission));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => mockLocationProvider.getLocationAddress(any()),
      () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
      () => view.showLocationAddress("address"),
      () => mockPunchInNowPermissionProvider.canPunchInNow(),
      () => view.hideLoader(),
      () => view.showDisableButton(),
      () => view.hideBreakButton(),
      () => view.showSecondTillPunchIn("123")
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  // IS PUNCH IN _YES

  test("hideBreakButtonAndShowPunchOutTime_afterUserIsPunchOut ", () async {
    //given
    var attendance = MockAttendanceDetails();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(true);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchOutTime = inputFormat.parse('2021-09-02 18:00:00').toString();
    when(() => attendance.punchOutTimeString).thenReturn(punchOutTime);

    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => mockLocationProvider.getLocationAddress(any()),
      () => view.hideLoader(),
      () => view.hideBreakButton(),
      () => view.showPunchOutTime(punchOutTime)
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("showResumeButton_whenTheUserIsOnBreak", () async {
    //given
    var attendance = MockAttendanceDetails();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(true);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);

    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => mockLocationProvider.getLocationAddress(any()),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showResumeButton(),
      () => view.showPunchOutButton(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("showEnabledBreakButton_whenTheUserIsPunchIn_andIsNotOnBreak", () async {
    //given
    var attendance = MockAttendanceDetails();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);

    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => mockLocationProvider.getLocationAddress(any()),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showBreakButton(),
      () => view.showPunchOutButton(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("showPunchOuButton_whenTheUserIsPunchIn_andNotPunchOut ", () async {
    //given
    var attendance = MockAttendanceDetails();

    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => attendance.isPunchedIn).thenReturn(true);
    when(() => attendance.isPunchedOut).thenReturn(false);
    when(() => attendance.isOnBreak).thenReturn(false);

    var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
    String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
    when(() => attendance.punchInTimeString).thenReturn(punchInTime);

    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => mockLocationProvider.getLocationAddress(any()),
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

    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: true))
        .thenAnswer((_) => Future.value(true));
    await presenter.loadAttendanceDetails();
    // when
    await presenter.doPunchOut();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => mockLocationProvider.getLocationAddress(any()),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showBreakButton(),
      () => view.showPunchOutButton(),
      () => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: true),
      () => view.showLocationAddress("address"),
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

    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer((_) => Future.value(attendance));
    when(() => mockLocationProvider.getLocation()).thenAnswer((_) => Future.value(MockAttendanceLocation()));
    when(() => mockLocationProvider.getLocationAddress(any())).thenAnswer((_) => Future.value("address"));
    when(() => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: true))
        .thenAnswer((_) => Future.value(false));
    await presenter.loadAttendanceDetails();
    // when
    await presenter.doPunchOut();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => mockLocationProvider.getLocation(),
      () => mockLocationProvider.getLocationAddress(any()),
      () => view.hideLoader(),
      () => view.showPunchInTime(punchInTime),
      () => view.showBreakButton(),
      () => view.showPunchOutButton(),
      () => mockAttendanceLocationValidator.validateLocation(any(), isForPunchIn: true),
      () => view.showLocationAddress("address"),
      () => view.showAlertToVerifyLocation("location is not valid")
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

   */
}

//When to get the location first
// 1. user is not punched in (attendance details) and can punch in now + can punch in from app (call the two services)
// 2. user is punched in
