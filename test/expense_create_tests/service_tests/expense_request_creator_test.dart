import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/money/money.dart';
import 'package:wallpost/_wp_core/wpapi/entities/file_upload_response.dart';
import 'package:wallpost/_wp_core/wpapi/exceptions/missing_uploaded_file_names_exception.dart';
import 'package:wallpost/expense_create/constants/create_expense_request_urls.dart';
import 'package:wallpost/expense_create/entities/expense_category.dart';
import 'package:wallpost/expense_create/entities/expense_request_form.dart';
import 'package:wallpost/expense_create/services/expense_request_creator.dart';

import '../../_mocks/mock_company.dart';
import '../../_mocks/mock_company_provider.dart';
import '../../_mocks/mock_file.dart';
import '../../_mocks/mock_file_uploader.dart';
import '../../_mocks/mock_network_adapter.dart';

class MockCategory extends Mock implements ExpenseCategory {}

main() {
  Map<String, dynamic> successfulResponse = {};
  var mainCategory = MockCategory();
  var subCategory = MockCategory();
  var project = MockCategory();
  var expenseRequestForm = ExpenseRequestForm(
    date: DateTime(2022, 08, 20),
    mainCategory: mainCategory,
    subCategory: subCategory,
    project: project,
    rate: Money(12.50),
    quantity: 3,
    description: "some description",
  );
  var selectedCompanyProvider = MockCompanyProvider();
  var fileUploader = MockFileUploader();
  var mockNetworkAdapter = MockNetworkAdapter();

  ExpenseRequestCreator _requestExecutor = ExpenseRequestCreator.initWith(
    selectedCompanyProvider,
    mockNetworkAdapter,
    fileUploader,
  );

  setUp(() {
    when(() => mainCategory.id).thenReturn("mainCategory1");
    when(() => subCategory.id).thenReturn("subCategory1");
    when(() => project.id).thenReturn("project1");
    var mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("someCompanyId");
    when(selectedCompanyProvider.getSelectedCompanyForCurrentUser).thenReturn(mockCompany);
    clearInteractions(fileUploader);
    clearInteractions(selectedCompanyProvider);
  });

  group('tests for creating expense request without file attachment', () {
    test("api request is built correctly", () async {
      Map<String, dynamic> requestParams = {
        'expenseItems': [expenseRequestForm.toJson()]
      };
      mockNetworkAdapter.succeed(successfulResponse);

      var _ = await _requestExecutor.create(expenseRequestForm, null);

      expect(mockNetworkAdapter.didCallPostWithFormData, true);
      expect(mockNetworkAdapter.apiRequest.url, CreateExpenseRequestUrls.getCreateExpenseRequestUrl("someCompanyId"));
      expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
    });

    test('throws exception when network adapter fails', () async {
      mockNetworkAdapter.fail(NetworkFailureException());

      try {
        var _ = await _requestExecutor.create(expenseRequestForm, null);
        fail('failed to throw the network adapter failure exception');
      } catch (e) {
        expect(e is NetworkFailureException, true);
      }
    });

    test('success', () async {
      mockNetworkAdapter.succeed(successfulResponse);

      try {
        await _requestExecutor.create(expenseRequestForm, null);
      } catch (e) {
        fail('failed to complete successfully. exception thrown $e');
      }
    });

    test('test loading flag is set to true when the service is executed', () async {
      mockNetworkAdapter.succeed(successfulResponse);

      _requestExecutor.create(expenseRequestForm, null);

      expect(_requestExecutor.isLoading, true);
    });

    test('test loading flag is reset after success', () async {
      mockNetworkAdapter.succeed(successfulResponse);

      var _ = await _requestExecutor.create(expenseRequestForm, null);

      expect(_requestExecutor.isLoading, false);
    });

    test('test loading flag is reset after failure', () async {
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
