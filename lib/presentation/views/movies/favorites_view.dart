import 'package:cinemapedia/presentation/providers/storage/favorite_movies_provider.dart';
import 'package:cinemapedia/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class FavoritesView extends ConsumerStatefulWidget {
  const FavoritesView({super.key});

  @override
  FavoritesViewState createState() => FavoritesViewState();
}

class FavoritesViewState extends ConsumerState<FavoritesView> {
  //Validaciones:
  bool isLastPage = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();

    //Método para cargar películas:
    loadNextPage();
  }

  //Método
  void loadNextPage() async {
    if (isLoading || isLastPage) return;

    isLoading = true;
    final movies =
        await ref.read(favoriteMoviesProvider.notifier).loadNextPage();

    if (movies.isEmpty) {
      isLastPage = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoritesMovies = ref.watch(favoriteMoviesProvider).values.toList();
    final colors = Theme.of(context).colorScheme;

    if (favoritesMovies.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/perro_meh.png',
              scale: 1.5,
            ),
            Text(
              'Oh no!!',
              style: TextStyle(fontSize: 30, color: colors.primary),
            ),
            const Text(
              '¿Enserio no tienes películas favoritas :/?',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20, color: Colors.black54),
            ),
            SizedBox(
              child: FilledButton.tonal(
                onPressed: () => context.go('/home/0'),
                child: const Text('Buscate unas pelis'),
              ),
            )
          ],
        ),
      );
    }

    return Scaffold(
        appBar: AppBar(
          title: const Text('Favorites View'),
        ),
        body: MovieMasonry(
          loadNextPage: loadNextPage,
          movies: favoritesMovies,
        ));
  }
}
