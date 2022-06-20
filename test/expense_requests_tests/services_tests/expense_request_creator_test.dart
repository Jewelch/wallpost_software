import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';
import 'package:wallpost/expense_requests/constants/expense_requests_urls.dart';
import 'package:wallpost/expense_requests/exeptions/failed_to_save_requet.dart';
import 'package:wallpost/expense_requests/services/expense_request_creator.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../_mocks/expense_request_mocks.dart';

class MockCompany extends Mock implements Company {}

class MockSelectedCompanyProvider extends Mock implements SelectedCompanyProvider {}

class MockApiResponse extends Mock implements APIResponse {}

main() {
  var selectedCompanyProvider = MockSelectedCompanyProvider();
  var fileUploader = MockFileUploader();
  var mockNetworkAdapter = MockNetworkAdapter();
  var successfulExecuteResponse = successFullAddingExpenseRequestResponse;
  var successfulUploadFileResponse = successFullUploadingFileResponse;
  var expenseRequest = getExpenseRequestForm();
  ExpenseRequestCreator _requestExecutor =
      ExpenseRequestCreator.initWith(mockNetworkAdapter, fileUploader, selectedCompanyProvider);

  setUp(() {
    // set up selected company provider
    var mockCompany = MockCompany();
    when(() => mockCompany.id).thenReturn("1");
    when(selectedCompanyProvider.getSelectedCompanyForCurrentUser).thenReturn(mockCompany);
    // set up file Uploader
    var mockApiResponse = MockApiResponse();
    when(() => mockApiResponse.data).thenReturn(successfulUploadFileResponse);
    when(() => fileUploader.upload(any()))
        .thenAnswer((invocation) => Future.value(mockApiResponse));
    // clear interactions
    clearInteractions(fileUploader);
    clearInteractions(selectedCompanyProvider);
    // reinitialize
    expenseRequest = getExpenseRequestForm();
  });

  test("api request is built correctly", () async {
    expenseRequest.fileString = "file1";
    Map<String, dynamic> requestParams = {
      'expenseItems': [expenseRequest.toJson()]
    };
    mockNetworkAdapter.succeed(successfulExecuteResponse);

    var _ = await _requestExecutor.execute(expenseRequest);

    expect(mockNetworkAdapter.apiRequest.url, ExpenseRequestsUrls.getExpenseAddingUrl("1"));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test("upload attached file successFully", () async {
    expenseRequest.file = mockFile;
    expenseRequest.fileString = "";

    var _ = await _requestExecutor.execute(expenseRequest);

    var verifyResult = verify(() => fileUploader.upload(any()));
    expect(verifyResult.callCount, 1);
    expect(expenseRequest.fileString, "file1");
  });

  test("never call file uploading if expense request doesn't has file", () async {
    expenseRequest.file = null;
    mockNetworkAdapter.succeed(successfulExecuteResponse);

    var _ = await _requestExecutor.execute(expenseRequest);

    verifyNever(() => fileUploader.upload(any()));
  });

  test('throws NetworkFailureException when file uploader fails', () async {
    when(() => fileUploader.upload(any()))
        .thenAnswer((invocation) => throw NetworkFailureException());

    try {
      var _ = await _requestExecutor.execute(expenseRequest);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when file uploader response is null', () async {
    var mockApiResponse = MockApiResponse();
    when(() => mockApiResponse.data).thenReturn(null);
    when(() => fileUploader.upload(any()))
        .thenAnswer((invocation) => Future.value(mockApiResponse));

    try {
      var _ = await _requestExecutor.execute(expenseRequest);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when file uploader response has wrong format',
      () async {
    var mockApiResponse = MockApiResponse();
    when(() => mockApiResponse.data).thenReturn('wrong response format');
    when(() => fileUploader.upload(any()))
        .thenAnswer((invocation) => Future.value(mockApiResponse));

    try {
      var _ = await _requestExecutor.execute(expenseRequest);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws FailedToSaveRequest when file uploader response is not the successful response',
      () async {
    var mockApiResponse = MockApiResponse();
    when(() => mockApiResponse.data).thenReturn(<String, dynamic>{});
    when(() => fileUploader.upload(any()))
        .thenAnswer((invocation) => Future.value(mockApiResponse));

    try {
      var _ = await _requestExecutor.execute(expenseRequest);
      fail('failed to throw FailedToSaveRequest');
    } catch (e) {
      expect(e is FailedToSaveRequest, true);
    }
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await _requestExecutor.execute(expenseRequest);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when network adapter response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await _requestExecutor.execute(expenseRequest);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when network adapter response is of the wrong format',
      () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await _requestExecutor.execute(expenseRequest);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws FailedToSaveRequest when network adapter response is not the success response',
      () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await _requestExecutor.execute(expenseRequest);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is FailedToSaveRequest, true);
    }
  });

  test('test executing flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(successfulExecuteResponse);

    _requestExecutor.execute(expenseRequest);

    expect(_requestExecutor.isExecuting, true);
  });

  test('test executing flag is reset after success', () async {
    mockNetworkAdapter.succeed(successfulExecuteResponse);

    var _ = await _requestExecutor.execute(expenseRequest);

    expect(_requestExecutor.isExecuting, false);
  });

  test('test executing flag is reset after failure', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await _requestExecutor.execute(expenseRequest);
      fail('failed to throw exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
      expect(_requestExecutor.isExecuting, false);
    }
  });

  test("success", () async {
    mockNetworkAdapter.succeed(successfulExecuteResponse);

    var _ = await _requestExecutor.execute(expenseRequest);

    var verifyResult = verify(() => fileUploader.upload(any()));
    var verifyResult2 = verify(() => selectedCompanyProvider.getSelectedCompanyForCurrentUser());
    expect(verifyResult.callCount, 1);
    expect(verifyResult2.callCount, 1);
  });

  test('test calling execute while still executing the first call do nothing', () async {
    mockNetworkAdapter.succeed(successfulExecuteResponse);

    var _ = _requestExecutor.execute(expenseRequest);
    _ = _requestExecutor.execute(expenseRequest);
    _ = _requestExecutor.execute(expenseRequest);

    var verifyResult = verify(() => fileUploader.upload(any()));
    var verifyResult2 = verify(() => selectedCompanyProvider.getSelectedCompanyForCurrentUser());
    expect(verifyResult.callCount, 1);
    expect(verifyResult2.callCount, 1);
  });
}
