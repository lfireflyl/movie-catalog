import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import '../models/movies.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class ApiService {
  
  final String _apiKey = dotenv.get('API_KEY');
  final String _baseUrl = dotenv.get('BASE_URL');

  Future<List<Movie>> fetchTrendingMovies() async {
    final response = await http.get(
      Uri.parse('$_baseUrl/trending/movie/day?language=ru-RU&api_key=$_apiKey'),
      
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки популярных фильмов');
    }
  }

 Future<Movie> fetchMovieDetails(int movieId) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/movie/$movieId?language=ru-RU&api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return Movie.fromJson(data);
    } else {
      throw Exception('Ошибка загрузки данных о фильме');
    }
  }

Future<List<Movie>> searchMovies(String query, {String? year, int page = 1}) async {
  final yearFilter = year != null && year.isNotEmpty ? '&year=$year' : '';
  final url =
      '$_baseUrl/search/movie?query=$query&primary_release_year=$yearFilter&include_adult=false&language=ru-RU&page=$page&api_key=$_apiKey';
  final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      if (kDebugMode) {
        print(yearFilter);
        print(url);
      }  
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки данных о фильмах');
    }
  }

  Future<List<Map<String, dynamic>>> fetchGenres() async {
  final response = await http.get(
    Uri.parse('$_baseUrl/genre/movie/list?language=ru-RU&api_key=$_apiKey'),
  );

  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body)['genres'];
    return data.map((genre) {
      return {'id': genre['id'], 'name': genre['name']};
    }).toList();
  } else {
    throw Exception('Ошибка загрузки жанров');
  }
}

}
