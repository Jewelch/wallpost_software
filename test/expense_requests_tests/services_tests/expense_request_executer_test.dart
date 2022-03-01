import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:wallpost/_shared/exceptions/wrong_response_format_exception.dart';
import 'package:wallpost/_wp_core/wpapi/services/wp_api.dart';
import 'package:wallpost/company_core/entities/company.dart';
import 'package:wallpost/company_core/services/selected_company_provider.dart';
import 'package:wallpost/expense_requests/constants/expense_requests_urls.dart';
import 'package:wallpost/expense_requests/exeptions/failed_to_save_requet.dart';
import 'package:wallpost/expense_requests/services/expense_request_executor.dart';
import '../../_mocks/mock_network_adapter.dart';
import '../_mocks/expense_categories_mock.dart';
import '../_mocks/expense_request_mocks.dart';
import '../_mocks/mock_file_uploader.dart';

class MockSelectedCompanyProvider extends Mock implements SelectedCompanyProvider {}

class MockApiResponse extends Mock implements APIResponse {}

class MockApiRequest extends Mock implements APIRequest {}

class MockCompany extends Mock implements Company {}

main() {
  var request = MockExpenseRequest();
  var apiRequest = MockApiRequest();
  var apiResponse = MockApiResponse();
  var company = MockCompany();
  var selectedCompanyProvider = MockSelectedCompanyProvider();
  var fileUploader = MockFileUploader();
  var mockNetworkAdapter = MockNetworkAdapter();
  var successfulResponse = successFullAddingExpenseRequestResponse;
  ExpenseRequestExecutor _requestExecutor =
      ExpenseRequestExecutor.initWith(mockNetworkAdapter, fileUploader, selectedCompanyProvider);

  setUp(() {
    when(() => company.id).thenReturn("1");
    when(selectedCompanyProvider.getSelectedCompanyForCurrentUser).thenReturn(company);
    when(() => apiResponse.apiRequest).thenReturn(apiRequest);
    when(() => apiResponse.data).thenReturn({"file": "file"});
    when(() => fileUploader.upload(any())).thenAnswer((invocation) => Future.value(apiResponse));
    when(() => request.toJson()).thenReturn({});
    when(() => request.files).thenReturn([]);
  });

  setUp(() {
    clearInteractions(fileUploader);
    clearInteractions(selectedCompanyProvider);
  });

  _verifyNoMoreInteractionsOnAllMocks() {
    verifyNoMoreInteractions(fileUploader);
    clearInteractions(selectedCompanyProvider);
  }

  test("api request is built correctly", () async {
    Map<String, dynamic> requestParams = {
      'expenseItems': [request.toJson()]
    };
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await _requestExecutor.execute([request]);

    expect(mockNetworkAdapter.apiRequest.url, ExpenseRequestsUrls.getExpenseAddingUrl("1"));
    expect(mockNetworkAdapter.apiRequest.parameters, requestParams);
  });

  test("do nothing when sending empty list", () {
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = _requestExecutor.execute([]);

    _verifyNoMoreInteractionsOnAllMocks();
  });

  test("calling file uploading for every expense request", () async {
    var mocksRequest1 = getExpenseRequest();
    var mocksRequest2 = getExpenseRequest();
    var mocksRequest3 = getExpenseRequest();
    var requests = [
      mocksRequest1,
      mocksRequest2,
      mocksRequest3,
    ];
    mockNetworkAdapter.succeed(successfulResponse);

    var _ = await _requestExecutor.execute(requests);

    var verifyResult = verify(() => fileUploader.upload(any()));
    expect(verifyResult.callCount, 3);
  });

  test('throws exception when file uploader fails', () async {
    when(() => fileUploader.upload(any())).thenAnswer((invocation) =>throw NetworkFailureException());

    try {
      var _ = await _requestExecutor.execute([request]);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when file uploader response is null', () async {
    when(() => apiResponse.data).thenReturn(null);
    when(() => fileUploader.upload(any())).thenAnswer((invocation) => Future.value(apiResponse));
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await _requestExecutor.execute([request]);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when file uploader response is of the wrong format', () async {
    when(() => apiResponse.data).thenReturn('wrong response format');
    when(() => fileUploader.upload(any())).thenAnswer((invocation) => Future.value(apiResponse));

    try {
      var _ = await _requestExecutor.execute([request]);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws FailedToSaveRequest when file uploader response is not the success response', () async {
    when(() => apiResponse.data).thenReturn(<String, dynamic>{});
    when(() => fileUploader.upload(any())).thenAnswer((invocation) => Future.value(apiResponse));

    try {
      var _ = await _requestExecutor.execute([request]);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is FailedToSaveRequest, true);
    }
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await _requestExecutor.execute([request]);
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('throws InvalidResponseException when network adapter response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await _requestExecutor.execute([request]);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when network adapter response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await _requestExecutor.execute([request]);
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws FailedToSaveRequest when mockNetworkAdapter response is not the success response', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await _requestExecutor.execute([request]);
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is FailedToSaveRequest, true);
    }
  });

  test("success", () async {
    var mocksRequest1 = getExpenseRequest();
    mockNetworkAdapter.succeed(successfulResponse);

    var res = await _requestExecutor.execute([mocksRequest1]);

    var verifyResult = verify(() => fileUploader.upload(any()));
    var verifyResult2 = verify(() => selectedCompanyProvider.getSelectedCompanyForCurrentUser());
    expect(verifyResult.callCount, 1);
    expect(verifyResult2.callCount, 1);
    expect(res, true);
  });
}
