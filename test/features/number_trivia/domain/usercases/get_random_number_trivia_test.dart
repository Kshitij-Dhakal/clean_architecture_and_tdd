import 'package:clean_architecture_tdd_and/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/usercases/get_random_number_trivia.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockNumberTriviaRepository extends Mock
    implements NumberTriviaRepository {}

void main() {
  GetRandomNumberTrivia usecase;
  MockNumberTriviaRepository mockNumberTriviaRepository;

  setUp(() {
    mockNumberTriviaRepository = new MockNumberTriviaRepository();
    usecase = new GetRandomNumberTrivia(mockNumberTriviaRepository);
  });

  final tNum = 1;
  final tNumTrivia = new NumberTrivia(text: "test", number: 1);

  test('should get trivia from the repository', () async {
    when(mockNumberTriviaRepository.getRandomNumberTrivia())
        .thenAnswer((realInvocation) async => Right(tNumTrivia));

    final result = await usecase();

    expect(result, Right(tNumTrivia));
    verify(mockNumberTriviaRepository.getRandomNumberTrivia());
    verifyNoMoreInteractions(mockNumberTriviaRepository);
  });
}
