import 'package:clean_architecture_tdd_and/core/errors/failures.dart';
import 'package:clean_architecture_tdd_and/core/usercases/usercase.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

class GetConcreteNumberTrivia implements UseCase<NumberTrivia, int> {
  final NumberTriviaRepository repositories;

  GetConcreteNumberTrivia(this.repositories);

  @override
  Future<Either<Failure, NumberTrivia>> call({@required int number}) {
    return repositories.getConcreteNumberTrivia(number);
  }
}
