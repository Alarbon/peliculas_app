import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/search/search_delegate.dart';
import 'package:peliculas_app/share_preferences/preferences.dart';
import 'package:provider/provider.dart';

import '../widgets/widgets.dart';
import 'favorite_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const SafeArea(child: _HomeNavbarView());
  }
}

class _HomeNavbarView extends StatefulWidget {
  const _HomeNavbarView({super.key});

  @override
  State<_HomeNavbarView> createState() => _HomeNavbarViewState();
}

class _HomeNavbarViewState extends State<_HomeNavbarView> {
  int _selectedIndex = 0;
  static final List<Widget> _widgetOptions = <Widget>[
    const HomeView(),
    const FavoriteScreen()
    // const PlayerDetailsScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star_rounded),
            label: 'Películas Favoritas',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.yellow[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

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
            Preferences.lastPage = 'history',
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
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            tileMode: TileMode.decal,
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black12,
              Colors.yellow[800]!,
              Colors.black38,
            ],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CardSwiper(movies: moviesProvider.onDisplayMovies),
              MovieSlider(
                movies: moviesProvider.popularMovies,
                title: 'Populares',
                onNextPage: () => moviesProvider.getPopularMovies(),
              ),
              const SizedBox(height: 20.0),
              MovieSlider(
                movies: moviesProvider.topRatedMovies,
                title: 'Mejor Valoradas',
                onNextPage: () => moviesProvider.getTopRatedMovies(),
              ),
              const SizedBox(height: 20.0),
              MovieSlider(
                  movies: moviesProvider.upcomingMovies,
                  title: 'Próximamente',
                  onNextPage: () => moviesProvider.getUpcomingMovies()),
            ],
          ),
        ),
      ),
    );
  }
}
