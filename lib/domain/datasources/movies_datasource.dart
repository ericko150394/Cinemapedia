import 'package:cinemapedia/domain/entities/movie.dart';

abstract class MoviesDataSource{
  //Origen de datos (No importa de donde vengan)
  
  //Métodos que requiero para obtener esos datos
  Future<List<Movie>> getNowPlaying({int page = 1, });

  Future<List<Movie>> getPopular({int page = 1, });

  Future<List<Movie>> getUpComing({int page = 1, });
  Future<List<Movie>> getTopRated({int page = 1, });

  Future<Movie> getMovieById(String id);

  Future<List<Movie>> getSearchMovies(String search);
}