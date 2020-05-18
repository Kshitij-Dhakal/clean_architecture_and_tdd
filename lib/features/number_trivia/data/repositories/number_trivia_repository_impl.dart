import 'package:clean_architecture_tdd_and/core/errors/exceptions.dart';
import 'package:clean_architecture_tdd_and/core/errors/failures.dart';
import 'package:clean_architecture_tdd_and/core/network/network_info.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/datasources/number_trivia_local_datasource.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/datasources/number_trivia_remote_datasource.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/domain/repositories/number_trivia_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:meta/meta.dart';

typedef Future<NumberTriviaModel> _ConcreteOrRandom();

class NumberTriviaRepositoryImplementation implements NumberTriviaRepository {
  NumberTriviaRemoteDataSource remoteDataSource;
  NumberTriviaLocalDataSource localDataSource;

  NumberTriviaRepositoryImplementation(
      {@required this.remoteDataSource,
      @required this.localDataSource,
      @required this.networkInfo});

  NetworkInfo networkInfo;

  @override
  Future<Either<Failure, NumberTrivia>> getConcreteNumberTrivia(int num) async {
    return await _getTrivia(
        () => remoteDataSource.getConcreteNumberTrivia(num));
  }

  @override
  Future<Either<Failure, NumberTrivia>> getRandomNumberTrivia() async {
    _getTrivia(() => remoteDataSource.getRandomNumberTrivia());
  }

  Future<Either<Failure, NumberTrivia>> _getTrivia(
      _ConcreteOrRandom getConcreteOrRandomNumberTrivia) async {
    if (await networkInfo.isConnected) {
      try {
        var _r = await getConcreteOrRandomNumberTrivia();
        localDataSource.cacheNumberTrivia(_r);
        return Right(_r);
      } on ServerException {
        return Left(new ServerFailure());
      }
    } else {
      try {
        var trivia = await localDataSource.getLastNumberTrivia();
        return Right(trivia);
      } on CacheException {
        return Left(new CacheFailure());
      }
    }
  }
}
