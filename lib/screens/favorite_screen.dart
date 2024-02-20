import 'package:flutter/material.dart';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/search/search_delegate.dart';
import 'package:peliculas_app/widgets/favorite_movie_widget.dart';
import 'package:provider/provider.dart';

class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    if (moviesProvider.moviesFavs.isEmpty) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Alarbon Films'),
          elevation: 0,
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search_outlined,
                size: 30.0,
                color: Colors.white,
              ),
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
            )
          ],
        ),
        body: const Center(
          child: Text('No hay peliculas favoritas'),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Alarbon Films'),
          elevation: 0,
           leading: IconButton(
          icon: const Icon(
            Icons.history_rounded,
            size: 30.0,
            color: Colors.white,
          ),
          onPressed: () => {
            Navigator.pushNamed(context, 'history'),
          },
        ),
          actions: [
            IconButton(
              icon: const Icon(
                Icons.search_outlined,
                size: 30.0,
                color: Colors.white,
              ),
              onPressed: () =>
                  showSearch(context: context, delegate: MovieSearchDelegate()),
            )
          ],
        ),
        body: ListView.builder(
          itemCount: moviesProvider.moviesFavs.length,
          itemBuilder: (_, index) {
            final size = MediaQuery.of(context).size;
            Movie movie = moviesProvider.moviesFavs[index];
            return ListTile(
              leading: FadeInImage(
                placeholder: const AssetImage('assets/images/no-image.jpg'),
                image: NetworkImage(movie.fullPosterImg),
                width: 50,
                fit: BoxFit.contain,
              ),
              title: Text(movie.title),
              subtitle: Text(movie.originalTitle),
              trailing: MovieFavoriteWidget(
                movie: movie,
                size: size.height * 0.035,
              ),
              onTap: () async => {
                await moviesProvider.getTrailerPeli(movie.id.toString()),
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, 'details', arguments: movie)
              },
            );
          },
        ));
  }
}
