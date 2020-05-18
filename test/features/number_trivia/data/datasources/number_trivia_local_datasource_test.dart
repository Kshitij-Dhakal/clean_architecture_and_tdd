import 'dart:convert';

import 'package:clean_architecture_tdd_and/core/errors/exceptions.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSource dataSource;
  SharedPreferences sharedPreferences;
  setUp(() {
    sharedPreferences = new MockSharedPreferences();
    dataSource = new NumberTriviaLocalDataSourceImpl(sharedPreferences);
  });

  group('getLastNumberTrivia', () {
    var result =
        NumberTriviaModel.fromJson(jsonDecode(fixture('trivia_cached.json')));
    test(
        'should return number trivia from shared preference when there is one in the cache',
        () async {
      when(sharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cached.json'));

      var triviaModel = await dataSource.getLastNumberTrivia();
      verify(sharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, triviaModel);
    });
    test('should throw chached exception when there is no value in the cache',
        () async {
      when(sharedPreferences.getString(any)).thenReturn(null);
      var call = dataSource.getLastNumberTrivia;
      expect(() => call(), throwsA(isInstanceOf<CacheException>()));
    });
  });

  group('cacheNumberTrivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(number: 1, text: "Test Trivia");
    test('should call SharedPreference to cache the data', () {
      dataSource.cacheNumberTrivia(tNumberTriviaModel);
      var expectedJsonString = jsonEncode(tNumberTriviaModel.toJson());
      verify(sharedPreferences.setString(
          CACHED_NUMBER_TRIVIA, expectedJsonString));

    });
  });
}
