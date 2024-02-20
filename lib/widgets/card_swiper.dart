import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/share_preferences/preferences.dart';
import 'package:provider/provider.dart';

import 'favorite_movie_widget.dart';

class CardSwiper extends StatelessWidget {
  final List<Movie> movies;
  const CardSwiper({super.key, required this.movies});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
   

    final moviesProvider = Provider.of<MoviesProvider>(context);

    if (movies.isEmpty) {
      return SizedBox(
          width: double.infinity,
          height: size.height * 0.5,
          child: const Center(child: CircularProgressIndicator()));
    }
    return SizedBox(
      width: double.infinity,
      height: size.height * 0.5,
      child: //swiper
          Swiper(
        itemCount: movies.length,
        layout: SwiperLayout.STACK,
        //si esta en web se cambia el tamaño el ancho
        itemWidth: size.width > 1500 ? size.height * 0.3 : size.width * 0.6,
        itemHeight: size.height * 0.4,
        itemBuilder: (BuildContext context, int index) {
          final movie = movies[index];

          movie.heroId = 'swiper-${movie.id}';

          return GestureDetector(
            onTap: () async => {
              await moviesProvider.getTrailerPeli(movie.id.toString()),
              Preferences.idLastMovie = movie.id.toString(),
              Preferences.lastPage = 'details',

              moviesProvider.selectedMovie = movie,
              // ignore: use_build_context_synchronously
              Navigator.pushNamed(context, 'details', arguments: movie)
            },
            child: Hero(
              tag: movie.heroId!,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Stack(
                  children: [
                    FadeInImage(
                      placeholder: const AssetImage(
                        'assets/images/no-image.jpg',
                      ),
                      image: NetworkImage(movie.fullPosterImg),
                      fit: BoxFit.cover,
                      width: size.width * 0.7,
                      height: size.height * 0.4,
                    ),
                    Positioned(
                      right: 0,
                      top: 0,
                      child: MovieFavoriteWidget(
                        movie: movie,
                        size: size.height * 0.04,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
