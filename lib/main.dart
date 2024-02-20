import 'package:flutter/material.dart';
import 'package:peliculas_app/share_preferences/preferences.dart';
import 'package:provider/provider.dart';

import 'screens/screens.dart';
import 'providers/movies_provider.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Preferences.init();
  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => MoviesProvider(),
          lazy: false,
        ),
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Peliculas',
      debugShowCheckedModeBanner: false,
      initialRoute: Preferences.lastPage,
      routes: {
        'home': (_) => const HomeScreen(),
        'details': (_) => const DetailsMovieScreen(),
        'details-actor': (_) =>  const DetailsActorScreen(),
        'history': (_) => const HistoryScreen(),
      },
      theme: ThemeData.dark().copyWith(
        appBarTheme:  AppBarTheme(
          color: Colors.yellow[800]!,
          centerTitle: true,
          titleTextStyle: const TextStyle(
              color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
