import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';

final searchQueryProvider = StateProvider<String>((ref) => '');

final searchedMoviesProvider = StateNotifierProvider<SearchedMoviesNotifier, List<Movie>>((ref) {
  final moviesRepository = ref.read(movieRepositoryProvider);
  return SearchedMoviesNotifier(
      searchMovies: moviesRepository.getSearchMovies,
      ref: ref);
});

//Función personzalida: Es igual a una función que recibe un string y devolvera una lista de movie
typedef SearchMoviesCallback = Future<List<Movie>> Function(String query);

class SearchedMoviesNotifier extends StateNotifier<List<Movie>> {
  SearchedMoviesNotifier({required this.searchMovies, required this.ref})
      : super([]); //<-- Creamos el constructor para declarar el estado inicial

  final SearchMoviesCallback searchMovies;
  final Ref ref;

  Future<List<Movie>> searchMovieByQuery(String query) async {
    final List<Movie> movies = await searchMovies(query);
    ref.read(searchQueryProvider.notifier).update((state) => query);

    state = movies;
    return movies;
  }
}
