import 'package:clean_architecture_tdd_and/core/errors/failures.dart';
import 'package:clean_architecture_tdd_and/core/usercases/usercase.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';

class GetRandomNumberTrivia implements UseCase<NumberTrivia, int> {
  final NumberTriviaRepository repositories;

  GetRandomNumberTrivia(this.repositories);

  @override
  Future<Either<Failure, NumberTrivia>> call() {
    return repositories.getRandomNumberTrivia();
  }
}
