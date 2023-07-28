import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:flutter/material.dart';
import 'package:animate_do/animate_do.dart';
import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';


class MovieScreen extends ConsumerStatefulWidget {
  static const String name = 'movie-screen';
  const MovieScreen({super.key, required this.movieId});

  final String movieId;

  @override
  ConsumerState<MovieScreen> createState() => _MovieScreenState();
}

class _MovieScreenState extends ConsumerState<MovieScreen> {
  @override
  void initState() {
    //NOTA: Dentro de métodos utilizamos .read() y no .watch()

    super.initState();
    ref.read(movieInfoProvider.notifier).loadMovie(widget.movieId);
    ref.read(actorByMovieProvider.notifier).loadActors(widget.movieId);
  }

  @override
  Widget build(BuildContext context) {
    final Movie? movie = ref.watch(movieInfoProvider)[widget.movieId];

    if (movie == null) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
        ),
      );
    }

    return Scaffold(
      body: CustomScrollView(
        physics: const ClampingScrollPhysics(),
        slivers: [
          _CustomSliverAppBar(movie: movie),
          SliverList(
            delegate: SliverChildBuilderDelegate(
                (context, index) => _MoviDetails(movie: movie),
                childCount: 1),
          )
        ],
      ),
    );
  }
}

class _MoviDetails extends StatelessWidget {
  final Movie movie;
  const _MoviDetails({required this.movie});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final textStyles = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.network(
                  movie.posterPath,
                  width: size.width * 0.3,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              SizedBox(
                width: (size.width - 40) * 0.7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      movie.title,
                      style: textStyles.titleLarge,
                    ),
                    Text(movie.overview),
                  ],
                ),
              )
            ],
          ),
        ),

        //TODO: Generos de la película
        Padding(
          padding: const EdgeInsets.all(8),
          child: Wrap(children: [
            ...movie.genreIds.map((genre) => Container(
                  margin: const EdgeInsets.only(right: 10),
                  child: Chip(
                    label: Text(genre),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                  ),
                )),
          ]),
        ),

        //TODO: Mostrar actores de la película:
        _ActorsByMovie(movieId: movie.id.toString()),

        const SizedBox(
          height: 100,
        )
      ],
    );
  }
}

class _ActorsByMovie extends ConsumerWidget {
  final String movieId;

  const _ActorsByMovie({required this.movieId});

  @override
  Widget build(BuildContext context, ref) {
    final actorsByMovie = ref.watch(actorByMovieProvider);

    if (actorsByMovie[movieId] == null) {
      return const CircularProgressIndicator(
        strokeWidth: 2,
      );
    }

    final actors = actorsByMovie[movieId]!;

    return SizedBox(
        height: 300,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: actors.length,
          itemBuilder: (context, index) {
            final actor = actors[index];

            return Container(
              padding: const EdgeInsets.all(8.0),
              width: 135,
              child: Column(
                children: [
                  FadeInRight(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: Image.network(
                        actor.profilePath,
                        height: 180,
                        width: 135,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    textAlign: TextAlign.center,
                    actor.name,
                    maxLines: 2,
                  ),
                  Text(
                    textAlign: TextAlign.center,
                    actor.character ?? '',
                    maxLines: 2,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        ));
  }
}

//Manejar un future que devuelva un 'boolean' (FutureProvider sirve para tareas asincronas y recibir valores al resolverse)
//Usando .family, podemos recibir un parámetro, en este caso para buscar una película
//Es decir, FutureProviderFamily emitira un 'boolean' y recibe un parámetro 'int'
final isFavoriteProvider = FutureProvider.family.autoDispose((ref, int movieId) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  return localStorageRepository.isMovieFavorite(movieId);
}); 

class _CustomSliverAppBar extends ConsumerWidget {
  final Movie movie;

  const _CustomSliverAppBar({required this.movie});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    //El icon será creado a partir de una instancia de nuestro provider: isFavoriteProvider
    final isFavoriteFuture = ref.watch(isFavoriteProvider(movie.id));


    final size = MediaQuery.of(context).size;

    return SliverAppBar(
      backgroundColor: Colors.black,
      expandedHeight: size.height * 0.7,
      foregroundColor: Colors.white,
      actions: [
        IconButton(
          onPressed: () async {
            //await ref.read(localStorageRepositoryProvider).toogleFavorite(movie); <--- Comentamos este llamado para...

            //Ahora llamamos el método desde favoriteMoviesProvider:
            await ref.read(favoriteMoviesProvider.notifier).toogleFavorite(movie); 

            ref.invalidate(isFavoriteProvider(movie.id)); //Invalida el estado del provider y lo regresa a su estado original
          },
          icon: isFavoriteFuture.when(
            loading: ()=> const CircularProgressIndicator(strokeWidth: 2,),
            data: (isFavorite) => isFavorite 
              ? const Icon(Icons.favorite_rounded, color: Colors.red,)
              : const Icon(Icons.favorite_border), 
            error: (_, __) => throw UnimplementedError())
        )
      ],
      flexibleSpace: FlexibleSpaceBar(
        titlePadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        title: Text(
          movie.title,
          style: const TextStyle(fontSize: 20),
          textAlign: TextAlign.start,
        ),
        background: Stack(
          children: [
            SizedBox.expand(
              child: Image.network(
                movie.posterPath,
                fit: BoxFit.cover,
                loadingBuilder: (context, child, loadingProgress) {
                  //Si la imagen aun no ha cargado...
                  if (loadingProgress != null) return const SizedBox();
                  return FadeIn(child: child);
                },
              ),
            ),
            
            //Método 1) Sizebox.expanded creados uno por separado:
            /* const SizedBox.expand(
              //<--- Gradiente del icon button de favorito
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topRight,
                    end: Alignment.bottomLeft,
                    stops: [0.0, 0.2],
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    stops: [0.7, 1.0],
                    colors: [
                      Colors.transparent,
                      Colors.black87,
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox.expand(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    stops: [0.0, 0.4],
                    colors: [
                      Colors.black87,
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ), */
          
            //Método 2) Sizebox.expanded creados a partir de una clase:
            const _CustomGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                stops: [0.0, 0.2],
                colors: [
                  Colors.black54,
                  Colors.transparent,
                ]),

            const _CustomGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: [0.7, 1.0],
                colors: [
                  Colors.transparent,
                  Colors.black87,
                ]),

            const _CustomGradient(
                begin: Alignment.topLeft,
                stops: [0.0, 0.4],
                colors: [
                  Colors.black87,
                  Colors.transparent,
                ]),
          ],
        ),
      ),
    );
  }
}

class _CustomGradient extends StatelessWidget {
  const _CustomGradient(
      {super.key,
      this.begin = Alignment.centerRight,
      this.end  = Alignment.centerLeft,
      required this.stops,
      required this.colors});

  //Parametros opcionales:
  final AlignmentGeometry? begin;
  final AlignmentGeometry? end;
  final List<double>? stops;
  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: begin!,
            end: end!,
            stops: stops,
            colors: colors!,
          ),
        ),
      ),
    );
  }
}
