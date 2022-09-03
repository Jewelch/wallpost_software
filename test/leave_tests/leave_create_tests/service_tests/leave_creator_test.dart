import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/input_validation_exception.dart';
import 'package:wallpost/_wp_core/wpapi/entities/file_upload_response.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/missing_uploaded_file_names_exception.dart';
import 'package:wallpost/leave/leave_create/constants/create_leave_urls.dart';
import 'package:wallpost/leave/leave_create/entities/leave_request_form.dart';
import 'package:wallpost/leave/leave_create/entities/leave_type.dart';
import 'package:wallpost/leave/leave_create/services/leave_creator.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_employee.dart';
import '../../../_mocks/mock_file.dart';
import '../../../_mocks/mock_file_uploader.dart';
import '../../../_mocks/mock_network_adapter.dart';

class MockLeaveType extends Mock implements LeaveType {}

main() {
  Map<String, dynamic> successfulResponse = {};
  var leaveRequestForm = LeaveRequestForm();
  var selectedCompanyProvider = MockCompanyProvider();
  var fileUploader = MockFileUploader();
  var mockNetworkAdapter = MockNetworkAdapter();

  LeaveCreator _requestExecutor = LeaveCreator.initWith(
    selectedCompanyProvider,
    mockNetworkAdapter,
    fileUploader,
  );

  void _setupFormWithoutFile() {
    var leaveType = MockLeaveType();
    when(() => leaveType.id).thenReturn("leaveTypeId");
    when(() => leaveType.requiresCertificate).thenReturn(false);
    when(() => leaveType.requiredMinimumPeriod).thenReturn(0);
    leaveRequestForm.leaveType = leaveType;
    leaveRequestForm.startDate = DateTime.now();
    leaveRequestForm.endDate = DateTime.now();
    leaveRequestForm.phoneNumber = "1112222333";
    leaveRequestForm.email = "someemail@email.com";
    leaveRequestForm.leaveReason = "some leave reason";
  }

  void _setupFormWithFile() {
    _setupFormWithoutFile();
    leaveRequestForm.attachedFileName = "someFileName.png";
  }

  setUp(() {
    var mockEmployee = MockEmployee();
    var mockCompany = MockCompany();
    when(() => mockEmployee.v1Id).thenReturn("empV1Id");
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(() => mockCompany.employee).thenReturn(mockEmployee);
    when(selectedCompanyProvider.getSelectedCompanyForCurrentUser).thenReturn(mockCompany);
    clearInteractions(fileUploader);
    clearInteractions(selectedCompanyProvider);
  });

  group('tests for creating leave request without file attachment', () {
    test("api request is built correctly", () async {
      _setupFormWithoutFile();
      mockNetworkAdapter.succeed(successfulResponse);

      var _ = await _requestExecutor.create(leaveRequestForm, null);

      expect(mockNetworkAdapter.didCallPost, true);
      expect(mockNetworkAdapter.apiRequest.url, CreateLeaveUrls.createLeaveUrl("someCompanyId", "empV1Id"));
      expect(mockNetworkAdapter.apiRequest.parameters, leaveRequestForm.toJson());
    });

    test('throws exception entity to json mapping fails', () async {
      leaveRequestForm = LeaveRequestForm();

      try {
        var _ = await _requestExecutor.create(leaveRequestForm, null);
        fail('failed to throw the network adapter failure exception');
      } catch (e) {
        expect(e is InputValidationException, true);
      }
    });

    test('throws exception when network adapter fails', () async {
      _setupFormWithoutFile();
      mockNetworkAdapter.fail(NetworkFailureException());

      try {
        var _ = await _requestExecutor.create(leaveRequestForm, null);
        fail('failed to throw the network adapter failure exception');
      } catch (e) {
        expect(e is NetworkFailureException, true);
      }
    });

    test('success', () async {
      _setupFormWithoutFile();
      mockNetworkAdapter.succeed(successfulResponse);

      try {
        await _requestExecutor.create(leaveRequestForm, null);
      } catch (e) {
        fail('failed to complete successfully. exception thrown $e');
      }
    });

    test('test loading flag is set to true when the service is executed', () async {
      _setupFormWithoutFile();
      mockNetworkAdapter.succeed(successfulResponse);

      _requestExecutor.create(leaveRequestForm, null);

      expect(_requestExecutor.isLoading, true);
    });

    test('test loading flag is reset after success', () async {
      _setupFormWithoutFile();
      mockNetworkAdapter.succeed(successfulResponse);

      var _ = await _requestExecutor.create(leaveRequestForm, null);

      expect(_requestExecutor.isLoading, false);
    });

    test('test loading flag is reset after failure', () async {
      _setupFormWithoutFile();
      mockNetworkAdapter.fail(NetworkFailureException());

      try {
        var _ = await _requestExecutor.create(leaveRequestForm, null);
        fail('failed to throw exception');
      } catch (_) {
        expect(_requestExecutor.isLoading, false);
      }
    });
  });

  group('tests for creating leave request with file attachment', () {
    test("api request is built correctly", () async {
      _setupFormWithFile();
      var fileUploadResponse = FileUploadResponse(["uploadedFileName"]);
      when(() => fileUploader.upload(any())).thenAnswer((_) => Future.value(fileUploadResponse));
      mockNetworkAdapter.succeed(successfulResponse);

      var _ = await _requestExecutor.create(leaveRequestForm, MockFile());

      var expectedRequestParams = leaveRequestForm.toJson();
      expectedRequestParams["file_name"] = ["uploadedFileName"];
      verify(() => fileUploader.upload(any())).called(1);
      expect(mockNetworkAdapter.didCallPost, true);
      expect(mockNetworkAdapter.apiRequest.url, CreateLeaveUrls.createLeaveUrl("someCompanyId", "empV1Id"));
      expect(mockNetworkAdapter.apiRequest.parameters, expectedRequestParams);
    });

    test("failure to upload file", () async {
      _setupFormWithFile();
      when(() => fileUploader.upload(any())).thenAnswer((_) => Future.error(MissingUploadedFileNamesException()));

      try {
        var _ = await _requestExecutor.create(leaveRequestForm, MockFile());
        fail('failed to throw exception');
      } catch (e) {
        expect(e is MissingUploadedFileNamesException, true);
      }
    });
  });
}
