import 'dart:convert';

import 'package:clean_architecture_tdd_and/core/errors/exceptions.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockHttpClient extends Mock implements http.Client {}

void main() {
  NumberTriviaRemoteDataSource dataSource;
  MockHttpClient httpClient;

  setUp(() {
    httpClient = new MockHttpClient();
    dataSource = new NumberTriviaRemoteDataSourceImpl(httpClient);
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        new NumberTriviaModel.fromJson(jsonDecode(fixture('trivia.json')));
    test(
        'should perform a GET request on a URL with number being the endpoint and with application/JSON header',
        () {
      setupMockHttpClientSuccess(httpClient);
      dataSource.getConcreteNumberTrivia(tNumber);
      verify(httpClient.get('http://numbersapi.com/$tNumber',
          headers: {'Content-Type': 'application/JSON'}));
    });

    test('should return number trivia when response code is 200', () async {
      setupMockHttpClientSuccess(httpClient);
      var model = await dataSource.getConcreteNumberTrivia(tNumber);
      expect(model, tNumberTriviaModel);
    });

    test('should throw a server exception when the response code is 404',
        () async {
      mockHttpClientFailure(httpClient);
      var call = dataSource.getConcreteNumberTrivia;
      expect(() => call(tNumber), throwsA(isInstanceOf<ServerException>()));
    });
  });
}

void mockHttpClientFailure(MockHttpClient httpClient) {
   when(httpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
      (realInvocation) async => http.Response('Something went wrong', 404));
}

void setupMockHttpClientSuccess(MockHttpClient httpClient) {
  return when(httpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (realInvocation) async => http.Response(fixture('trivia.json'), 200));
}
