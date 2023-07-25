//Creara la nueva instancia de nuestro Movie_Repository_Impl
import 'package:cinemapedia/infrastructure/datasources/actor_moviedb_datasource_impl.dart';
import 'package:cinemapedia/infrastructure/repositories/actor_repository_impl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

//Repositorio Inmutable
final actorsRepositoryProvider = Provider((ref) {
  return ActorRepositoryImpl(datasource: ActorMovieDataSourceImpl()); //Recibe un origen de datos
});