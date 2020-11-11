import 'package:flutter_test/flutter_test.dart';
import 'package:wallpost/_shared/wpapi/nonce_provider.dart';

import '../../_mocks/mock_network_adapter.dart';

void main() {
  Map<String, dynamic> nonceResponse = {
    "status": "success",
    "data": {"nonce": "someNonceString"}
  };
  var mockNetworkAdapter = MockNetworkAdapter();
  var nonceProvider = NonceProvider.initWith(mockNetworkAdapter);

  test('api request is built and executed correctly', () async {
    mockNetworkAdapter.succeed(nonceResponse);

    var _ = await nonceProvider.getNonce({});

    expect(mockNetworkAdapter.apiRequest.url, 'https://core.api.wallpostsoftware.com/api/v2/nonce/gen');
    expect(mockNetworkAdapter.apiRequest.parameters.isEmpty, true);
    expect(mockNetworkAdapter.didCallGet, true);
  });

  test('throws exception when network adapter fails', () async {
    mockNetworkAdapter.fail(NetworkFailureException());

    try {
      var _ = await nonceProvider.getNonce({});
      fail('failed to throw the network adapter failure exception');
    } catch (e) {
      expect(e is NetworkFailureException, true);
    }
  });

  test('response is ignored if it is from another session', () async {
    var didReceiveResponseForTheSecondRequest = false;

    mockNetworkAdapter.succeed(nonceResponse, afterDelayInMilliSeconds: 50);
    nonceProvider.getNonce({}).then((_) {
      fail('Received the response for the first request. '
          'This response should be ignored as the session id has changed');
    });

    mockNetworkAdapter.succeed(nonceResponse);
    nonceProvider.getNonce({}).then((_) {
      didReceiveResponseForTheSecondRequest = true;
    });

    await Future.delayed(Duration(milliseconds: 100));
    expect(didReceiveResponseForTheSecondRequest, true);
  });

  test('throws InvalidResponseException when response is null', () async {
    mockNetworkAdapter.succeed(null);

    try {
      var _ = await nonceProvider.getNonce({});
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('throws WrongResponseFormatException when response is of the wrong format', () async {
    mockNetworkAdapter.succeed('wrong response format');

    try {
      var _ = await nonceProvider.getNonce({});
      fail('failed to throw WrongResponseFormatException');
    } catch (e) {
      expect(e is WrongResponseFormatException, true);
    }
  });

  test('throws InvalidResponseException when entity mapping fails', () async {
    mockNetworkAdapter.succeed(<String, dynamic>{});

    try {
      var _ = await nonceProvider.getNonce({});
      fail('failed to throw InvalidResponseException');
    } catch (e) {
      expect(e is InvalidResponseException, true);
    }
  });

  test('success', () async {
    mockNetworkAdapter.succeed(nonceResponse);

    try {
      var nonce = await nonceProvider.getNonce({});
      expect(nonce.value, 'someNonceString');
    } catch (e) {
      fail('failed to complete successfully. exception thrown $e');
    }
  });

  test('test loading flag is set to true when the service is executed', () async {
    mockNetworkAdapter.succeed(nonceResponse);

    nonceProvider.getNonce({});

    expect(nonceProvider.isLoading, true);
  });

  test('test loading flag is reset after success', () async {
    mockNetworkAdapter.succeed(nonceResponse);

    var _ = await nonceProvider.getNonce({});

    expect(nonceProvider.isLoading, false);
  });

  test('test loading flag is reset after failure', () async {
    mockNetworkAdapter.fail(InvalidResponseException());

    try {
      var _ = await nonceProvider.getNonce({});
      fail('failed to throw exception');
    } catch (_) {
      expect(nonceProvider.isLoading, false);
    }
  });
}
