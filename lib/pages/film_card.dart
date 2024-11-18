import 'package:flutter/material.dart';
import '../services/api.dart';
import '../models/movie.dart';
import '../style/film_card_style.dart';

class FilmCard extends StatelessWidget {
  final int movieId;
  const FilmCard({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Подробности фильма'),
        backgroundColor: FilmCardStyle.primaryColor, 
      ),
      body: FutureBuilder<Movie>(
        future: ApiService().fetchMovieDetails(movieId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final movie = snapshot.data!;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                            width: 400,
                            height: 600,
                            fit: BoxFit.cover,
                          ),
                        ),
                        SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie.title,
                                style: FilmCardStyle.movieTitleStyle, 
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Дата выпуска: ${movie.releaseDate}',
                                style: FilmCardStyle.dateStyle, 
                              ),
                              SizedBox(height: 8),
                              Text(
                                movie.overview,
                                style: FilmCardStyle.movieDescriptionStyle, 
                                textAlign: TextAlign.justify,
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.access_time_outlined,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    '${movie.runtime} минут',
                                    style: FilmCardStyle.movieDescriptionStyle, 
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  Icon(
                                    Icons.star,
                                    color: Colors.amber,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    movie.voteAverage.toString(),
                                    style: FilmCardStyle.ratingStyle, 
                                  ),
                                ],
                              ),
                               SizedBox(height: 16),
                                Row(
                                  children: [
                                    SizedBox(width: 12),
                                    Text(
                                    'Жанры: ${movie.genre
                                              .map((genre) => genre.name)
                                              .join(', ')}',
                                    style: FilmCardStyle.movieDescriptionStyle, 
                                    ),
                                  ],
                                ),
                              SizedBox(height: 16),
                              Row(
                                children: [
                                  SizedBox(width: 12),
                                  Text(
                                  'Production companies: ${movie.productionCompanies
                                                            .map((company) => company.name)
                                                            .join(', ')}',
                                  style: FilmCardStyle.movieDescriptionStyle, 
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    Center(
                      child: ElevatedButton(
                        style: FilmCardStyle.backButtonStyle,  
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Назад',
                          style: FilmCardStyle.textButtonStyle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          return Center(child: Text('Нет доступных данных о фильме.'));
        },
      ),
    );
  }
}
