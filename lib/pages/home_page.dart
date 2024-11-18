import 'package:flutter/material.dart';
import '../widgets/app_drawer.dart';
import '../services/api.dart';
import '../models/movies.dart';
import '../style/movies_list_style.dart';
import '../pages/film_card.dart';
import '../style/now_watching_style.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key}); 

  @override
  Widget build(BuildContext context) {
    final futureMovies = ApiService().fetchTrendingMovies();

    return Scaffold(
      appBar: AppBar(
        title: Text('Сейчас смотрят'),
        backgroundColor: AppStyles.primaryColor,  
      ),
      drawer: AppDrawer(),  
      body: FutureBuilder<List<Movies>>(
        future: futureMovies,  
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Ошибка: ${snapshot.error}'));
          }

          if (snapshot.hasData) {
            final movies = snapshot.data!;

            return ListView.builder(
              itemCount: movies.length,
              itemBuilder: (context, index) {
                final movie = movies[index];

                double posterWidth = 150.0; 
                double posterHeight = 225.0; 

                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => FilmCard(movieId: movie.id),
                        ),
                      );
                    },
                    child: Container(
                      padding: EdgeInsets.all(8.0),
                      color: Colors.transparent, 
                      child: Row(
                        children: [
                          movie.posterPath.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8), 
                                  child: Image.network(
                                    'https://image.tmdb.org/t/p/w500${movie.posterPath}',
                                    width: posterWidth, 
                                    height: posterHeight, 
                                    fit: BoxFit.cover,
                                  ),
                                )
                              : SizedBox(width: posterWidth, height: posterHeight), 
                          SizedBox(width: 16), 
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  movie.title,
                                  style: NowWatching.headingStyle,  
                                ),
                                SizedBox(height: 4),
                                Text(
                                  movie.overview,
                                  style: NowWatching.movieDescriptionStyle,  
                                  maxLines: 3,  
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          }

          return Center(child: Text('Нет доступных фильмов.'));
        },
      ),
    );
  }
}