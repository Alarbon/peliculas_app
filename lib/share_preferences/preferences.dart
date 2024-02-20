import 'package:shared_preferences/shared_preferences.dart';

class Preferences {
  static late SharedPreferences _preferences;

  static List<String> _historyMovies = [];

  static String _idLastMovie = '';

  static String _idLastActor = '';

  static String _lastPage = '';

  static Future init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static List<String> get historyMovies {
    final movies = _preferences.getStringList('history');
    return movies?.map((movie) => movie).toList() ?? [];
  }

  static set historyMovies(List<String> moviesHistory) {
    _historyMovies = moviesHistory;
    //elimino las preferencias
    _preferences.remove('history');
    //guardo las nuevas preferencias
    _preferences.setStringList('history', _historyMovies);
  }

  static String get idLastMovie {
    return _preferences.getString('idLastMovie') ?? '';
  }

  static set idLastMovie(String id) {
    _idLastMovie = id;

    _preferences.setString('idLastMovie', _idLastMovie);
  }

  static String get idLastActor {
    return _preferences.getString('idLastActor') ?? '';
  }

  static set idLastActor(String id) {
    _idLastActor = id;
    _preferences.setString('idLastActor', _idLastActor);
  }

  static String get lastPage {
    return _preferences.getString('lastPage') ?? 'home';
  }

  static set lastPage(String page) {
    _lastPage = page;
    _preferences.setString('lastPage', _lastPage);
  }
}
