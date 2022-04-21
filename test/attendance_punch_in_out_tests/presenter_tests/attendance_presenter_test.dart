// import 'package:flutter_test/flutter_test.dart';
// import 'package:intl/intl.dart';
// import 'package:mocktail/mocktail.dart';
// import 'package:wallpost/attendance/entities/attendance_details.dart';
// import 'package:wallpost/attendance/entities/attendance_location.dart';
// import 'package:wallpost/attendance/entities/punch_in_from_app_permission.dart';
// import 'package:wallpost/attendance/entities/punch_in_now_permission.dart';
// import 'package:wallpost/attendance/exception/location_acquisition_failed_exception.dart';
// import 'package:wallpost/attendance/exception/location_permission_denied_exception.dart';
// import 'package:wallpost/attendance/exception/location_permission_permanently_denied_exception.dart';
// import 'package:wallpost/attendance/exception/location_services_disabled_exception.dart';
// import 'package:wallpost/attendance/services/attendance_details_provider.dart';
// import 'package:wallpost/attendance/services/attendance_location_validator.dart';
// import 'package:wallpost/attendance/services/attendance_report_provider.dart';
// import 'package:wallpost/attendance/services/break_end_marker.dart';
// import 'package:wallpost/attendance/services/break_start_marker.dart';
// import 'package:wallpost/attendance/services/location_provider.dart';
// import 'package:wallpost/attendance/services/punch_in_from_app_permission_provider.dart';
// import 'package:wallpost/attendance/services/punch_in_marker.dart';
// import 'package:wallpost/attendance/services/punch_in_now_permission_provider.dart';
// import 'package:wallpost/attendance/services/punch_out_marker.dart';
// import 'package:wallpost/attendance/ui/view_contracts/attendance_view.dart';
// import 'package:wallpost/attendance/ui/presenters/attendance_presenter.dart';
//
// import '../../_mocks/mock_network_adapter.dart';
//
// class MockAttendanceView extends Mock implements AttendanceView {}
//
// class MockAttendanceDetailsProvider extends Mock
//     implements AttendanceDetailsProvider {}
//
// class MockPunchInNowPermissionProvider extends Mock
//     implements PunchInNowPermissionProvider {}
//
// class MockLocationProvider extends Mock implements LocationProvider {}
//
// class MockPunchInFromAppPermissionProvider extends Mock
//     implements PunchInFromAppPermissionProvider {}
//
// class MockAttendanceDetails extends Mock implements AttendanceDetails {}
//
// class MockPunchInFromAppPermission extends Mock
//     implements PunchInFromAppPermission {}
//
// class MockPunchInNowPermission extends Mock implements PunchInNowPermission {}
//
// class MockAttendanceLocation extends Mock implements AttendanceLocation {}
//
// class MockAttendanceLocationValidator extends Mock
//     implements AttendanceLocationValidator {}
//
// class MockAttendanceReportProvider extends Mock
//     implements AttendanceReportProvider {}
//
// class MockPunchInMarker extends Mock implements PunchInMarker {}
//
// class MockPunchOutMarker extends Mock implements PunchOutMarker {}
//
// class MockBreakStartMarker extends Mock implements BreakStartMarker {}
//
// class MockBreakEndMarker extends Mock implements BreakEndMarker {}
//
// void main() {
//   var view = MockAttendanceView();
//   var mockAttendanceDetailsProvider = MockAttendanceDetailsProvider();
//   var mockLocationProvider = MockLocationProvider();
//   var mockPunchInFromAppPermissionProvider =
//       MockPunchInFromAppPermissionProvider();
//   var mockPunchInNowPermissionProvider = MockPunchInNowPermissionProvider();
//   var mockAttendanceLocationValidator = MockAttendanceLocationValidator();
//   var mockPunchInMarker = MockPunchInMarker();
//   var mockPunchOutMarker = MockPunchOutMarker();
//   var mockBreakStartMaker = MockBreakStartMarker();
//   var mocKBreakEndMarker = MockBreakEndMarker();
//   var mockAttendanveReportProvider = MockAttendanceReportProvider();
//
//   AttendancePresenter presenter = AttendancePresenter.initWith(
//       view,
//       mockAttendanceDetailsProvider,
//       mockLocationProvider,
//       mockPunchInFromAppPermissionProvider,
//       mockPunchInNowPermissionProvider,
//       mockAttendanceLocationValidator,
//       mockPunchInMarker,
//       mockPunchOutMarker,
//       mockBreakStartMaker,
//       mocKBreakEndMarker,
//       mockAttendanveReportProvider);
//
//   setUp(() {
//     reset(view);
//     reset(mockAttendanceDetailsProvider);
//     //  reset(mockLocationProvider);
//     reset(mockPunchInFromAppPermissionProvider);
//     reset(mockPunchInNowPermissionProvider);
//     reset(mockAttendanceLocationValidator);
//     reset(mockPunchOutMarker);
//     registerFallbackValue(MockAttendanceDetails());
//     registerFallbackValue(MockAttendanceLocation());
//   });
//
//   void _verifyNoMoreInteractionsOnAllMocks() {
//     verifyNoMoreInteractions(view);
//     verifyNoMoreInteractions(mockAttendanceDetailsProvider);
//     verifyNoMoreInteractions(mockLocationProvider);
//     verifyNoMoreInteractions(mockPunchInFromAppPermissionProvider);
//     verifyNoMoreInteractions(mockPunchInNowPermissionProvider);
//     verifyNoMoreInteractions(mockAttendanceLocationValidator);
//     verifyNoMoreInteractions(mockPunchOutMarker);
//   }
//
//   test('failure to load attendance details', () async {
//     //given
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.error(InvalidResponseException()));
//
//     //when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => view.hideLoader(),
//       () => view.showDisabledButton(),
//       () => view.showErrorMessage("Loading attendance details failed",
//           InvalidResponseException().userReadableMessage),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("loading attendance details successfully", () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var attendanceLocation = MockAttendanceLocation();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(true);
//     when(() => attendance.isPunchedOut).thenReturn(false);
//     when(() => attendance.isOnBreak).thenReturn(false);
//     var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
//     when(() => attendance.punchInTimeString).thenReturn(punchInTime);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//     // when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => view.hideLoader(),
//       () => view.showPunchInTime(punchInTime),
//       () => view.showPunchOutButton(),
//       () => view.showBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test(
//       'shows disabled button when the user is not punched in and getting the punch in from app permission fails',
//       () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(true);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.error(InvalidResponseException()));
//
//     // when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => view.hideLoader(),
//       () => view.showDisabledButton(),
//       () => view.showErrorMessage("Failed to load punch in from app permission",
//           InvalidResponseException().userReadableMessage)
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test(
//       "shows disabled button when the user is not punched in and is not allowed to punch in from app",
//       () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(false);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.value(appPermission));
//
//     // when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => view.hideLoader(),
//       () => view.showDisabledButton(),
//       () => view.hideBreakButton(),
//       () => view.showError("Punch in from app disabled",
//           "Looks like you are not allowed to punch in from the app. Please contact your HR to resolve this issue.")
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test(
//       "shows disabled button when the user is not punched in and getting the punch in now permission fails",
//       () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     var punchInNowPermission = MockPunchInNowPermission();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(true);
//     when(() => punchInNowPermission.canPunchInNow).thenReturn(false);
//     when(() => punchInNowPermission.secondsTillPunchIn).thenReturn(123);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.value(appPermission));
//     when(() => mockPunchInNowPermissionProvider.canPunchInNow())
//         .thenAnswer((_) => Future.error(InvalidResponseException()));
//
//     // when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => mockPunchInNowPermissionProvider.canPunchInNow(),
//       () => view.hideLoader(),
//       () => view.showDisabledButton(),
//       () => view.showErrorMessage("Failed to load punch in permission",
//           InvalidResponseException().userReadableMessage)
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test(
//       "shows disabled button and shows remaining time to punch in  when the user is not punched in and cannot punch in now",
//       () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     var punchInNowPermission = MockPunchInNowPermission();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(true);
//     when(() => punchInNowPermission.canPunchInNow).thenReturn(false);
//     when(() => punchInNowPermission.secondsTillPunchIn).thenReturn(123);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.value(appPermission));
//     when(() => mockPunchInNowPermissionProvider.canPunchInNow())
//         .thenAnswer((_) => Future.value(punchInNowPermission));
//
//     // when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => mockPunchInNowPermissionProvider.canPunchInNow(),
//       () => view.hideLoader(),
//       () => view.showDisabledButton(),
//       () => view.hideBreakButton(),
//       () => view.showTimeTillPunchIn(123)
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('shows alert if gps is not enabled', () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     var punchInNowPermission = MockPunchInNowPermission();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(true);
//     when(() => punchInNowPermission.canPunchInNow).thenReturn(true);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.value(appPermission));
//     when(() => mockPunchInNowPermissionProvider.canPunchInNow())
//         .thenAnswer((_) => Future.value(punchInNowPermission));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.error(LocationServicesDisabledException()));
//
//     //when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => mockPunchInNowPermissionProvider.canPunchInNow(),
//       () => view.hideLoader(),
//       () => view.showPunchInButton(),
//       () => view.hideBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.requestToTurnOnDeviceLocation(
//           LocationServicesDisabledException().userReadableMessage,
//           "Please make sure you enable GPS"),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('shows alert when the location permission is denied', () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     var punchInNowPermission = MockPunchInNowPermission();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(true);
//     when(() => punchInNowPermission.canPunchInNow).thenReturn(true);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.value(appPermission));
//     when(() => mockPunchInNowPermissionProvider.canPunchInNow())
//         .thenAnswer((_) => Future.value(punchInNowPermission));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.error(LocationPermissionsDeniedException()));
//
//     //when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => mockPunchInNowPermissionProvider.canPunchInNow(),
//       () => view.hideLoader(),
//       () => view.showPunchInButton(),
//       () => view.hideBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.requestToLocationPermissions(
//           LocationPermissionsDeniedException().userReadableMessage,
//           "Please allow to access device location"),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('go to app settings when the location permission is permanently denied',
//       () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     var punchInNowPermission = MockPunchInNowPermission();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(true);
//     when(() => punchInNowPermission.canPunchInNow).thenReturn(true);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.value(appPermission));
//     when(() => mockPunchInNowPermissionProvider.canPunchInNow())
//         .thenAnswer((_) => Future.value(punchInNowPermission));
//     when(() => mockLocationProvider.getLocation()).thenAnswer(
//         (_) => Future.error(LocationPermissionsPermanentlyDeniedException()));
//
//     //when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => mockPunchInNowPermissionProvider.canPunchInNow(),
//       () => view.hideLoader(),
//       () => view.showPunchInButton(),
//       () => view.hideBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.openAppSettings(),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test('failure to get location', () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     var punchInNowPermission = MockPunchInNowPermission();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(true);
//     when(() => punchInNowPermission.canPunchInNow).thenReturn(true);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.value(appPermission));
//     when(() => mockPunchInNowPermissionProvider.canPunchInNow())
//         .thenAnswer((_) => Future.value(punchInNowPermission));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.error(LocationAcquisitionFailedException()));
//
//     //when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => mockPunchInNowPermissionProvider.canPunchInNow(),
//       () => view.hideLoader(),
//       () => view.showPunchInButton(),
//       () => view.hideBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showErrorMessage("Getting location failed",
//           LocationAcquisitionFailedException().userReadableMessage),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test(
//       "shows punch in button when the user is not punched in and can punch in now",
//       () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     var punchInNowPermission = MockPunchInNowPermission();
//     var attendanceLocation = MockAttendanceLocation();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(true);
//     when(() => punchInNowPermission.canPunchInNow).thenReturn(true);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.value(appPermission));
//     when(() => mockPunchInNowPermissionProvider.canPunchInNow())
//         .thenAnswer((_) => Future.value(punchInNowPermission));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//     // when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => mockPunchInNowPermissionProvider.canPunchInNow(),
//       () => view.hideLoader(),
//       () => view.showPunchInButton(),
//       () => view.hideBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("show alert when failed to validate location for punch in", () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     var punchInNowPermission = MockPunchInNowPermission();
//     var attendanceLocation = MockAttendanceLocation();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(true);
//     when(() => punchInNowPermission.canPunchInNow).thenReturn(true);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.value(appPermission));
//     when(() => mockPunchInNowPermissionProvider.canPunchInNow())
//         .thenAnswer((_) => Future.value(punchInNowPermission));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//     when(() => mockAttendanceLocationValidator.validateLocation(any(),
//             isForPunchIn: true))
//         .thenAnswer((_) => Future.error(InvalidResponseException()));
//     await presenter.loadAttendanceDetails();
//
//     //when
//     await presenter.validateLocation(true);
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => mockPunchInNowPermissionProvider.canPunchInNow(),
//       () => view.hideLoader(),
//       () => view.showPunchInButton(),
//       () => view.hideBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//       () => mockAttendanceLocationValidator.validateLocation(any(),
//           isForPunchIn: true),
//       () => view.showErrorMessage("Failed to validate your location",
//           InvalidResponseException().userReadableMessage),
//     ]);
//
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("failure to punch in", () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     var punchInNowPermission = MockPunchInNowPermission();
//     var attendanceLocation = MockAttendanceLocation();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(true);
//     when(() => punchInNowPermission.canPunchInNow).thenReturn(true);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.value(appPermission));
//     when(() => mockPunchInNowPermissionProvider.canPunchInNow())
//         .thenAnswer((_) => Future.value(punchInNowPermission));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//     when(() => mockAttendanceLocationValidator.validateLocation(any(),
//         isForPunchIn: true)).thenAnswer((_) => Future.value(true));
//     when(() => mockPunchInMarker.punchIn(any(), isLocationValid: true))
//         .thenAnswer((_) => Future.error(InvalidResponseException()));
//     await presenter.loadAttendanceDetails();
//
//     //when
//     await presenter.validateLocation(true);
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => mockPunchInNowPermissionProvider.canPunchInNow(),
//       () => view.hideLoader(),
//       () => view.showPunchInButton(),
//       () => view.hideBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//       () => mockAttendanceLocationValidator.validateLocation(any(),
//           isForPunchIn: true),
//       () => mockPunchInMarker.punchIn(any(), isLocationValid: true),
//       () => view.showErrorMessage(
//           'Punched in failed', InvalidResponseException().userReadableMessage),
//     ]);
//
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("successfully punched in with invalid location", () async {
//     //given
//
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     var punchInNowPermission = MockPunchInNowPermission();
//     var attendanceLocation = MockAttendanceLocation();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(true);
//     when(() => punchInNowPermission.canPunchInNow).thenReturn(true);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.value(appPermission));
//     when(() => mockPunchInNowPermissionProvider.canPunchInNow())
//         .thenAnswer((_) => Future.value(punchInNowPermission));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//     when(() => mockAttendanceLocationValidator.validateLocation(any(),
//         isForPunchIn: true)).thenAnswer((_) => Future.value(false));
//     when(() => mockPunchInMarker.punchIn(any(), isLocationValid: false))
//         .thenAnswer((_) => Future.value());
//     await presenter.loadAttendanceDetails();
//     await presenter.validateLocation(true);
//
//     //when
//     await presenter.doPunchIn(false);
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => mockPunchInNowPermissionProvider.canPunchInNow(),
//       () => view.hideLoader(),
//       () => view.showPunchInButton(),
//       () => view.hideBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//       () => mockAttendanceLocationValidator.validateLocation(any(),
//           isForPunchIn: true),
//       () => view.showAlertToInvalidLocation(
//           true,
//           'Invalid punch in location',
//           'You are not allowed to punch in outside the office location. '
//               'Doing so will affect your performance. Would you still like to punch in?'),
//       () => mockPunchInMarker.punchIn(any(), isLocationValid: false),
//       () => view.doRefresh()
//     ]);
//
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("successfully punched in with valid location", () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var appPermission = MockPunchInFromAppPermission();
//     var punchInNowPermission = MockPunchInNowPermission();
//     var attendanceLocation = MockAttendanceLocation();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(false);
//     when(() => appPermission.isAllowed).thenReturn(true);
//     when(() => punchInNowPermission.canPunchInNow).thenReturn(true);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockPunchInFromAppPermissionProvider.canPunchInFromApp())
//         .thenAnswer((_) => Future.value(appPermission));
//     when(() => mockPunchInNowPermissionProvider.canPunchInNow())
//         .thenAnswer((_) => Future.value(punchInNowPermission));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//     when(() => mockAttendanceLocationValidator.validateLocation(any(),
//         isForPunchIn: true)).thenAnswer((_) => Future.value(true));
//     when(() => mockPunchInMarker.punchIn(any(), isLocationValid: true))
//         .thenAnswer((_) => Future.value());
//     await presenter.loadAttendanceDetails();
//
//     //when
//     await presenter.validateLocation(true);
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => mockPunchInFromAppPermissionProvider.canPunchInFromApp(),
//       () => mockPunchInNowPermissionProvider.canPunchInNow(),
//       () => view.hideLoader(),
//       () => view.showPunchInButton(),
//       () => view.hideBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//       () => mockAttendanceLocationValidator.validateLocation(any(),
//           isForPunchIn: true),
//       () => mockPunchInMarker.punchIn(any(), isLocationValid: true),
//       () => view.doRefresh()
//     ]);
//
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test(
//       "shows enabled break button when the user is punched in and is not on break",
//       () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var attendanceLocation = MockAttendanceLocation();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(true);
//     when(() => attendance.isPunchedOut).thenReturn(false);
//     when(() => attendance.isOnBreak).thenReturn(false);
//     var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
//     when(() => attendance.punchInTimeString).thenReturn(punchInTime);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//
//     // when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => view.hideLoader(),
//       () => view.showPunchInTime(punchInTime),
//       () => view.showPunchOutButton(),
//       () => view.showBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("shows resume button when the user is on break", () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var attendanceLocation = MockAttendanceLocation();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(true);
//     when(() => attendance.isPunchedOut).thenReturn(false);
//     when(() => attendance.isOnBreak).thenReturn(true);
//     var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
//     when(() => attendance.punchInTimeString).thenReturn(punchInTime);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//
//     // when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => view.hideLoader(),
//       () => view.showPunchInTime(punchInTime),
//       () => view.showPunchOutButton(),
//       () => view.showResumeButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("shows punch out button when the user is punched in and not punched out",
//       () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var attendanceLocation = MockAttendanceLocation();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(true);
//     when(() => attendance.isPunchedOut).thenReturn(false);
//     when(() => attendance.isOnBreak).thenReturn(false);
//     var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
//     when(() => attendance.punchInTimeString).thenReturn(punchInTime);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//
//     // when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => view.hideLoader(),
//       () => view.showPunchInTime(punchInTime),
//       () => view.showPunchOutButton(),
//       () => view.showBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("show alert when failed to validate location for punch out", () async {
//     //given
//     var attendanceLocation = MockAttendanceLocation();
//     var attendance = MockAttendanceDetails();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(true);
//     when(() => attendance.isPunchedOut).thenReturn(false);
//     when(() => attendance.isOnBreak).thenReturn(false);
//     var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
//     when(() => attendance.punchInTimeString).thenReturn(punchInTime);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//     when(() => mockAttendanceLocationValidator.validateLocation(any(),
//             isForPunchIn: false))
//         .thenAnswer((_) => Future.error(InvalidResponseException()));
//     await presenter.loadAttendanceDetails();
//
//     // when
//     await presenter.validateLocation(false);
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => view.hideLoader(),
//       () => view.showPunchInTime(punchInTime),
//       () => view.showPunchOutButton(),
//       () => view.showBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//       () => mockAttendanceLocationValidator.validateLocation(any(),
//           isForPunchIn: false),
//       () => view.showErrorMessage("Failed to validate your location",
//           InvalidResponseException().userReadableMessage),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("failure to punch out", () async {
//     //given
//     var attendanceLocation = MockAttendanceLocation();
//     var attendance = MockAttendanceDetails();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(true);
//     when(() => attendance.isPunchedOut).thenReturn(false);
//     when(() => attendance.isOnBreak).thenReturn(false);
//     var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
//     when(() => attendance.punchInTimeString).thenReturn(punchInTime);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//     when(() => mockAttendanceLocationValidator.validateLocation(any(),
//         isForPunchIn: false)).thenAnswer((_) => Future.value(true));
//     when(() => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true))
//         .thenAnswer((_) => Future.error(InvalidResponseException()));
//     await presenter.loadAttendanceDetails();
//
//     // when
//     await presenter.validateLocation(false);
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => view.hideLoader(),
//       () => view.showPunchInTime(punchInTime),
//       () => view.showPunchOutButton(),
//       () => view.showBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//       () => mockAttendanceLocationValidator.validateLocation(any(),
//           isForPunchIn: false),
//       () => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true),
//       () => view.showErrorMessage(
//           'Punched out failed', InvalidResponseException().userReadableMessage),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("successfully punched out with invalid location", () async {
//     //given
//     var attendanceLocation = MockAttendanceLocation();
//     var attendance = MockAttendanceDetails();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(true);
//     when(() => attendance.isPunchedOut).thenReturn(false);
//     when(() => attendance.isOnBreak).thenReturn(false);
//     var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
//     when(() => attendance.punchInTimeString).thenReturn(punchInTime);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//     when(() => mockAttendanceLocationValidator.validateLocation(any(),
//         isForPunchIn: false)).thenAnswer((_) => Future.value(false));
//     when(() =>
//             mockPunchOutMarker.punchOut(any(), any(), isLocationValid: false))
//         .thenAnswer((_) => Future.value());
//     await presenter.loadAttendanceDetails();
//     await presenter.validateLocation(false);
//
//     // when
//     await presenter.doPunchOut(false);
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => view.hideLoader(),
//       () => view.showPunchInTime(punchInTime),
//       () => view.showPunchOutButton(),
//       () => view.showBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//       () => mockAttendanceLocationValidator.validateLocation(any(),
//           isForPunchIn: false),
//       () => view.showAlertToInvalidLocation(
//           false,
//           'Invalid punch out location',
//           'You are not allowed to punch out outside the office location. '
//               'Doing so will affect your performance. Would you still like to punch out?'),
//       () => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: false),
//       () => view.doRefresh()
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("successfully punched out when the location is valid", () async {
//     //given
//     var attendanceLocation = MockAttendanceLocation();
//     var attendance = MockAttendanceDetails();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(true);
//     when(() => attendance.isPunchedOut).thenReturn(false);
//     when(() => attendance.isOnBreak).thenReturn(false);
//     var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
//     when(() => attendance.punchInTimeString).thenReturn(punchInTime);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//     when(() => mockAttendanceLocationValidator.validateLocation(any(),
//         isForPunchIn: false)).thenAnswer((_) => Future.value(true));
//     when(() => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true))
//         .thenAnswer((_) => Future.value());
//     await presenter.loadAttendanceDetails();
//
//     // when
//     await presenter.validateLocation(false);
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => view.hideLoader(),
//       () => view.showPunchInTime(punchInTime),
//       () => view.showPunchOutButton(),
//       () => view.showBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//       () => mockAttendanceLocationValidator.validateLocation(any(),
//           isForPunchIn: false),
//       () => mockPunchOutMarker.punchOut(any(), any(), isLocationValid: true),
//       () => view.doRefresh()
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test(
//       "shows disabled button with punch in and punch out time after the user is punched out",
//       () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(true);
//     when(() => attendance.isPunchedOut).thenReturn(true);
//     var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
//     when(() => attendance.punchInTimeString).thenReturn(punchInTime);
//     String punchOutTime = inputFormat.parse('2021-09-02 18:00:00').toString();
//     when(() => attendance.punchOutTimeString).thenReturn(punchOutTime);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//
//     // when
//     await presenter.loadAttendanceDetails();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => view.hideLoader(),
//       () => view.showPunchInTime(punchInTime),
//       () => view.showPunchOutTime(punchOutTime),
//       () => view.showDisabledButton(),
//       () => view.hideBreakButton(),
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("show resume button when start break", () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var attendanceLocation = MockAttendanceLocation();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(true);
//     when(() => attendance.isPunchedOut).thenReturn(false);
//     when(() => attendance.isOnBreak).thenReturn(false);
//     var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
//     when(() => attendance.punchInTimeString).thenReturn(punchInTime);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//     when(() => mockBreakStartMaker.startBreak(any(), any()))
//         .thenAnswer((_) => Future.value());
//
//     await presenter.loadAttendanceDetails();
//
//     // when
//     await presenter.startBreak();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => view.hideLoader(),
//       () => view.showPunchInTime(punchInTime),
//       () => view.showPunchOutButton(),
//       () => view.showBreakButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//       () => mockBreakStartMaker.startBreak(any(), any()),
//       () => view.doRefresh(),
//       () => view.showResumeButton()
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
//
//   test("show break button when end break", () async {
//     //given
//     var attendance = MockAttendanceDetails();
//     var attendanceLocation = MockAttendanceLocation();
//     when(() => mockAttendanceDetailsProvider.isLoading).thenReturn(false);
//     when(() => attendance.isPunchedIn).thenReturn(true);
//     when(() => attendance.isPunchedOut).thenReturn(false);
//     when(() => attendance.isOnBreak).thenReturn(true);
//     var inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
//     String punchInTime = inputFormat.parse('2021-09-02 09:00:00').toString();
//     when(() => attendance.punchInTimeString).thenReturn(punchInTime);
//     when(() => mockAttendanceDetailsProvider.getDetails())
//         .thenAnswer((_) => Future.value(attendance));
//     when(() => mockLocationProvider.getLocation())
//         .thenAnswer((_) => Future.value(attendanceLocation));
//     when(() => mockLocationProvider.getLocationAddress(any()))
//         .thenAnswer((_) => Future.value("address"));
//     when(() => mocKBreakEndMarker.endBreak(any(), any()))
//         .thenAnswer((_) => Future.value());
//
//     await presenter.loadAttendanceDetails();
//
//     // when
//     await presenter.endBreak();
//
//     //then
//     verifyInOrder([
//       () => mockAttendanceDetailsProvider.isLoading,
//       () => view.showLoader(),
//       () => mockAttendanceDetailsProvider.getDetails(),
//       () => view.hideLoader(),
//       () => view.showPunchInTime(punchInTime),
//       () => view.showPunchOutButton(),
//       () => view.showResumeButton(),
//       () => mockLocationProvider.getLocation(),
//       () => view.showLocationPositions(attendanceLocation),
//       () => mockLocationProvider.getLocationAddress(any()),
//       () => view.showLocationAddress("address"),
//       () => mocKBreakEndMarker.endBreak(any(), any()),
//       () => view.showBreakButton()
//     ]);
//     _verifyNoMoreInteractionsOnAllMocks();
//   });
// }
//
// //When to get the location first
// // 1. user is not punched in (attendance details) and can punch in now + can punch in from app (call the two services)
// // 2. user is punched in
