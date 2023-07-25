import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/presentation/providers/movies/movies_repository_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Provider
final movieInfoProvider = StateNotifierProvider<MovieMapNotifier, Map<String, Movie>>((ref) {

  final movieRepository =  ref.watch(movieRepositoryProvider);

  return MovieMapNotifier(getMovie: movieRepository.getMovieById);
});

typedef GetMovieCallBack = Future<Movie>Function(String movieId);

class MovieMapNotifier extends StateNotifier <Map<String, Movie>>{
  MovieMapNotifier({required this.getMovie}) : super({});

  final GetMovieCallBack getMovie;

  Future <void> loadMovie(String movieId) async {
    if(state[movieId] != null ) return; //Si nuestro estado ya tiene un estado con ese id, no realizamos una petición
    //print('realizando petición http');
    final movie = await getMovie(movieId);

    state = {...state, movieId: movie }; //Generamos un nuevo estado (Clonamos el estado anterior, añadimos el movieId que apunta a movie)
  }
}