import 'package:clean_architecture_tdd_and/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:equatable/equatable.dart';

abstract class NumberTriviaState extends Equatable {
  const NumberTriviaState();
}

class Empty extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loading extends NumberTriviaState {
  @override
  List<Object> get props => [];
}

class Loaded extends NumberTriviaState {
  final NumberTrivia trivia;

  Loaded(this.trivia);

  @override
  List<Object> get props => [trivia];
}

class Error extends NumberTriviaState {
  final String errMessage;

  Error(this.errMessage);

  @override
  List<Object> get props => [errMessage];
}
