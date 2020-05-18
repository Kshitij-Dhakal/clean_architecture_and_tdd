import 'package:clean_architecture_tdd_and/core/errors/exceptions.dart';
import 'package:clean_architecture_tdd_and/core/errors/failures.dart';
import 'package:clean_architecture_tdd_and/core/network/network_info.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/repositories/number_trivia_repository_impl.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockRemoteDataSource extends Mock
    implements NumberTriviaRemoteDataSource {}

class MockLocalDataSource extends Mock implements NumberTriviaLocalDataSource {}

class MockNetworkInfo extends Mock implements NetworkInfo {}

void main() {
  NumberTriviaRepository repository;
  NumberTriviaRemoteDataSource mockRemoteDataSource;
  NumberTriviaLocalDataSource mockLocalDataSource;
  NetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = new MockRemoteDataSource();
    mockLocalDataSource = new MockLocalDataSource();
    mockNetworkInfo = new MockNetworkInfo();
    repository = new NumberTriviaRepositoryImplementation(
        remoteDataSource: mockRemoteDataSource,
        localDataSource: mockLocalDataSource,
        networkInfo: mockNetworkInfo);
  });

  group('getConcreteNumberTrivia', () {
    final tNumber = 1;
    final tNumberTriviaModel =
        new NumberTriviaModel(number: tNumber, text: 'Text Trivia');
    final NumberTrivia tNumberTrivia = tNumberTriviaModel;
    test('should test if device is online', () {
      when(mockNetworkInfo.isConnected)
          .thenAnswer((realInvocation) async => true);
      repository.getConcreteNumberTrivia(tNumber);
      verify(mockNetworkInfo.isConnected);
    });
    group('deviceIsOnline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => true);
      });
      test('should return remote data when call to remote data is success',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => tNumberTriviaModel);
        var result = await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        expect(result, equals(Right(tNumberTrivia)));
      });
      test('should cache the data locally when call to remote data is success',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenAnswer((realInvocation) async => tNumberTriviaModel);
        await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verify(mockLocalDataSource.cacheNumberTrivia(tNumberTriviaModel));
      });
      test(
          'should return server failure when call to remote data source is unsuccessful',
          () async {
        when(mockRemoteDataSource.getConcreteNumberTrivia(any))
            .thenThrow(new ServerException());
        var result = await repository.getConcreteNumberTrivia(tNumber);
        verify(mockRemoteDataSource.getConcreteNumberTrivia(tNumber));
        verifyZeroInteractions(mockLocalDataSource);
        expect(result, equals(Left(new ServerFailure())));
      });
    });
    group('deviceIsOffline', () {
      setUp(() {
        when(mockNetworkInfo.isConnected)
            .thenAnswer((realInvocation) async => false);
      });
      test(
          'should return last locally cached data when the cache data is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenAnswer((realInvocation) async => tNumberTriviaModel);
        var result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Right(tNumberTrivia)));
      });
      test('should return CacheFailure when no cache data is present',
          () async {
        when(mockLocalDataSource.getLastNumberTrivia())
            .thenThrow(new CacheException());
        var result = await repository.getConcreteNumberTrivia(tNumber);
        verifyZeroInteractions(mockRemoteDataSource);
        verify(mockLocalDataSource.getLastNumberTrivia());
        expect(result, equals(Left(new CacheFailure())));
      });
    });
  });
}
