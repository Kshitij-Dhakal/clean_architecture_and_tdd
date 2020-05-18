import 'dart:convert';

import 'package:clean_architecture_tdd_and/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: "Test");

  test('should be subclass of number trivia entity', () {
    expect(tNumberTriviaModel, isA<NumberTrivia>());
  });

  group('fromJson', () {
    test('should return valid number when JSON number is integer', () {
      final Map<String, dynamic> jsonMap = jsonDecode(fixture('trivia.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });
    test('should return valid number when JSON number is double', () {
      final Map<String, dynamic> jsonMap =
          jsonDecode(fixture('trivia_double.json'));

      final result = NumberTriviaModel.fromJson(jsonMap);
      expect(result, tNumberTriviaModel);
    });

    group('toJson', () {
      test('should return JSON map containing the proper data', () {
        var json = tNumberTriviaModel.toJson();
        var expectedMap = {"text": "Test", "number": 1};
        expect(json, expectedMap);
      });
    });
  });
}
