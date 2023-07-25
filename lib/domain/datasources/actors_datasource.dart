import 'package:cinemapedia/domain/entities/actor.dart';

abstract class ActorsDatasoruce{
  Future<List<Actor>> getActorsByMovie(String movieId);
}