import 'package:cinemapedia/domain/entities/movie.dart';
import 'package:cinemapedia/domain/repositories/local_storage_repository.dart';
import 'package:cinemapedia/presentation/providers/providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final favoriteMoviesProvider = StateNotifierProvider<StorageMoviesNotifier, Map<int, Movie>>((ref) {
  final localStorageRepository = ref.watch(localStorageRepositoryProvider);
  
  return StorageMoviesNotifier(localStorageRepository: localStorageRepository);
});

//Los datos van a devolverse como un mapa:
/*
  {
    123: Movie
    957: Movie
    832: Movie
  }
*/

class StorageMoviesNotifier extends StateNotifier<Map<int, Movie>>{
  int page = 0;
  final LocalStorageRepository localStorageRepository; //<--- Repositorio que llama al datasource
  
  StorageMoviesNotifier({required this.localStorageRepository}): super({}); //<--- Constructor

  Future<List<Movie>> loadNextPage() async{
    final movies = await localStorageRepository.loadMovies(offset: page * 10, limit: 100); //<--- Carga las primeras 10 películas
    page++; //<--- Incrementa la página

    //Actualizamos el state:
    final tempMoviesMap = <int, Movie>{};
    for(final movie in movies){
      tempMoviesMap[movie.id] = movie;
    }

    state = {...state, ...tempMoviesMap}; //state es el mapa de datos, y al realizar un spred '...' del estado anterior, notificamos de algun cambio
    return movies;
  }

  //Realiza la misma función que tiene el iconButton:
  Future<void> toogleFavorite(Movie movie) async{
    await localStorageRepository.toogleFavorite(movie);
    final bool isMovieInFavorites= state[movie.id] != null; //Si la película existe...

    if ( isMovieInFavorites ) {
      state.remove(movie.id); //Removemos película
      state = {...state};
    }else{
      state = {...state, movie.id: movie}; //Añadimos la película
    }

  }
}