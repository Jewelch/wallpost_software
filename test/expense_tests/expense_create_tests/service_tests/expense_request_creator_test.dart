import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/input_validation_exception.dart';
import 'package:wallpost/_shared/money/money.dart';
import 'package:wallpost/_wp_core/wpapi/entities/file_upload_response.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/missing_uploaded_file_names_exception.dart';
import 'package:wallpost/expense/expense_create/constants/create_expense_request_urls.dart';
import 'package:wallpost/expense/expense_create/entities/expense_category.dart';
import 'package:wallpost/expense/expense_create/entities/expense_request_form.dart';
import 'package:wallpost/expense/expense_create/services/expense_request_creator.dart';

import '../../../_mocks/mock_company.dart';
import '../../../_mocks/mock_company_provider.dart';
import '../../../_mocks/mock_file.dart';
import '../../../_mocks/mock_file_uploader.dart';
import '../../../_mocks/mock_network_adapter.dart';

class MockCategory extends Mock implements ExpenseCategory {}

main() {
  Map<String, dynamic> successfulResponse = {};
  var expenseRequestForm = ExpenseRequestForm();
  var selectedCompanyProvider = MockCompanyProvider();
  var fileUploader = MockFileUploader();
  var mockNetworkAdapter = MockNetworkAdapter();
  ExpenseRequestCreator _requestExecutor = ExpenseRequestCreator.initWith(
    selectedCompanyProvider,
    mockNetworkAdapter,
    fileUploader,
  );

  void _setupFormWithoutFile() {
    var mainCategory = MockCategory();
    var subCategory = MockCategory();
    var project = MockCategory();
    when(() => mainCategory.id).thenReturn("mainCategory1");
    when(() => mainCategory.subCategories).thenReturn([subCategory]);
    when(() => subCategory.id).thenReturn("subCategory1");
    when(() => mainCategory.projects).thenReturn([project]);
    when(() => project.id).thenReturn("project1");
    expenseRequestForm.date = DateTime(2022, 08, 20);
    expenseRequestForm.mainCategory = mainCategory;
    expenseRequestForm.subCategory = subCategory;
    expenseRequestForm.project = project;
    expenseRequestForm.rate = Money(12.50);
    expenseRequestForm.quantity = 3;
    expenseRequestForm.description = "some description";
  }

  void _setupFormWithFile() {
    _setupFormWithoutFile();
    expenseRequestForm.description = "some description";
  }

  setUp(() {
    var mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(selectedCompanyProvider.getSelectedCompanyForCurrentUser).thenReturn(mockCompany);
    clearInteractions(fileUploader);
    clearInteractions(selectedCompanyProvider);
  });

  group('tests for creating expense request without file attachment', () {
    test("api request is built correctly", () async {
      _setupFormWithoutFile();
      Map<String, dynamic> requestParams = {
        'expenseItems': [expenseRequestForm.toJson()]
      };
      mockNetworkAdapter.succeed(successfulResponse);

      var _ = await _requestExecutor.create(expenseRequestForm, null);

      expect(mockNetworkAdapter.didCallPostWithFormData, true);
      expect(mockNetworkAdapter.apiRequest.url, CreateExpenseRequestUrls.getCreateExpenseRequestUrl("someCompanyId"));
      expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    });

    test('throws exception entity to json mapping fails', () async {
      expenseRequestForm = ExpenseRequestForm();

      try {
        var _ = await _requestExecutor.create(expenseRequestForm, null);
        fail('failed to throw the network adapter failure exception');
      } catch (e) {
        expect(e is InputValidationException, true);
      }
    });

    test('throws exception when network adapter fails', () async {
      _setupFormWithoutFile();
      mockNetworkAdapter.fail(NetworkFailureException());

      try {
        var _ = await _requestExecutor.create(expenseRequestForm, null);
        fail('failed to throw the network adapter failure exception');
      } catch (e) {
        expect(e is NetworkFailureException, true);
      }
    });

    test('success', () async {
      _setupFormWithoutFile();
      mockNetworkAdapter.succeed(successfulResponse);

      try {
        await _requestExecutor.create(expenseRequestForm, null);
      } catch (e) {
        fail('failed to complete successfully. exception thrown $e');
      }
    });

    test('test loading flag is set to true when the service is executed', () async {
      _setupFormWithoutFile();
      mockNetworkAdapter.succeed(successfulResponse);

      _requestExecutor.create(expenseRequestForm, null);

      expect(_requestExecutor.isLoading, true);
    });

    test('test loading flag is reset after success', () async {
      _setupFormWithoutFile();
      mockNetworkAdapter.succeed(successfulResponse);

      var _ = await _requestExecutor.create(expenseRequestForm, null);

      expect(_requestExecutor.isLoading, false);
    });

    test('test loading flag is reset after failure', () async {
      _setupFormWithoutFile();
      mockNetworkAdapter.fail(NetworkFailureException());

      try {
        var _ = await _requestExecutor.create(expenseRequestForm, null);
        fail('failed to throw exception');
      } catch (_) {
        expect(_requestExecutor.isLoading, false);
      }
    });
  });

  group('tests for creating expense request with file attachment', () {
    test("api request is built correctly", () async {
      _setupFormWithFile();
      var fileUploadResponse = FileUploadResponse(["uploadedFileName"]);
      when(() => fileUploader.upload(any())).thenAnswer((_) => Future.value(fileUploadResponse));
      var expectedRequestParams = expenseRequestForm.toJson();
      expectedRequestParams["file"] = "uploadedFileName";
      Map<String, dynamic> requestParams = {
        'expenseItems': [expectedRequestParams]
      };
      mockNetworkAdapter.succeed(successfulResponse);

      var _ = await _requestExecutor.create(expenseRequestForm, MockFile());

      verify(() => fileUploader.upload(any())).called(1);
      expect(mockNetworkAdapter.didCallPostWithFormData, true);
      expect(mockNetworkAdapter.apiRequest.url, CreateExpenseRequestUrls.getCreateExpenseRequestUrl("someCompanyId"));
      expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    });

    test("failure to upload file", () async {
      _setupFormWithFile();
      when(() => fileUploader.upload(any())).thenAnswer((_) => Future.error(MissingUploadedFileNamesException()));

      try {
        var _ = await _requestExecutor.create(expenseRequestForm, MockFile());
        fail('failed to throw exception');
      } catch (e) {
        expect(e is MissingUploadedFileNamesException, true);
      }
    });
  });
}
