import 'package:flutter/material.dart';
import 'package:peliculas_app/models/movie.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:provider/provider.dart';

import '../share_preferences/preferences.dart';
import 'favorite_movie_widget.dart';

class MovieSlider extends StatefulWidget {
  final List<Movie> movies;
  final String? title;
  final Function onNextPage;

  const MovieSlider(
      {super.key, required this.movies, this.title, required this.onNextPage});

  @override
  State<MovieSlider> createState() => _MovieSliderState();
}

class _MovieSliderState extends State<MovieSlider> {
  final ScrollController scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollController.addListener(() {
      if (scrollController.position.pixels >=
          scrollController.position.maxScrollExtent - 500) {
        widget.onNextPage();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.movies.isEmpty) {
      return const SizedBox(
          width: double.infinity,
          height: 260,
          child: Center(child: CircularProgressIndicator()));
    }
    return SizedBox(
      width: double.infinity,
      height: 260,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ignore: unnecessary_this
          if (this.widget.title != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                // ignore: unnecessary_this
                this.widget.title!,
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Colors.white),
              ),
            ),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: ListView.builder(
              controller: scrollController,
              itemCount: widget.movies.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (_, int index) => _MoviePoster(
                  movie: widget.movies[index],
                  heroId:
                      '${widget.title}-${index}-${widget.movies[index].id}'),
            ),
          ),
        ],
      ),
    );
  }
}

class _MoviePoster extends StatelessWidget {
  final Movie movie;
  final String heroId;
  const _MoviePoster({super.key, required this.movie, required this.heroId});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    movie.heroId = heroId;
    final moviesProvider = Provider.of<MoviesProvider>(context);
    return Container(
      width: 130,
      height: 200,
      margin: const EdgeInsets.symmetric(horizontal: 10),
      child: Column(children: [
        GestureDetector(
          onTap: () async => {
            await moviesProvider.getTrailerPeli(movie.id.toString()),
             Preferences.idLastMovie = movie.id.toString(),
              Preferences.lastPage = 'details',

            moviesProvider.selectedMovie = movie,
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context, 'details', arguments: movie),
          },
          child: Hero(
            tag: movie.heroId!,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  FadeInImage(
                    placeholder: const AssetImage('assets/images/no-image.jpg'),
                    image: NetworkImage(movie.fullPosterImg),
                    fit: BoxFit.cover,
                    width: 130,
                    height: 180,
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: MovieFavoriteWidget(
                        movie: movie, size: size.height * 0.03),
                  ),
                ],
              ),
            ),
          ),
        ),
        const SizedBox(
          height: 5,
        ),
        Text(
          movie.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.center,
        )
      ]),
    );
  }
}
