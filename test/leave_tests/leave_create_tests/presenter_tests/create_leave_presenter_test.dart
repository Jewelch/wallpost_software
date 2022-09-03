import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/extensions/date_extensions.dart';
import 'package:wallpost/leave/leave_create/entities/leave_request_form.dart';
import 'package:wallpost/leave/leave_create/entities/leave_specs.dart';
import 'package:wallpost/leave/leave_create/entities/leave_type.dart';
import 'package:wallpost/leave/leave_create/services/leave_creator.dart';
import 'package:wallpost/leave/leave_create/services/leave_specs_provider.dart';
import 'package:wallpost/leave/leave_create/ui/presenters/create_leave_presenter.dart';
import 'package:wallpost/leave/leave_create/ui/view_contracts/create_leave_view.dart';

import '../../../_mocks/mock_file.dart';
import '../../../_mocks/mock_network_adapter.dart';

class MockLeaveType extends Mock implements LeaveType {}

class MockLeaveSpecs extends Mock implements LeaveSpecs {}

class MockCreateLeaveView extends Mock implements CreateLeaveView {}

class MockLeaveSpecsProvider extends Mock implements LeaveSpecsProvider {}

class MockLeaveCreator extends Mock implements LeaveCreator {}

void main() {
  late MockCreateLeaveView view;
  late MockLeaveSpecsProvider leaveSpecsProvider;
  late MockLeaveCreator requestCreator;
  late CreateLeavePresenter presenter;

  setUpAll(() {
    registerFallbackValue(LeaveRequestForm());
  });

  setUp(() {
    view = MockCreateLeaveView();
    leaveSpecsProvider = MockLeaveSpecsProvider();
    requestCreator = MockLeaveCreator();
    presenter = CreateLeavePresenter.initWith(view, leaveSpecsProvider, requestCreator);
  });

  void _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(view);
    verifyNoMoreInteractions(leaveSpecsProvider);
    verifyNoMoreInteractions(requestCreator);
  }

  void _clearInteractionsOnAllMocks() {
    clearInteractions(view);
    clearInteractions(leaveSpecsProvider);
    clearInteractions(requestCreator);
  }

  group('tests for loading leave specs', () {
    test('loading leave specs when the provider is loading does nothing', () async {
      //given
      when(() => leaveSpecsProvider.isLoading).thenReturn(true);

      //when
      await presenter.loadLeaveSpecs();

      //then
      verifyInOrder([
        () => leaveSpecsProvider.isLoading,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('failure to load leave specs', () async {
      //given
      when(() => leaveSpecsProvider.isLoading).thenReturn(false);
      when(() => leaveSpecsProvider.get()).thenAnswer((_) => Future.error(InvalidResponseException()));

      //when
      await presenter.loadLeaveSpecs();

      //then
      expect(presenter.getLoadLeaveSpecsError(),
          "${InvalidResponseException().userReadableMessage}\n\nTap here to reload.");
      verifyInOrder([
        () => leaveSpecsProvider.isLoading,
        () => view.showLeaveSpecsLoader(),
        () => leaveSpecsProvider.get(),
        () => view.onDidFailToLoadLeaveSpecs(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('successfully loading an empty list of leave types in leave specs', () async {
      //given
      var leaveSpecs = MockLeaveSpecs();
      when(() => leaveSpecs.leaveTypes).thenReturn([]);
      when(() => leaveSpecsProvider.isLoading).thenReturn(false);
      when(() => leaveSpecsProvider.get()).thenAnswer((_) => Future.value(leaveSpecs));

      //when
      await presenter.loadLeaveSpecs();

      //then
      expect(presenter.getLoadLeaveSpecsError(), "There are no leave types to show.\n\nTap here to reload.");
      verifyInOrder([
        () => leaveSpecsProvider.isLoading,
        () => view.showLeaveSpecsLoader(),
        () => leaveSpecsProvider.get(),
        () => view.onDidFailToLoadLeaveSpecs(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('successfully loading leave specs with leave types', () async {
      //given
      var leaveType1 = MockLeaveType();
      var leaveType2 = MockLeaveType();
      when(() => leaveType1.name).thenReturn("Leave Type 1");
      when(() => leaveType1.requiredMinimumPeriod).thenReturn(0);
      when(() => leaveType2.name).thenReturn("Leave Type 2");
      var leaveSpecs = MockLeaveSpecs();
      when(() => leaveSpecs.leaveTypes).thenReturn([leaveType1, leaveType2]);
      when(() => leaveSpecsProvider.isLoading).thenReturn(false);
      when(() => leaveSpecsProvider.get()).thenAnswer((_) => Future.value(leaveSpecs));

      //when
      await presenter.loadLeaveSpecs();

      //then
      expect(presenter.getLeaveTypeNames(), ["Leave Type 1", "Leave Type 2"]);
      expect(presenter.getSelectedLeaveTypeName(), "Leave Type 1");
      expect(presenter.getLeaveStartDate()?.yyyyMMddString(), DateTime.now().yyyyMMddString());
      expect(presenter.getLeaveEndDate()?.yyyyMMddString(), DateTime.now().yyyyMMddString());
      verifyInOrder([
        () => leaveSpecsProvider.isLoading,
        () => view.showLeaveSpecsLoader(),
        () => leaveSpecsProvider.get(),
        () => view.onDidLoadLeaveSpecs(),
        () => view.onDidSelectLeaveType(),
        () => view.onDidSelectStartDate(),
        () => view.updateValidationErrors(),
        () => view.onDidSelectEndDate(),
        () => view.updateValidationErrors(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test('get leave type names', () async {
      var leaveType1 = MockLeaveType();
      var leaveType2 = MockLeaveType();
      when(() => leaveType1.name).thenReturn("Leave Type 1");
      when(() => leaveType1.requiredMinimumPeriod).thenReturn(0);
      when(() => leaveType2.name).thenReturn("Leave Type 2");
      var leaveSpecs = MockLeaveSpecs();
      when(() => leaveSpecs.leaveTypes).thenReturn([leaveType1, leaveType2]);
      when(() => leaveSpecsProvider.isLoading).thenReturn(false);
      when(() => leaveSpecsProvider.get()).thenAnswer((_) => Future.value(leaveSpecs));

      await presenter.loadLeaveSpecs();
    });

    test('get isLoadingLeaveSpecs', () {
      when(() => leaveSpecsProvider.isLoading).thenReturn(true);
      expect(presenter.isLoadingLeaveSpecs(), true);

      when(() => leaveSpecsProvider.isLoading).thenReturn(false);
      expect(presenter.isLoadingLeaveSpecs(), false);
    });

    test("shouldShowLoadLeaveSpecsError is true when there is an error", () async {
      //given
      when(() => leaveSpecsProvider.isLoading).thenReturn(false);
      when(() => leaveSpecsProvider.get()).thenAnswer((_) => Future.error(InvalidResponseException()));
      await presenter.loadLeaveSpecs();

      //then
      expect(presenter.shouldShowLoadLeaveSpecsError(), true);
    });

    test('shouldShowLoadLeaveSpecsError is false when there is no error', () async {
      //given
      var leaveType1 = MockLeaveType();
      var leaveType2 = MockLeaveType();
      when(() => leaveType1.name).thenReturn("Leave Type 1");
      when(() => leaveType1.requiredMinimumPeriod).thenReturn(0);
      when(() => leaveType2.name).thenReturn("Leave Type 2");
      var leaveSpecs = MockLeaveSpecs();
      when(() => leaveSpecs.leaveTypes).thenReturn([leaveType1, leaveType2]);
      when(() => leaveSpecsProvider.isLoading).thenReturn(false);
      when(() => leaveSpecsProvider.get()).thenAnswer((_) => Future.value(leaveSpecs));
      await presenter.loadLeaveSpecs();

      //then
      expect(presenter.shouldShowLoadLeaveSpecsError(), false);
    });
  });

  group("tests for functions to set the data", () {
    test("setting leave type", () async {
      //given
      var leaveType = MockLeaveType();
      when(() => leaveType.name).thenReturn("leave type 1");
      when(() => leaveType.requiredMinimumPeriod).thenReturn(0);
      var leaveSpecs = MockLeaveSpecs();
      when(() => leaveSpecs.leaveTypes).thenReturn([leaveType]);
      when(() => leaveSpecsProvider.isLoading).thenReturn(false);
      when(() => leaveSpecsProvider.get()).thenAnswer((_) => Future.value(leaveSpecs));
      await presenter.loadLeaveSpecs();
      _clearInteractionsOnAllMocks();

      //when
      presenter.selectLeaveTypeAtIndex(0);

      //then
      expect(presenter.getSelectedLeaveTypeName(), "leave type 1");
      verifyInOrder([
        () => view.onDidSelectLeaveType(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("setting leave start date", () {
      //when
      var date = DateTime(2022, 8, 20);
      presenter.setLeaveStartDate(date);

      //then
      expect(presenter.getStartDateString(), "20 Aug 2022");
      verifyInOrder([
        () => view.onDidSelectStartDate(),
        () => view.updateValidationErrors(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("setting leave end date", () {
      //when
      var date = DateTime(2022, 8, 25);
      presenter.setLeaveEndDate(date);

      //then
      expect(presenter.getEndDateString(), "25 Aug 2022");
      expect(presenter.getEndDateError(), null);
      verifyInOrder([
        () => view.onDidSelectEndDate(),
        () => view.updateValidationErrors(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("setting phone number", () {
      //when
      presenter.setPhoneNumber("111222333");

      //then
      expect(presenter.getPhoneNumber(), "111222333");
    });

    test("setting email", () {
      //when
      presenter.setEmail("someemail@email.com");

      //then
      expect(presenter.getEmail(), "someemail@email.com");
    });

    test("setting leave reason", () {
      //when
      presenter.setLeaveReason("some reason");

      //then
      expect(presenter.getLeaveReason(), "some reason");
    });

    test("adding an attachment", () {
      //given
      var file = MockFile();
      when(() => file.path).thenReturn("some/path/filename.png");

      //when
      presenter.addAttachment(file);

      //then
      expect(presenter.getAttachedFile(), file);
      verifyInOrder([
        () => view.onDidAddAttachment(),
        () => view.updateValidationErrors(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("removing an attachment", () {
      //given
      var file = MockFile();
      when(() => file.path).thenReturn("some/path/filename.png");
      presenter.addAttachment(file);
      _clearInteractionsOnAllMocks();

      //when
      presenter.removeAttachment();

      //then
      expect(presenter.getAttachedFile(), isNull);
      verifyInOrder([
        () => view.onDidRemoveAttachment(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });
  });

  group("tests for submitting the form", () {
    Future<void> _setupValidData() async {
      var leaveType = MockLeaveType();
      when(() => leaveType.name).thenReturn("leave type 1");
      when(() => leaveType.requiresCertificate).thenReturn(false);
      when(() => leaveType.requiredMinimumPeriod).thenReturn(0);
      var leaveSpecs = MockLeaveSpecs();
      when(() => leaveSpecs.leaveTypes).thenReturn([leaveType]);
      when(() => leaveSpecsProvider.isLoading).thenReturn(false);
      when(() => leaveSpecsProvider.get()).thenAnswer((_) => Future.value(leaveSpecs));
      await presenter.loadLeaveSpecs();
      presenter.selectLeaveTypeAtIndex(0);
      presenter.setLeaveStartDate(DateTime(2022, 8, 20));
      presenter.setLeaveEndDate(DateTime(2022, 8, 25));
      presenter.setPhoneNumber("1112223333");
      presenter.setEmail("someemail@email.com");
      presenter.setLeaveReason("some reason");
      _clearInteractionsOnAllMocks();
    }

    test("validation", () async {
      //given
      when(() => requestCreator.isLoading).thenReturn(false);
      _clearInteractionsOnAllMocks();

      //when
      await presenter.createLeave();

      //then
      expect(presenter.getEndDateError(), "Please select an end date");
      expect(presenter.getPhoneNumberError(), "Please enter a phone number");
      expect(presenter.getEmailError(), "Please enter an email");
      expect(presenter.getLeaveReasonError(), "Please enter a reason");
      expect(presenter.getFileAttachmentError(), null);
      verify(() => requestCreator.isLoading).called(1);
      verify(() => view.updateValidationErrors()).called(5);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("does nothing when the request creator is loading", () async {
      //given
      when(() => requestCreator.isLoading).thenReturn(true);

      //when
      await presenter.createLeave();

      //then
      verifyInOrder([
            () => requestCreator.isLoading,
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("shows validation errors if input is invalid", () async {
      //given
      when(() => requestCreator.isLoading).thenReturn(false);

      //when
      await presenter.createLeave();

      //then
      verifyInOrder([
            () => requestCreator.isLoading,
            () => view.updateValidationErrors(),
            () => view.updateValidationErrors(),
            () => view.updateValidationErrors(),
            () => view.updateValidationErrors(),
            () => view.updateValidationErrors(),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("failure to submit form", () async {
      //given
      when(() => requestCreator.isLoading).thenReturn(false);
      when(() => requestCreator.create(any(), any())).thenAnswer((_) => Future.error(InvalidResponseException()));
      await _setupValidData();

      //when
      await presenter.createLeave();

      //then
      verifyInOrder([
            () => requestCreator.isLoading,
            () => view.updateValidationErrors(),
            () => view.updateValidationErrors(),
            () => view.updateValidationErrors(),
            () => view.updateValidationErrors(),
            () => view.updateValidationErrors(),
            () => view.showFormSubmissionLoader(),
            () => requestCreator.create(any(), any()),
            () => view.onDidFailToSubmitForm(
          "Failed to create leave request",
          InvalidResponseException().userReadableMessage,
        ),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("successfully submitting the form", () async {
      //given
      when(() => requestCreator.isLoading).thenReturn(false);
      when(() => requestCreator.create(any(), any())).thenAnswer((_) => Future.value(null));
      await _setupValidData();

      //when
      await presenter.createLeave();

      //then
      verifyInOrder([
            () => requestCreator.isLoading,
            () => view.updateValidationErrors(),
            () => view.updateValidationErrors(),
            () => view.updateValidationErrors(),
            () => view.updateValidationErrors(),
            () => view.updateValidationErrors(),
            () => view.showFormSubmissionLoader(),
            () => requestCreator.create(any(), any()),
            () => view.onDidSubmitFormSuccessfully("Success", "Your leave request has been submitted successfully."),
      ]);
      _verifyNoMoreInteractionsOnAllMocks();
    });

    test("get isFormSubmissionInProgress", () {
      when(() => requestCreator.isLoading).thenReturn(false);
      expect(presenter.isFormSubmissionInProgress(), false);

      when(() => requestCreator.isLoading).thenReturn(true);
      expect(presenter.isFormSubmissionInProgress(), true);
    });
  });
}
