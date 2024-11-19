import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/movies.dart'; 
import 'package:flutter_dotenv/flutter_dotenv.dart'; 

class ApiService {
  
  final String _apiKey = dotenv.get('API_KEY');
  final String _baseUrl = dotenv.get('BASE_URL');
  // final String _baseUrl = 'https://api.themoviedb.org/3';

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

 Future<List<Movie>> searchMovies(String query) async {
    final response = await http.get(
      Uri.parse('$_baseUrl/search/movie?query=$query&include_adult=false&language=ru-RU&page=1&api_key=$_apiKey'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body)['results'];
      print(data);
      return data.map((json) => Movie.fromJson(json)).toList();
    } else {
      throw Exception('Ошибка загрузки данных о фильмах');
    }
  }
}
