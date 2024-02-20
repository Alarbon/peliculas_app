import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/share_preferences/preferences.dart';
import 'package:provider/provider.dart';

import '../models/models.dart';

class CastingCards extends StatelessWidget {
  final int movieId;
  const CastingCards({super.key, required this.movieId});

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context, listen: false);

    return FutureBuilder(
        future: moviesProvider.getMovieCast(movieId),
        builder: (_, AsyncSnapshot<List<Cast>> snapshot) {
          if (!snapshot.hasData) {
            return Container(
              constraints: const BoxConstraints(maxWidth: 150),
              height: 180,
              child: const Center(
                child: CupertinoActivityIndicator(),
              ),
            );
          }

          final List<Cast> cast = snapshot.data!;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Text(
                  'Actores',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ),
              Container(
                margin: const EdgeInsets.only(bottom: 30),
                width: double.infinity,
                height: 180,
                child: ListView.builder(
                  itemCount: cast.length,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (_, int index) => GestureDetector(
                      onTap: () async {
                        await moviesProvider.getActor(cast[index]);
                        Preferences.idLastActor = cast[index].id.toString();
                        Preferences.lastPage = 'details-actor';
                        // ignore: use_build_context_synchronously
                        Navigator.pushNamed(context, 'details-actor',
                            arguments: cast[index]);
                      },
                      child: _CastCard(cast: cast[index])),
                ),
              ),
            ],
          );
        });
  }
}

class _CastCard extends StatelessWidget {
  final Cast cast;
  const _CastCard({super.key, required this.cast});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      width: 110,
      height: 100,
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: FadeInImage(
              placeholder: const AssetImage('assets/images/no-image.jpg'),
              image: NetworkImage(cast.fullProfilePath),
              height: 135,
              width: 100,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          Text(
            cast.name,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
