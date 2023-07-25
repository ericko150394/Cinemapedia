//Creara la nueva instancia de nuestro Movie_Repository_Impl

import 'package:cinemapedia/infrastructure/datasources/moviedb_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/repositories/movie_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Repositorio Inmutable
final movieRepositoryProvider = Provider((ref) {
  return MovieRepositoryImpl(dataSource: MovieDbDataSource()); //Recibe un origen de datos
});