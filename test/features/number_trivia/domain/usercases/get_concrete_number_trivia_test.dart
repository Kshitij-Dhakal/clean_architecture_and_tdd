import 'package:clean_architecture_tdd_and/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/usercases/get_concrete_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetConcreteNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = new MockNumberTriviaRepository();
    usecase = new GetConcreteNumberTrivia(mockNumberTriviaRepository);
  });

  final tNum = 1;
  final tNumTrivia = new NumberTrivia(text: "test", number: 1);

  test('should get trivia for the number from the repository', () async {
    when(mockNumberTriviaRepository.getConcreteNumberTrivia(any))
        .thenAnswer((realInvocation) async => Right(tNumTrivia));

    final result = await usecase(number: tNum);

    expect(result, Right(tNumTrivia));
    verify(mockNumberTriviaRepository.getConcreteNumberTrivia(tNum));
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
