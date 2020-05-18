import 'package:clean_architecture_tdd_and/core/network/network_info.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDataConnectionChecker extends Mock implements DataConnectionChecker {}

void main() {
  NetworkInfo networkInfo;
  DataConnectionChecker mockDataConnectionChecker;

  setUp(() {
    mockDataConnectionChecker = new MockDataConnectionChecker();
    networkInfo = new NetworkInfoImpl(mockDataConnectionChecker);
  });

  group('isConnected', () {
    test('should forward call to DataConnectionChecker.hasConnection', () {
      final tHasConnectionFuture = Future.value(true);
      when(mockDataConnectionChecker.hasConnection)
          .thenAnswer((realInvocation) => tHasConnectionFuture);
      var isConnected = networkInfo.isConnected;
      verify(mockDataConnectionChecker.hasConnection);
      expect(isConnected, tHasConnectionFuture);
    });
  });
}
