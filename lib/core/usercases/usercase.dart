import 'package:clean_architecture_tdd_and/core/errors/failures.dart';
import 'package:dartz/dartz.dart';

abstract class UseCase<Type, Params> {
  Future<Either<Failure, Type>> call();
}
