import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../services/api.dart';
import '../models/movies.dart';
import '../style/movies_list_style.dart';
import '../pages/film_card.dart';
import '../style/now_watching_style.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final List<Movie> _movies = [];
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Поиск фильмов'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Введите название фильма',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onSubmitted: (query) async {
                if (query.isNotEmpty) {
                  setState(() => _isLoading = true);
                  try {
                    final movies = await ApiService().searchMovies(query);
                    setState(() {
                      _movies.clear();
                      _movies.addAll(movies);
                    });
                  } catch (e) {
                    print('Ошибка загрузки фильмов: $e');
                  } finally {
                    setState(() => _isLoading = false);
                  }
                }
              },
            ),
            SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _movies.length,
                      itemBuilder: (context, index) {
                        final movie = _movies[index];
                        return ListTile(
                          leading: movie.posterPath.isNotEmpty
                              ? Image.network(
                                  'https://image.tmdb.org/t/p/w92${movie.posterPath}',
                                  width: 50,
                                )
                              : Icon(Icons.image_not_supported, size: 50),
                          title: Text(movie.title),
                          subtitle: Text('Дата выхода: ${movie.releaseDate}'),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FilmCard(movieId: movie.id),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
