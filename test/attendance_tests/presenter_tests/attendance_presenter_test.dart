import 'package:flutter_test/flutter_test.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/attendance/entities/attendance_details.dart';
import 'package:wallpost/attendance/entities/punch_in_from_app_permission.dart';
import 'package:wallpost/attendance/entities/punch_in_now_permission.dart';
import 'package:wallpost/attendance/services/attendance_details_provider.dart';
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

class MockPosition extends Mock implements Position {}

void main() {
  var view = MockAttendanceView();
  var mockAttendanceDetailsProvider = MockAttendanceDetailsProvider();
  var mockLocationProvider = MockLocationProvider();
  var mockPunchInFromAppPermissionProvider =
      MockPunchInFromAppPermissionProvider();
  var mockPunchInNowPermissionProvider = MockPunchInNowPermissionProvider();

  AttendancePresenter presenter = AttendancePresenter.initWith(
      view,
      mockAttendanceDetailsProvider,
      mockLocationProvider,
      mockPunchInFromAppPermissionProvider,
      mockPunchInNowPermissionProvider);

  setUpAll(() {
    reset(view);
    reset(mockAttendanceDetailsProvider);
    reset(mockLocationProvider);
    reset(mockPunchInFromAppPermissionProvider);
    reset(mockPunchInNowPermissionProvider);
    registerFallbackValue(MockPosition());
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
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(MockAttendanceDetails()));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockPosition()));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => view.hideLoader(),
      () => mockLocationProvider.getLocation(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to loading attendance details', () async {
    //given
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceDetailsProvider.getDetails()).thenAnswer(
      (_) => Future.error(InvalidResponseException()),
    );

    //when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => view.hideLoader(),
      () => view.showDisableButton(),
      () => view.showFailedToLoadAttendance("loading attendance details failed",
          InvalidResponseException().userReadableMessage),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("get location  successfully", () async {
    //given
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(MockAttendanceDetails()));

    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockPosition()));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => view.hideLoader(),
      () => mockLocationProvider.getLocation(),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test('failure to getting location', () async {
    //given
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(MockAttendanceDetails()));
    when(() => mockLocationProvider.getLocation()).thenThrow(
      (_) => null,
    );

    //when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => view.hideLoader(),
      () => mockLocationProvider.getLocation(),
      () => view.showDisableButton(),
      () => view.showFailedToGetLocation("Getting location failed"),
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });

  test(
      "show punch in button when user not punch in and  allowed to punch in app permission also can punch in now",
      () async {
    //given
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);

    when(() => MockAttendanceDetails().isPunchedIn).thenReturn(false);

    when(() => MockPunchInFromAppPermission().isAllowed).thenReturn(true);

    when(() => MockPunchInNowPermission().canPunchInNow).thenReturn(true);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(MockAttendanceDetails()));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockPosition()));
    when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
        .thenAnswer((_) => Future.value(MockPunchInFromAppPermission()));
    when(() => mockPunchInNowPermissionProvider.canPunchInNow())
        .thenAnswer((_) => Future.value(MockPunchInNowPermission()));

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => view.hideLoader(),
      () => mockLocationProvider.getLocation(),
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
    when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);

    when(() => MockAttendanceDetails().isPunchedIn).thenReturn(false);

    when(() => MockAttendanceDetails().isOnBreak).thenReturn(false);

    when(() => MockPunchInFromAppPermission().isAllowed).thenReturn(false);

    when(() => mockAttendanceDetailsProvider.getDetails())
        .thenAnswer((_) => Future.value(MockAttendanceDetails()));
    when(() => mockLocationProvider.getLocation())
        .thenAnswer((_) => Future.value(MockPosition()));

    when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
        .thenAnswer(
      (_) => Future.error(InvalidResponseException()),
    );

    // when
    await presenter.loadAttendanceDetails();

    //then
    verifyInOrder([
      () => mockAttendanceDetailsProvider.isLoading,
      () => view.showLoader(),
      () => mockAttendanceDetailsProvider.getDetails(),
      () => view.hideLoader(),
      () => mockLocationProvider.getLocation(),
      () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
      () => view.showDisableButton(),
      () => view.hideBreakButton(),
      () => view.showFailedToGetPunchInFromAppPermission(
          "Punch in from app permission failed")
    ]);
    _verifyNoMoreInteractionsOnAllMocks();
  });
}
