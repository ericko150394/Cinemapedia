import 'package:cinemapedia/config/constants/enviroment.dart';
import 'package:cinemapedia/domain/datasources/actors_datasource.dart';
import 'package:cinemapedia/domain/entities/actor.dart';
import 'package:cinemapedia/infrastructure/mappers/actor_mapper.dart';
import 'package:cinemapedia/infrastructure/models/moviedb/credits_response.dart';
import 'package:dio/dio.dart';

class ActorMovieDataSourceImpl extends ActorsDatasoruce {
  
  //(1) Creamos nuestro objeto dio
  final dio = Dio(BaseOptions(
      baseUrl: 'https://api.themoviedb.org/3',
      queryParameters: {
        'api_key': Enviroment.movieDbKey,
        'language': 'es-MX'
      }));

  @override
  Future<List<Actor>> getActorsByMovie(String movieId) async {
    //(2) Generamos la petición/repuesta del API:
    final response = await dio.get('/movie/$movieId/credits');

    //(3) Convertimos en una lista (Actor) nuestra respuesta:
    final creditsResponse = CreditsResponse.fromJson(
        response.data); //<-- Objeto con todas las propiedades

    List<Actor> actors = creditsResponse.cast
        .map((cast) => ActorMapper.castToEntity(cast))
        .toList();

    return actors;
  }
}
