import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/search/search_delegate.dart';
import 'package:peliculas_app/share_preferences/preferences.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatelessWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    if (moviesProvider.historyMovies.isEmpty) {
      return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Alarbon Films'),
            elevation: 0,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios_new_rounded,
                size: 30.0,
                color: Colors.white,
              ),
              onPressed: () => {
                Preferences.lastPage = 'home',
                Navigator.canPop(context)
                    ? Navigator.pop(context)
                    : Navigator.pushNamed(context, 'home'),
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
          body: const Center(
            child: Text('Historial vacío'),
          ),
        ),
      );
    }
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Historial'),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 30.0,
              color: Colors.white,
            ),
            onPressed: () => {
              Preferences.lastPage = 'home',
              Navigator.canPop(context)
                  ? Navigator.pop(context)
                  : Navigator.pushNamed(context, 'home'),
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
          itemCount: moviesProvider.historyMovies.length,
          itemBuilder: (_, index) {
            String term = moviesProvider.historyMovies[index];
            return ListTile(
              title: Text(term),
              onTap: () async => {
                // ignore: use_build_context_synchronously
                showSearch(
                    context: context,
                    delegate: MovieSearchDelegate(),
                    query: term),
              },
            );
          },
        ));
  }
}
