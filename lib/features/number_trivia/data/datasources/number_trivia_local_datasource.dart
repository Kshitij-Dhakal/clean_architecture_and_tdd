import 'dart:convert';

import 'package:clean_architecture_tdd_and/core/errors/exceptions.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class NumberTriviaLocalDataSource {
  Future<NumberTriviaModel> getLastNumberTrivia();

  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModelToCache);
}

const CACHED_NUMBER_TRIVIA = 'CACHED_NUMBER_TRIVIA';

class NumberTriviaLocalDataSourceImpl implements NumberTriviaLocalDataSource {
  final SharedPreferences sharedPreferences;

  NumberTriviaLocalDataSourceImpl(this.sharedPreferences);

  @override
  Future<void> cacheNumberTrivia(NumberTriviaModel triviaModelToCache) {
    return sharedPreferences.setString(
        CACHED_NUMBER_TRIVIA, jsonEncode(triviaModelToCache.toJson()));
  }

  @override
  Future<NumberTriviaModel> getLastNumberTrivia() {
    var string = sharedPreferences.getString(CACHED_NUMBER_TRIVIA);
    if (string != null) {
      return Future.value(jsonDecode(string));
    } else {
      throw new CacheException();
    }
  }
}
