import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../style/film_card_style.dart';
import '../services/api.dart';
import '../models/movies.dart';
import '../pages/film_card.dart';
import '../widgets/year_input_widget.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _yearController = TextEditingController();
  List<Movie> _movies = [];
  bool _isLoading = false;
  int _currentPage = 1;
  bool _hasNextPage = true; 

  Future<void> _searchMovies() async {
    setState(() {
      _isLoading = true;
      _hasNextPage = true;
    });

    try {
      final movies = await ApiService().searchMovies(
        _searchController.text,
        year: _yearController.text.isNotEmpty ? _yearController.text : null,
        page: _currentPage,
      );

      setState(() {
        if (movies.isEmpty) {
          _hasNextPage = false; 
        } else {
          _movies = movies;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('Ошибка поиска фильмов: $e');
      }
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _loadNextPage() async {
    if (_hasNextPage) {
      setState(() {
        _currentPage++;
      });
      await _searchMovies();
    }
  }

  Future<void> _loadPreviousPage() async {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      await _searchMovies();
    }
  }

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
              onSubmitted: (_) => _searchMovies(),
            ),
            SizedBox(height: 10),
            YearInputWidget(
              yearController: _yearController,
              onYearChanged: (_) => _searchMovies(),
            ),
            SizedBox(height: 10),
            _isLoading
                ? CircularProgressIndicator()
                : Expanded(
                    child: ListView.builder(
                      itemCount: _movies.length,
                      itemBuilder: (context, index) {
                        final movie = _movies[index];

                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FilmCard(movieId: movie.id),
                              ),
                            );
                          },
                          child: Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            color: Color.fromARGB(227,242,253,255),
                            child: Row(
                              children: [
                                movie.posterPath.isNotEmpty
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Image.network(
                                          'https://image.tmdb.org/t/p/w200${movie.posterPath}',
                                          width: 130,
                                          height: 195,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : SizedBox(width: 92, height: 138),
                                SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        movie.title,
                                        style: FilmCardStyle.movieTitleStyle,
                                      ),
                                      SizedBox(height: 4),
                                      Text(
                                        'Дата выхода: ${movie.releaseDate}',
                                        style: FilmCardStyle.dateStyle,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
            if (!_isLoading)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (_currentPage > 1)
                      ElevatedButton(
                        style: FilmCardStyle.backButtonStyle,
                        onPressed: _loadPreviousPage,
                        child: Text('Назад',
                        style: FilmCardStyle.textButtonStyle),
                      ),
                    SizedBox(width: 16),
                    if (_hasNextPage)
                      ElevatedButton(
                        style: FilmCardStyle.backButtonStyle,
                        onPressed: _loadNextPage,
                        child: Text('Вперед',
                        style: FilmCardStyle.textButtonStyle),
                      ),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
