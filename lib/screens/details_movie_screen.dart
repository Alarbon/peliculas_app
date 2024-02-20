// ignore_for_file: unnecessary_null_comparison, prefer_conditional_assignment

import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/share_preferences/preferences.dart';
import 'package:peliculas_app/widgets/favorite_movie_widget.dart';
import 'package:peliculas_app/widgets/video_youtube.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';

class DetailsMovieScreen extends StatelessWidget {
  const DetailsMovieScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    Movie? movie = moviesProvider.selectedMovie;
    final videoYoutube = moviesProvider.getVideo();

    return Scaffold(
        body: movie == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                slivers: [
                  _CustomAppBar(movie: movie),
                  SliverList(
                    delegate: movie == null
                        ? SliverChildListDelegate([
                            const Center(
                              child: CircularProgressIndicator(),
                            ),
                          ])
                        : SliverChildListDelegate(
                            [
                              _PosterAndTitle(movie: movie),
                              _Overview(movie: movie),
                              const SizedBox(
                                height: 30,
                              ),
                              CastingCards(movieId: movie.id),
                              videoYoutube != 'error'
                                  ? YoutubePlayerWidget(
                                      videoId: videoYoutube.toString())
                                  : Container(),
                            ],
                          ),
                  )
                ],
              ));
  }
}

class _CustomAppBar extends StatelessWidget {
  final Movie movie;
  const _CustomAppBar({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.white),
        onPressed: () => {
          Preferences.lastPage = 'home',
          Navigator.canPop(context)
              ? Navigator.pop(context)
              : Navigator.pushNamed(context, 'home'),
        },
      ),
      backgroundColor: Colors.yellow[900]!,
      expandedHeight: 200,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        centerTitle: true,
        titlePadding: const EdgeInsets.all(0),
        title: Container(
          alignment: Alignment.bottomCenter,
          padding: const EdgeInsets.only(bottom: 10, left: 10, right: 10),
          color: Colors.black12,
          child: Text(
            movie.title,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/images/loading.gif'),
          image: NetworkImage(movie.fullBackdropPath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  final Movie movie;
  const _PosterAndTitle({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20),
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(children: [
        Hero(
          tag: movie.heroId ?? 'hero-${movie.id}',
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              constraints: const BoxConstraints(maxWidth: 120),
              child: Stack(
                children: [
                  FadeInImage(
                    placeholder: const AssetImage('assets/images/no-image.jpg'),
                    image: NetworkImage(movie.fullPosterImg),
                    height: 150,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: MovieFavoriteWidget(
                        movie: movie, size: size.height * 0.025),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          width: 20,
        ),
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: size.width - 190),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movie.title,
                    style: textTheme.headlineSmall,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Text(
                    movie.originalTitle,
                    style: textTheme.titleMedium,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    children: [
                      Icon(Icons.star_border,
                          size: 15, color: Colors.yellow[800]!),
                      const SizedBox(
                        width: 5,
                      ),
                      Text(
                        movie.voteAverage.toString(),
                        style: textTheme.bodySmall,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
      ]),
    );
  }
}

class _Overview extends StatelessWidget {
  final Movie movie;

  const _Overview({super.key, required this.movie});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        movie.overview ?? 'No hay descripción',
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}
