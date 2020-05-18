import 'package:clean_architecture_tdd_and/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

class InputConverter {
  Either<Failure, int> stringToUnsignedInteger(String str) {
    try {
      var parse = int.parse(str);
      if (parse < 0)
        throw new FormatException();
      else
        return Right(parse);
    } on FormatException {
      return Left(InvalidInputFailure());
    }
  }
}

class InvalidInputFailure extends Failure {}
