import 'dart:async';

import 'package:flutter/material.dart';
import 'package:peliculas_app/services/movies_service.dart';
import 'package:peliculas_app/share_preferences/preferences.dart';

import '../helpers/debouncer.dart';
import '../models/models.dart';

class MoviesProvider extends ChangeNotifier {
  MoviesService moviesService = MoviesService();

  List<Movie> onDisplayMovies = [];
  List<Movie> upcomingMovies = [];
  List<Movie> topRatedMovies = [];
  List<Movie> popularMovies = [];

  List<String> historyMovies = [];
  List<Movie> moviesFavs = [];

  ActorResponse? actor;

  Movie? selectedMovie;

  Map<int, List<Cast>> moviesCast = {};

  final debounce =
      Debouncer<String>(duration: const Duration(milliseconds: 500));

  VideoResponse? videoResponse;

  final StreamController<List<Movie>> _suggestStreamController =
      StreamController.broadcast();
  Stream<List<Movie>> get suggestionStream => _suggestStreamController.stream;

  MoviesProvider() {
    // ignore: unnecessary_this
    this.getOnDisplayMovies();
    // ignore: unnecessary_this
    this.getPopularMovies();
    // ignore: unnecessary_this
    this.getTopRatedMovies();
    // ignore: unnecessary_this
    this.getUpcomingMovies();
    // ignore: unnecessary_this
    this.getMovieByID(Preferences.idLastMovie);
    // ignore: unnecessary_this
    this.getActorByID(Preferences.idLastActor);

    historyMovies = Preferences.historyMovies;
  }

  void getTopRatedMovies() async {
    List<Movie> movies = await moviesService.getTopRated();
    await getMoviesFavs();
    //cruzo datos con mis favoritas para añadir el isFavorite y el idFirebase
    for (var movie in movies) {
      final indexFav =
          moviesFavs.indexWhere((movieFav) => movieFav.id == movie.id);
      if (indexFav != -1) {
        movie.isFavorite = true;
        movie.idFirebase = moviesFavs[indexFav].idFirebase;
      }
    }
    topRatedMovies = movies;
    notifyListeners();
  }

  void getUpcomingMovies() async {
    List<Movie> movies = await moviesService.getUpcoming();
    await getMoviesFavs();
    //cruzo datos con mis favoritas para añadir el isFavorite y el idFirebase
    for (var movie in movies) {
      final indexFav =
          moviesFavs.indexWhere((movieFav) => movieFav.id == movie.id);
      if (indexFav != -1) {
        movie.isFavorite = true;
        movie.idFirebase = moviesFavs[indexFav].idFirebase;
      }
    }
    upcomingMovies = movies;
    notifyListeners();
  }

  getOnDisplayMovies() async {
    final List<Movie> movies = await moviesService.getNowPlaying();

    await getMoviesFavs();

    //cruzo datos con mis favoritas para añadir el isFavorite y el idFirebase
    for (var movie in movies) {
      final indexFav =
          moviesFavs.indexWhere((movieFav) => movieFav.id == movie.id);
      if (indexFav != -1) {
        movie.isFavorite = true;
        movie.idFirebase = moviesFavs[indexFav].idFirebase;
      }
    }

    onDisplayMovies = movies;
    notifyListeners();
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;

    final List<Cast> casts = await moviesService.getMovieCast(movieId);

    moviesCast[movieId] = casts;

    return casts;
  }

  getPopularMovies() async {
    final List<Movie> movies = await moviesService.getPopularMovies();

    await getMoviesFavs();
    //cruzo datos con mis favoritas para añadir el isFavorite y el idFirebase
    for (var movie in movies) {
      final indexFav =
          moviesFavs.indexWhere((movieFav) => movieFav.id == movie.id);
      if (indexFav != -1) {
        movie.isFavorite = true;
        movie.idFirebase = moviesFavs[indexFav].idFirebase;
      }
    }

    popularMovies = [...popularMovies, ...movies];

    notifyListeners();
  }

  Future<List<Movie>> searchMovies(String query) async {
    final List<Movie> movies = await moviesService.searchMovies(query);

    //ordeno por fecha mas reciente las peliculas
    movies.sort((a, b) {
      if (a.year.isEmpty && b.year.isEmpty) {
        return 0;
      } else if (a.year.isEmpty) {
        return 1;
      } else if (b.year.isEmpty) {
        return -1;
      } else {
        return (int.parse(b.year)).compareTo(int.parse(a.year));
      }
    });

    return movies;
  }

  Future<void> getActor(Cast cast) async {
    actor = await moviesService.getActor(cast.id.toString());
    notifyListeners();
  }

  Future<void> toggleFavorite(Movie movie) async {
    movie.isFavorite = !movie.isFavorite!;

    await moviesService.updateFavs(movie);

    if (movie.isFavorite!) {
      moviesFavs.add(movie);
    } else {
      moviesFavs.removeWhere((movieFav) => movieFav.id == movie.id);
    }

    //Busco la pelicula en la lista de peliculas en pantalla
    final posOnDisplayMovies =
        onDisplayMovies.indexWhere((movieOnDis) => movieOnDis.id == movie.id);

    if (posOnDisplayMovies != -1) {
      //Si la encuentro, actualizo la propiedad isFavorite
      onDisplayMovies[posOnDisplayMovies].isFavorite = movie.isFavorite;
    }

    //Busco la pelicula en la lista de peliculas populares
    final posPopularMovies =
        popularMovies.indexWhere((moviePop) => moviePop.id == movie.id);

    if (posPopularMovies != -1) {
      //Si la encuentro, actualizo la propiedad isFavorite
      popularMovies[posPopularMovies].isFavorite = movie.isFavorite;
    }

    //Busco la pelicula en la lista de peliculas upcoming
    final posUpcomingMovies =
        upcomingMovies.indexWhere((movieUpc) => movieUpc.id == movie.id);

    if (posUpcomingMovies != -1) {
      //Si la encuentro, actualizo la propiedad isFavorite
      upcomingMovies[posUpcomingMovies].isFavorite = movie.isFavorite;
    }

    //Busco la pelicula en la lista de peliculas topRated
    final posTopRatedMovies =
        topRatedMovies.indexWhere((movieTop) => movieTop.id == movie.id);

    if (posTopRatedMovies != -1) {
      //Si la encuentro, actualizo la propiedad isFavorite
      topRatedMovies[posTopRatedMovies].isFavorite = movie.isFavorite;
    }

    notifyListeners();
  }

  Future<void> getTrailerPeli(String movieID) async {
    videoResponse = await moviesService.getVideo(movieID);
    notifyListeners();
  }

  getMoviesFavs() async {
    if (moviesFavs.isEmpty) {
      moviesFavs = await moviesService.getFavs();
    }
    notifyListeners();
  }

  getVideo() {
    if (videoResponse?.videos?.isNotEmpty ?? false) {
      return videoResponse?.videos?[0].key;
    } else {
      return 'error';
    }
  }

  void getSuggestionsByQuery(String searchTerm) {
    debounce.value = '';
    debounce.onValue = (value) async {
      final results = await searchMovies(value);
      addHistoryMovie(searchTerm);
      _suggestStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debounce.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }

  addHistoryMovie(String termSearch) async {
    //compruebo si el termino ya esta en la lista
    final index = historyMovies.indexWhere((movie) => movie == termSearch);
    //si no esta la añado y si ya esta la muevo al principio
    if (index == -1) {
      historyMovies.insert(0, termSearch);
    } else {
      final movieTemp = historyMovies[index];
      historyMovies.removeAt(index);
      historyMovies.insert(0, movieTemp);
    }

    //mantengo solo 15
    if (historyMovies.length > 15) {
      historyMovies.removeLast();
    }
    //lo guardo en el dispositivo shared preferences
    Preferences.historyMovies = historyMovies;

    notifyListeners();
  }

  Future<void> getMovieByID(String idLastMovie) async {
    //busco la pelicula por el servicio
    Movie movie = await moviesService.getMoviebyID(idLastMovie);

    await getTrailerPeli(movie.id.toString());

    await getMoviesFavs();
    //busco la pelicula en mis favoritas
    final indexFav =
        moviesFavs.indexWhere((movieFav) => movieFav.id == movie.id);
    if (indexFav != -1) {
      movie.isFavorite = true;
      movie.idFirebase = moviesFavs[indexFav].idFirebase;
    }

    selectedMovie = movie;
  }
  
    Future<void> getActorByID(String idLastActor) async{
      ActorResponse actorResponse = await moviesService.getActor(idLastActor );
      print(actorResponse.name);
      actor = actorResponse;
    }
}
