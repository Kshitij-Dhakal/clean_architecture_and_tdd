import 'package:equatable/equatable.dart';

abstract class NumberTriviaEvent extends Equatable {
  const NumberTriviaEvent();
}

class GetConcreteNumberTriviaEvent extends NumberTriviaEvent {
  final String numberString;

  GetConcreteNumberTriviaEvent(this.numberString);

  @override
  List<Object> get props => [numberString];
}

class GetRandomNumberTriviaEvent extends NumberTriviaEvent {

  @override
  List<Object> get props => [];
}
