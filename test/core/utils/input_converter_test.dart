import 'package:clean_architecture_tdd_and/core/utils/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;
  setUp(() {
    inputConverter = new InputConverter();
  });

  group('stringToUnsignedInt', () {
    test('should return an integer when string is unsigned integer', () {
      final str = '123';
      var result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Right(123));
    });
    test('should return a failure when string is not unsigned integer', () {
      final str = 'abc';
      var result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Left(InvalidInputFailure()));
    });
    test('should return a failure when string is negative integer', () {
      final str = '-123';
      var result = inputConverter.stringToUnsignedInteger(str);
      expect(result, Left(InvalidInputFailure()));
    });
  });
}
