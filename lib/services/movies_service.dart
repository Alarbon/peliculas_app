import 'dart:convert';

import 'package:http/http.dart';
import 'package:peliculas_app/models/models.dart';

class MoviesService {
  final String _apiKey = 'a9dae8877c7d3d4387e4e7525609bb6f';
  final String _baseUrl = 'api.themoviedb.org';
  final String _languaje = 'es-ES';
  final String urlFirebase =
      'https://peliculas-4f72e-default-rtdb.europe-west1.firebasedatabase.app/movies';

  Future<List<Movie>> getNowPlaying() async {
    List<Movie> movies = [];
    final jsonData = await _getJsonData('3/movie/now_playing');

    final nowPlayingResponse = nowPlayingResponseFromJson(jsonData);

    movies = nowPlayingResponse.results;

    return movies;
  }

  Future<List<Movie>> getUpcoming() async {
    List<Movie> movies = [];
    final jsonData = await _getJsonData('3/movie/upcoming');

    final upcomingResponse = nowPlayingResponseFromJson(jsonData);
    movies = upcomingResponse.results;
    return movies;
  }

  Future<List<Movie>> getTopRated() async {
    List<Movie> movies = [];
    final jsonData = await _getJsonData('3/movie/top_rated');
    final topRatedResponse = popularResponseFromJson(jsonData);
    movies = topRatedResponse.results;
    return movies;
  }

  Future<List<Movie>> getPopularMovies() async {
    List<Movie> movies = [];
    final jsonData = await _getJsonData('3/movie/popular');

    final popularResponse = popularResponseFromJson(jsonData);

    movies = popularResponse.results;

    return movies;
  }

  Future<List<Cast>> getMovieCast(int movieId) async {
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = creditResponseFromJson(jsonData);
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    Response response = await get(Uri.https(
      _baseUrl,
      '3/search/movie',
      {
        'api_key': _apiKey,
        'language': _languaje,
        'query': query,
      },
    ));

    final searchResponse = searchResponseFromJson(response.body);

    return searchResponse.results;
  }

  Future<String> _getJsonData(String endpoint, [int page = 1]) async {
    Response response = await get(Uri.https(
      _baseUrl,
      endpoint,
      {
        'api_key': _apiKey,
        'language': _languaje,
        'page': '$page',
      },
    ));
    return response.body;
  }

  Future<ActorResponse> getActor(String id) async {
    Response response = await get(Uri.https(
      _baseUrl,
      '3/person/$id',
      {
        'api_key': _apiKey,
        'language': _languaje,
      },
    ));

    final actorResponse = ActorResponse.fromJson(jsonDecode(response.body));
    return actorResponse;
  }

  Future<List<Movie>> getFavs() async {
    List<Movie> favsTemp = [];
    Response response = await get(Uri.parse(urlFirebase + '.json'));
    if (jsonDecode(response.body) == null) return favsTemp;
    Map<String, dynamic> json = jsonDecode(response.body);
    json.forEach((idFirebase, movie) {
      final Movie movieTemp = Movie.fromJson(movie);
      movieTemp.isFavorite = true;
      movieTemp.idFirebase = idFirebase;
      favsTemp.add(movieTemp);
    });
    return favsTemp;
  }

  Future<void> updateFavs(Movie movie) async {
    if (movie.idFirebase != null || movie.idFirebase != "") {
      await delete(Uri.parse("$urlFirebase/${movie.idFirebase}.json"));
    }
    if (movie.isFavorite!) {
      Response response = await post(Uri.parse("$urlFirebase.json"),
          body: jsonEncode(movie.toJson()));
      Map<String, dynamic> data = jsonDecode(response.body);
      movie.idFirebase = data.values.first;
    }
  }

  Future<VideoResponse> getVideo(String movieId) async {
    var url = Uri.https(_baseUrl, '/3/movie/${movieId}/videos',
        {'api_key': _apiKey, 'language': _languaje});
    Response response = await get(url);
    final videoResponse = VideoResponse.fromJson(jsonDecode(response.body));
    return videoResponse;
  }

  Future<Movie> getMoviebyID(String idMovie) async {
    Response response = await get(Uri.https(
      _baseUrl,
      '3/movie/$idMovie',
      {
        'api_key': _apiKey,
        'language': _languaje,
      },
    ));

    final movie = Movie.fromJson(jsonDecode(response.body));
    return movie;
  }

  Future<ActorResponse> getActorByID(String idActor) async {
    Response response = await get(Uri.https(
      _baseUrl,
      '3/person/$idActor',
      {
        'api_key': _apiKey,
        'language': _languaje,
      },
    ));
    final actor = ActorResponse.fromJson(jsonDecode(response.body));
    return actor;
  }
}
