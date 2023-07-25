//NOTA: ¿Como funciona la implementación del repositorio?
//Se utiliza lo mismo que en la implementación del DataSource, pero este solicita un DataSource (actors_datasource.dart)

import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/domain/repositories/actors_repository.dart';

class ActorRepositoryImpl extends ActorsRepository{
  final ActorsDatasoruce datasource; //(1) 
  ActorRepositoryImpl({required this.datasource}); //(2)

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) {
    return datasource.getActorsByMovie(movieId); //(3)
  }
}