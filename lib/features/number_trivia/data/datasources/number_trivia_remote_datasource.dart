import 'dart:convert';

import 'package:clean_architecture_tdd_and/core/errors/exceptions.dart';
import 'package:clean_architecture_tdd_and/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:http/http.dart' as http;

abstract class NumberTriviaRemoteDataSource {
  Future<NumberTriviaModel> getConcreteNumberTrivia(int num);

  Future<NumberTriviaModel> getRandomNumberTrivia();
}

class NumberTriviaRemoteDataSourceImpl implements NumberTriviaRemoteDataSource {
  final http.Client client;

  NumberTriviaRemoteDataSourceImpl(this.client);

  @override
  Future<NumberTriviaModel> getConcreteNumberTrivia(int num) async {
    return await _getTriviaFromUrl('http://numbersapi.com/$num');
  }

  @override
  Future<NumberTriviaModel> getRandomNumberTrivia() async {
    return await _getTriviaFromUrl('http://numbersapi.com/random');
  }

  Future<NumberTriviaModel> _getTriviaFromUrl(String url) async {
    var res =
        await client.get(url, headers: {'Content-Type': 'application/JSON'});
    if (res.statusCode == 200) {
      return NumberTriviaModel.fromJson(jsonDecode(res.body));
    } else {
      throw new ServerException();
    }
  }
}
