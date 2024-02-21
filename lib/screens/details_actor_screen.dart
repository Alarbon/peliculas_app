import 'package:flutter/material.dart';
import 'package:peliculas_app/models/models.dart';
import 'package:peliculas_app/providers/movies_provider.dart';
import 'package:peliculas_app/share_preferences/preferences.dart';
import 'package:provider/provider.dart';

class DetailsActorScreen extends StatelessWidget {
  const DetailsActorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final MoviesProvider moviesProvider = Provider.of<MoviesProvider>(context);
    final ActorResponse? actor = moviesProvider.actor;
    return SafeArea(
      child: Scaffold(
        body: actor == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : CustomScrollView(
                slivers: [
                  _CustomAppBar(),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        _PosterAndTitle(),
                        const _Overview(),
                        const SizedBox(
                          height: 30,
                        ),
                      ],
                    ),
                  )
                ],
              ),
      ),
    );
  }
}

class _CustomAppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    Preferences.lastPage = 'details-actor';
    return SliverAppBar(
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios, size: 30, color: Colors.white),
        onPressed: () => {
          Navigator.canPop(context)
              ? Preferences.lastPage = 'details'
              : Preferences.lastPage = 'home',

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
          padding: const EdgeInsets.only(bottom: 10.0),
          alignment: Alignment.bottomCenter,
          color: Colors.black12,
          width: double.infinity,
          child: Text(
            moviesProvider.actor?.name ?? 'Sin nombre',
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
        background: FadeInImage(
          placeholder: const AssetImage('assets/images/loading.gif'),
          image: NetworkImage(moviesProvider.actor!.fullprofilePath),
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({super.key});

  @override
  Widget build(BuildContext context) {
    final ActorResponse actor = Provider.of<MoviesProvider>(context).actor!;
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(20),
      ),
      margin: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Text(
        actor.getBibliography!,
        textAlign: TextAlign.justify,
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }
}

class _PosterAndTitle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(top: 20.0),
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: FadeInImage(
              height: 200.0,
              placeholder: const AssetImage('assets/images/no-image.jpg'),
              image: NetworkImage(moviesProvider.actor!.fullprofilePath),
            ),
          ),
          const SizedBox(
            width: 20.0,
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: size.width - 200),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white10,
                borderRadius: BorderRadius.circular(20.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      moviesProvider.actor!.name.toString(),
                      style: Theme.of(context).textTheme.headlineSmall,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Text(
                      moviesProvider.actor?.placeOfBirth ??
                          'Sin lugar de nacimiento',
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    Row(
                      children: [
                        const Icon(
                          Icons.cake,
                          size: 15,
                          color: Colors.grey,
                        ),
                        const SizedBox(
                          width: 5.0,
                        ),
                        Text(
                          '${moviesProvider.actor?.birthdayFormated}',
                          style: Theme.of(context).textTheme.bodySmall,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
