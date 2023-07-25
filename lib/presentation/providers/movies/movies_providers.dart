//Clase y reutilización de como se solicita la información (ViewModel)

import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider (Pelis en Cine)
final nowPlayingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getNowPlaying;
  
  return MoviesNotifier(
    fetchMoreMovies: fetchMoreMovies//La función viene de 'movies_repository_provider.dart'
  ); //Proporciar la función/parametro de 'fetchMoreMovies'
});

//Provider (Pelis Populares)
final popularMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getPopular;
  
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

//Provider (Pelis proximas)
final upcomingMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getUpComing;
  
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

//Provider (Pelis Mejor Calificadas)
final topRatedMoviesProvider = StateNotifierProvider<MoviesNotifier, List<Movie>>((ref) {
  final fetchMoreMovies = ref.watch(movieRepositoryProvider).getTopRated;
  
  return MoviesNotifier(fetchMoreMovies: fetchMoreMovies);
});

typedef MovieCallback = Future <List<Movie>> Function({int page}); //Devolvera una lista de Movie

class MoviesNotifier extends StateNotifier<List<Movie>>{ //La clase MoviesNotifier, recibira la función movieCallback

  int currentPage = 0;
  bool isLoading = false;
  MovieCallback fetchMoreMovies;

  MoviesNotifier({required this.fetchMoreMovies}) : super([]);

  Future<void> loadNextPage() async{
    //Evitar que se carguen más peliculas de las solicitadas
    if(isLoading) return; //Si esta en true , no hago nada

    //Este método modificara el 'state'}
    isLoading = true;
    print('loading more movies');
    currentPage++;

    final List<Movie> movies = await fetchMoreMovies(page: currentPage);
    state = [...state, ...movies];
    isLoading = false;
  }

}