import 'package:flutter/material.dart';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

class MovieFavoriteWidget extends StatelessWidget {
  const MovieFavoriteWidget({
    super.key,
    required this.movie,
    required this.size,
  });

  final Movie movie;
  final double size;

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return IconButton(
      onPressed: () async {
        await moviesProvider.toggleFavorite(movie);
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.black54,
            content: Text(
              movie.isFavorite!
                  ? '${movie.title} añadida a favoritos'
                  : '${movie.title} eliminada de favoritos',
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
            action: SnackBarAction(
              textColor: Colors.yellow[900],
              label: 'Cerrar',
              onPressed: () {},
            ),
            duration: const Duration(milliseconds: 1500),
          ),
        );
      },
      icon: Stack(children: [
        Icon(
          Icons.favorite_rounded,
          color: movie.isFavorite! ? Colors.yellow[700] : Colors.white,
          size: size,
        ),
        Icon(
          Icons.favorite_outline_rounded,
          color: Colors.black,
          size: size,
        ),
      ]),
    );
  }
}
