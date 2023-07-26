//Archivo que implementa una BD local, en este caso la BD es de Isar

import 'package:cinemapedia/domain/entities/movie.dart';

abstract class LocalStorageDatasource {
  Future<void> toogleFavorite(Movie movie);

  Future<bool> isMovieFavorite(int id);

  Future <List<Movie>> loadMovies ({int limit = 10, offset = 0});
}